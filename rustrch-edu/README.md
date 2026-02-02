# Rustrch Edu - Motore di Ricerca in Rust (Edizione Didattica)

📚 **Corso completo di Rust** attraverso la costruzione concettuale di un motore di ricerca personale.

---

## 🎯 Obiettivo

Questo progetto genera **materiale didattico completo** per insegnare Rust a principianti, usando come filo conduttore la costruzione di un motore di ricerca RAG (Retrieval-Augmented Generation).

**⚠️ IMPORTANTE:** Questo NON è codice eseguibile. È documentazione, pseudocodice e spiegazioni teoriche.

---

## 📋 Struttura del Corso

| Fase | Argomento | Concetti Rust |
|------|-----------|---------------|
| 01 | Crawling del File System | Async/await, Tokio, Path |
| 02 | Indicizzazione SQLite | rusqlite, serde, struct |
| 03 | Generazione Embedding | ONNX, vettori, similarità |
| 04 | Motore di Ricerca | BM25, ricerca ibrida |
| 05 | Testing e Ottimizzazione | Test, benchmark, Rayon |
| 06 | Conclusione | Riepilogo, risorse |

---

## 🚀 Avvio con Ralph Orchestrator

### Prerequisiti
- Ralph Orchestrator installato
- Codex CLI configurato (con OpenRouter se necessario)

### Comandi

```bash
# 1. Clona o entra nella directory
cd rustrch-edu

# 2. Avvia Ralph con la configurazione
ralph run -c ralph.yml -p "Inizia la lezione sul motore di ricerca in Rust"

# OPPURE usa il preset educativo
ralph run -c presets/educativo-lungo.yml -p "Inizia"

# 3. Monitora il progresso (in un altro terminale)
ralph health
ralph tools task list

# 4. Per intervento umano via Telegram (se configurato)
ralph bot status
```

---

## 📁 Struttura Repository

```
rustrch-edu/
├── ralph.yml              # Configurazione principale
├── PROMPT.md              # Brief per l'agent
├── README.md              # Questo file
├── specs/                 # Brief per ogni fase
│   ├── 01-crawling/
│   ├── 02-indicizzazione/
│   ├── 03-embeddings/
│   ├── 04-ricerca/
│   ├── 05-testing/
│   └── 06-conclusione/
├── lezione/               # OUTPUT: materiale generato
│   ├── 01-crawling/
│   ├── 02-indicizzazione/
│   └── ...
├── presets/               # Configurazioni alternative
│   └── educativo-lungo.yml
└── .ralph/                # Stato interno
    └── scratchpad.md
```

---

## ⚙️ Configurazione

### Configurare Codex + OpenRouter (su Termux)

```bash
# Imposta le variabili d'ambiente
export OPENROUTER_API_KEY="sk-or-v1-..."
export CODEX_PROVIDER="openrouter"
```

### Configurare Telegram Bot (opzionale)

```bash
# Crea bot con @BotFather, poi:
ralph bot onboard --telegram
# Segui le istruzioni per inserire token e chat ID
```

---

## 🎓 Per lo Studente

Dopo che Ralph ha generato il materiale in `lezione/`:

1. **Inizia dalla Fase 1** - Leggi i file in ordine
2. **Fai gli esercizi** - Scrivere aiuta a imparare
3. **Consulta le risorse** - Link a documentazione ufficiale
4. **Ripeti** - Non avere fretta, Rust ha una curva di apprendimento

---

## 🔧 Troubleshooting

### Ralph si ferma troppo presto
- Aumenta `max_runtime_seconds` in `ralph.yml`
- Verifica che ci siano task in sospeso: `ralph tools task list`

### Contenuto in inglese
- Verifica la regola "LINGUA: SOLO ITALIANO" in guardrails
- I modelli a volte ignorano: correggi manualmente

### Loop troppo veloce
- Aumenta `iteration_delay_ms` (es: 5000 per 5 secondi)
- Aggiungi più task granulari

---

## 📊 Durata Stimata

- **Fase 1:** 30-40 minuti di generazione
- **Fase 2:** 30-40 minuti
- **Fase 3:** 40-50 minuti
- **Fase 4:** 40-50 minuti
- **Fase 5:** 30-40 minuti
- **Fase 6:** 20-30 minuti

**Totale: 3-4 ore** di generazione continua

---

## 📝 Note per l'Uso su Termux

- I comandi possono essere lenti su Android
- Usa `timeout` se necessario: `timeout 120 comando`
- Git è disponibile per versionare il materiale
- Non servono dipendenze npm/cargo (solo testo!)

---

## 🤝 Contribuire

Questo è un progetto educativo. Se trovi errori o vuoi migliorare:
1. Modifica i file in `specs/`
2. Rilancia Ralph
3. Condividi miglioramenti

---

## 📚 Risorse Aggiuntive

- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [Rustlings](https://github.com/rust-lang/rustlings)
- [Ralph Orchestrator Docs](https://mikeyobrien.github.io/ralph-orchestrator/)

---

**Buon apprendimento! 🦀✨**
