import os
import subprocess
import re

# Directory dove sono i file
BASE_DIR = "lezioni"

print(f"Analisi directory '{BASE_DIR}'...")

tags_found = set()

# Mappatura cartelle -> Prefisso Lezione
for root, dirs, files in os.walk(BASE_DIR):
    folder_name = os.path.basename(root)
    if not folder_name or '-' not in folder_name:
        continue
        
    try:
        lesson_part = folder_name.split('-')[0]
        lesson_num = int(lesson_part)
        lesson_prefix = f"L{lesson_num}"
        
        for f in files:
            if f.endswith(".md"):
                # Prova vari formati: '01-titolo.md' o 'L3.01.md' o 'async-05.md'
                nums = re.findall(r'\d+', f)
                if nums:
                    section_num = nums[0].zfill(2)
                    tag = f"[{lesson_prefix}.{section_num}]"
                    tags_found.add(tag)
    except (ValueError, IndexError):
        continue

if not tags_found:
    print("Nessun file markdown trovato.")
    exit()

print(f"Trovati {len(tags_found)} file su disco {sorted(list(tags_found))[:5]}...")

# Recupero task
tasks_list = subprocess.run(["ralph", "tools", "task", "list", "--format", "json"], capture_output=True, text=True).stdout
import json
try:
    tasks = json.loads(tasks_list)
except:
    tasks = []

count = 0
for task in tasks:
    task_id = task['id']
    title = task['title']
    status = task['status']
    
    if status == 'closed':
        continue
        
    # Se il tag del file è nel titolo del task, chiudilo
    for tag in tags_found:
        if tag in title:
            print(f"✅ Chiudo task {task_id} per {tag} ('{title}')")
            subprocess.run(["ralph", "tools", "task", "close", task_id])
            count += 1
            break

print(f"\nSincronizzazione completata! {count} task chiusi.")
