# ============================================================================
# PROMPT PRINCIPALE - MOTORE DI RICERCA PERSONALE IN RUST (EDIZIONE DIDATTICA)
# ============================================================================
# 
# Questo è il prompt principale per Ralph Orchestrator.
# Obiettivo: Generare materiale educativo completo in italiano.
# 
# REGOLA SUPREMA: ZERO codice eseguibile. Solo documentazione, pseudocodice,
# spiegazioni teoriche e risorse di apprendimento.
# ============================================================================

## 📚 BENVENUTO, AGENTE DIDATTICO

Stai per creare un **corso completo di Rust** sotto forma di documentazione
per costruire un motore di ricerca personale. Questo non è un progetto software
da implementare, ma un **percorso di apprendimento** per uno studente.

---

## 🎯 OBIETTIVO FINALE

Generare una repository `rustrch-edu/` contenente:

```
rustrch-edu/
├── README.md                    # Indice del corso
├── lezione/                     # Tutto il materiale didattico
│   ├── 01-crawling/
│   │   ├── 01-introduzione.md
│   │   ├── 02-concetti-rust.md
│   │   ├── 03-pseudocodice.md
│   │   ├── 04-spiegazione-dettagliata.md
│   │   ├── 05-risorse.md
│   │   └── 06-esercizi.md
│   ├── 02-indicizzazione/
│   ├── 03-embeddings/
│   ├── 04-ricerca/
│   ├── 05-testing/
│   └── 06-conclusione/
└── specs/                       # Brief per ogni fase (già presenti)
```

---

## 📋 STRUTTURA DELLE 6 FASI

### FASE 1: Crawling del File System
**Concetti Rust da insegnare:**
- I/O asincrono con `tokio`
- Funzioni ricorsive
- Gestione dei percorsi con `std::path`
- Metadati dei file

**Output atteso:**
- Spiegazione teorica dell'I/O asincrono
- Pseudocodice per esplorare directory
- Spiegazione di `tokio::fs::read_dir`
- Link a documentazione tokio

---

### FASE 2: Indicizzazione con SQLite
**Concetti Rust da insegnare:**
- Database SQLite con `rusqlite`
- Serializzazione con `serde`
- Strutture dati (`struct`)
- Error handling (`Result`)

**Output atteso:**
- Spiegazione di SQLite in Rust
- Pseudocodice per schema database
- Spiegazione di `serde` per JSON
- Link a documentazione rusqlite

---

### FASE 3: Generazione di Embedding
**Concetti Rust da insegnare:**
- Machine Learning in Rust
- ONNX Runtime con `ort`
- Vettori e array
- Similarità del coseno (teoria)

**Output atteso:**
- Spiegazione degli embedding (cosa sono e a cosa servono)
- Pseudocodice per caricare modello ONNX
- Spiegazione della similarità vettoriale
- Link a risorse ML in Rust

---

### FASE 4: Motore di Ricerca (BM25 + Semantico)
**Concetti Rust da insegnare:**
- Algoritmo BM25 (teoria)
- Ricerca full-text
- Combinazione di score
- Ordinamento risultati

**Output atteso:**
- Spiegazione teorica di BM25
- Pseudocodice per ricerca combinata
- Spiegazione di come funziona la ricerca ibrida
- Link a risorse su information retrieval

---

### FASE 5: Testing e Ottimizzazione
**Concetti Rust da insegnare:**
- Testing in Rust (`#[test]`)
- Benchmarking
- Ottimizzazione performance
- Parallelismo con `rayon`

**Output atteso:**
- Spiegazione del testing in Rust
- Pseudocodice per test del motore
- Spiegazione delle ottimizzazioni
- Link a Rust Performance Book

---

### FASE 6: Conclusione e Risorse
**Output atteso:**
- Riepilogo di tutto il corso
- Percorso consigliato per continuare
- Risorse aggiuntive
- Progetti simili da esplorare

---

## 📝 FORMATO STANDARD PER OGNI SEZIONE

Ogni file `.md` generato deve seguire questo template:

```markdown
# Titolo della Sezione (in italiano)

## 📖 Obiettivo di Apprendimento
Cosa imparerà lo studente da questa sezione.

## 🧠 Concetti Teorici
Spiegazione dettagliata del concetto Rust.

## 📝 Pseudocodice
```plaintext
funzione esempio(parametro):
    se condizione:
        restituisci valore
    altrimenti:
        restituisci altro
```

## 🔍 Spiegazione del Pseudocodice
Riga per riga, spiega cosa fa ogni parte.

## 💡 Esempio in Rust (commentato)
```rust
// Questo è un esempio didattico, NON codice eseguibile
// struct FileMetadata {
//     nome: String,
//     percorso: PathBuf,
// }
```

## 📚 Risorse per Approfondire
- [Link 1 - Documentazione ufficiale]
- [Link 2 - Tutorial]
- [Link 3 - Libro/corso]

## ❓ Domande di Verifica
1. Domanda 1?
2. Domanda 2?
3. Domanda 3?

## ✏️ Esercizi Proposti
1. Esercizio 1: ...
2. Esercizio 2: ...
```

---

## ⚠️ REGOLE FONDAMENTALI (LEGGERE ATTENTAMENTE)

### 1. LINGUA: SOLO ITALIANO
- ❌ NO: "This function returns..."
- ✅ SI: "Questa funzione restituisce..."
- ❌ NO: "File not found"
- ✅ SI: "File non trovato"
- ❌ NO titoli in inglese: "Introduction"
- ✅ SI titoli in italiano: "Introduzione"

### 2. ZERO CODICE ESEGUIBILE
- ❌ NO file `.rs` compilabili
- ❌ NO `Cargo.toml` funzionante
- ✅ SI pseudocodice in italiano
- ✅ SI esempi Rust commentati (con `//` davanti a ogni riga)
- ✅ SI spiegazioni teoriche

### 3. OBIETTIVO DIDATTICO
- Ogni sezione deve insegnare qualcosa
- Spiega IL PERCHÉ, non solo IL COME
- Mettiti nei panni di uno studente alle prime armi
- Anticipa domande e dubbi

### 4. SUBTASK GRANULARI
- Ogni task deve essere completabile in 15-20 minuti
- Più task piccoli = meglio di pochi task grandi
- Questo allunga il loop totale a 3-4 ore

---

## 🔄 FLUSSO DI LAVORO

1. **Planner** analizza la fase corrente → crea task granulari
2. **Writer** scrive una sezione → salva in `lezione/XX-fase/`
3. **Reviewer** verifica qualità → approva o richiede correzioni
4. **Teacher** crea esercizi → prepara transizione
5. Se ci sono altre sezioni: torna a Planner
6. Se la fase è completa: passa alla fase successiva
7. Se tutte le fasi sono complete: `LOOP_COMPLETE`

---

## 📁 DIRECTORY DI LAVORO

- **Input:** `specs/01-crawling/` → `specs/06-conclusione/`
- **Output:** `lezione/01-crawling/` → `lezione/06-conclusione/`
- **Scratchpad:** `.ralph/scratchpad.md` (note di lavoro)

---

## 🚀 COMANDO PER INIZIARE

```bash
ralph run -c ralph.yml -p "Inizia la lezione sul motore di ricerca in Rust"
```

---

## 📊 CRITERI DI COMPLETAMENTO

La lezione è completa quando:
- [ ] Tutte le 6 fasi hanno documentazione completa
- [ ] Ogni fase ha almeno 6 file .md
- [ ] Tutto è in italiano
- [ ] Non c'è codice eseguibile (solo pseudocodice)
- [ ] Ci sono esercizi e domande per ogni sezione
- [ ] `lezione/README.md` è stato creato
- [ ] `lezione/CONCLUSIONE.md` è stato creato

---

**BUON LAVORO, AGENTE DIDATTICO!** 📚✨
Insegna Rust con passione e chiarezza.
