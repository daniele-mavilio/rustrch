
import subprocess
import time
import os
import re
import requests
from rich.console import Console
from rich.layout import Layout
from rich.panel import Panel
from rich.table import Table
from rich.live import Live
from rich.text import Text
from rich import box
from rich.style import Style

console = Console()

# Tenta di recuperare la chiave da diverse fonti
def find_api_key():
    # 1. Variabili d'ambiente
    key = os.environ.get("OPENROUTER_API_KEY") or os.environ.get("OPENCODE_API_KEY")
    if key: return key
    
    # 2. File di config locali (WSL/Linux paths)
    paths = [
        os.path.expanduser("~/.opencode/config.json"),
        os.path.expanduser("~/.config/opencode/config.json"),
        os.path.expanduser("~/.opencode/state.json"),
        ".env"
    ]
    for p in paths:
        if os.path.exists(p):
            try:
                with open(p, 'r') as f:
                    content = f.read()
                    # Cerca pattern sk-or-v1-...
                    match = re.search(r'sk-or-v1-[a-zA-Z0-9]+', content)
                    if match: return match.group(0)
                    
                    # Se è un JSON, prova a caricarlo
                    import json
                    f.seek(0)
                    data = json.load(f)
                    return data.get("OPENROUTER_API_KEY") or data.get("api_key") or data.get("token")
            except: pass
    return None

api_key = find_api_key()

def get_openrouter_balance():
    if not api_key:
        return "[bold red]No Key found[/]"
    try:
        response = requests.get(
            "https://openrouter.ai/api/v1/credits",
            headers={"Authorization": f"Bearer {api_key}"},
            timeout=5
        )
        if response.status_code == 200:
            data = response.json()
            total_credits = data.get('data', {}).get('total_credits', 0)
            total_usage = data.get('data', {}).get('total_usage', 0)
            balance = total_credits - total_usage
            color = "green" if balance > 1 else "yellow" if balance > 0.1 else "red"
            return f"[bold {color}]${balance:.4f}[/]"
        return f"[dim]HTTP {response.status_code}[/]"
    except:
        return "[dim]Conn Error[/]"

def parse_ralph_table(raw_output, max_rows=15, is_events=True):
    """Parsa l'output tabellare di ralph e lo converte in una Table di Rich colorata."""
    lines = raw_output.strip().splitlines()
    if not lines:
        return Text("No data available", style="dim")

    # Trova la riga dell'header
    header_idx = -1
    for i, line in enumerate(lines):
        if '|' in line and any(c.isalpha() for c in line):
            header_idx = i
            break
    
    if header_idx == -1:
        return Text(raw_output, style="dim")

    cols = [c.strip() for c in lines[header_idx].split('|')]
    table = Table(box=box.SIMPLE, header_style="bold magenta", expand=True, show_edge=False)
    
    for col in cols:
        table.add_column(col)

    # Dati (saltiamo header e separatore)
    data_lines = [l for l in lines[header_idx+1:] if '|' in l and '-+-' not in l and not l.strip().startswith('+')]
    
    # Per gli eventi mostriamo gli ultimi, per i task i primi
    display_lines = data_lines[-max_rows:] if is_events else data_lines[:max_rows]
    
    for line in display_lines:
        cells = [c.strip() for c in line.split('|')]
        if len(cells) != len(cols): continue
        
        styled_cells = []
        for i, (col_name, cell) in enumerate(zip(cols, cells)):
            cell_text = cell
            col_lower = col_name.lower()
            
            # Colorazione per Hat
            if "hat" in col_lower:
                if "architect" in cell.lower(): cell_text = f"[bold magenta]{cell}[/]"
                elif "writer" in cell.lower(): cell_text = f"[bold yellow]{cell}[/]"
                elif "reviewer" in cell.lower(): cell_text = f"[bold cyan]{cell}[/]"
                elif "coordinator" in cell.lower(): cell_text = f"[bold green]{cell}[/]"
            
            # Colorazione per Topic / Status
            elif "topic" in col_lower or "status" in col_lower:
                if any(x in cell.lower() for x in ["fail", "reject", "error"]): cell_text = f"[bold red]{cell}[/]"
                elif any(x in cell.lower() for x in ["ok", "approve", "success", "closed"]): cell_text = f"[bold green]{cell}[/]"
                elif "written" in cell.lower(): cell_text = f"[bold blue]{cell}[/]"
                elif "ready" in cell.lower() or "open" in cell.lower(): cell_text = f"[bold yellow]{cell}[/]"
                elif "next" in cell.lower(): cell_text = f"[bold white]{cell}[/]"
            
            # Payload e Title (cyan sfumato per leggere meglio)
            elif "payload" in col_lower or "title" in col_lower:
                cell_text = f"[dim cyan]{cell[:60]}...[/]" if len(cell) > 60 else f"[dim cyan]{cell}[/]"
                
            styled_cells.append(cell_text)
            
        table.add_row(*styled_cells)

    return table

def get_stats():
    try:
        files_out = subprocess.run("find lezioni -name '*.md' | wc -l", shell=True, capture_output=True, text=True).stdout.strip()
        words_out = subprocess.run("find lezioni -name '*.md' -exec cat {} + | wc -w", shell=True, capture_output=True, text=True).stdout.strip()
        return files_out or "0", words_out or "0"
    except: return "0", "0"

def get_ralph_tasks():
    try:
        # Recupera la lista completa dei task
        res_tasks = subprocess.run(["ralph", "tools", "task", "list"], capture_output=True, text=True)
        res_events = subprocess.run(["ralph", "events"], capture_output=True, text=True)
        total_closed = res_events.stdout.count("task.close")
        open_count = res_tasks.stdout.lower().count("open")
        
        # Fallback se non ci sono eventi di chiusura espliciti
        if total_closed == 0 and open_count > 0:
            total_closed = max(0, 200 - open_count)

        task_table = parse_ralph_table(res_tasks.stdout, max_rows=10, is_events=False)
        return total_closed, open_count, task_table
    except:
        return 0, 0, Text("Error")

def update_dashboard(layout, balance):
    f_count, w_count = get_stats()
    done_count, todo_count, task_table = get_ralph_tasks()
    
    try:
        res_events = subprocess.run(["ralph", "events"], capture_output=True, text=True)
        event_table = parse_ralph_table(res_events.stdout, max_rows=15, is_events=True)
    except:
        event_table = Text("Error")
    
    # Update Layout
    layout["header"].update(Panel(
        f"[bold cyan]RALPH HUB[/] | [bold green]Files:[/] {f_count} | [bold blue]Words:[/] {w_count} | [bold yellow]OR Balance:[/] {balance}",
        box=box.HORIZONTALS, style="on black"
    ))
    
    layout["body"]["tasks"].update(Panel(
        task_table, title=f"[bold yellow]Task Queue ({done_count} Done, {todo_count} Todo)[/]", border_style="yellow"
    ))
    
    layout["body"]["events"].update(Panel(
        event_table, title="[bold cyan]Timeline Events[/]", border_style="cyan"
    ))

if __name__ == "__main__":
    layout = Layout()
    layout.split_column(Layout(name="header", size=3), Layout(name="body"))
    layout["body"].split_row(Layout(name="tasks", ratio=2), Layout(name="events", ratio=3))
    
    balance = "Checking..."
    last_balance_update = 0
    
    with Live(layout, refresh_per_second=1, screen=True) as live:
        try:
            while True:
                if time.time() - last_balance_update > 30:
                    balance = get_openrouter_balance()
                    last_balance_update = time.time()
                update_dashboard(layout, balance)
                time.sleep(2)
        except KeyboardInterrupt:
            pass
