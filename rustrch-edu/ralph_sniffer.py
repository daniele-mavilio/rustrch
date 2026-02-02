import json
import time
import os

LOG_FILE = ".ralph/history.jsonl"
OUTPUT_FILE = ".ralph/network_sniffer.log"

print(f"📡 Sniffer attivo su {LOG_FILE}...")
print(f"🚀 Risultati in {OUTPUT_FILE} (usa lnav per vederli)")

def sniff():
    if not os.path.exists(LOG_FILE):
        with open(LOG_FILE, 'w') as f: pass
    
    with open(LOG_FILE, 'r') as f:
        # Vai alla fine del file
        f.seek(0, 2)
        while True:
            line = f.readline()
            if not line:
                time.sleep(0.1)
                continue
            
            try:
                data = json.loads(line)
                ts = data.get('timestamp', '00T00:00:00.000000Z').split('T')[1][:8]
                model = data.get('model', 'ralph-core').replace('openrouter/', '')
                
                # Simuliamo i dettagli HTTP dai dati di Ralph
                # Ralph non logga i ms reali nel JSON, quindi calcoliamo una stima basata sul peso
                latency = len(line) // 10  # Esempio: 1.2s per 12kb
                size = len(line)
                method = "POST" if "choices" in data else "GET"
                status = 200 if "choices" in data or "event_type" in data else 500
                
                log_line = f"127.0.0.1 - - [{ts}] \"{method} /{model} HTTP/1.1\" {status} {size} {latency}ms\n"
                
                with open(OUTPUT_FILE, 'a') as out:
                    out.write(log_line)
                    
            except Exception as e:
                pass

if __name__ == "__main__":
    sniff()
