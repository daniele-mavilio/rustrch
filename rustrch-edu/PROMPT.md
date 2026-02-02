# Generazione Corso Rust - Motore di Ricerca

## Obiettivo

Generare 200+ micro-sezioni didattiche (300-500 parole ciascuna) in italiano
per un corso completo su "Costruire un Motore di Ricerca (per cli) in Rust".
Target: 150 file .md totali tra le lezioni.

## Pubblico

Studente italiano che conosce Python/JavaScript base, mai usato Rust,
vuole imparare costruendo un progetto reale.

## Regole di Generazione

### Lingua
- Tutto il testo in italiano
- Parole inglesi permesse SOLO dentro blocchi di codice
- Nomi tecnici Rust (ownership, borrowing, trait) accettati come termini tecnici

### Formato Obbligatorio per ogni sezione

Ogni file .md DEVE avere queste 5 sezioni:

1. `## Teoria` - Spiegazione concetto (150+ parole)
2. `## Esempio` - Caso d'uso pratico (100+ parole)
3. `## Pseudocodice` - Blocco ```rust con codice commentato (//)
4. `## Risorse` - Minimo 3 link a documentazione reale
5. `## Esercizio` - Domanda pratica con traccia di soluzione

### Pseudocodice
- SOLO pseudocodice commentato con `//` su ogni riga
- NON deve essere compilabile
- Serve per illustrare concetti, non per eseguire

### Wordcount
- Minimo 300 parole per sezione
- Massimo 500/600 parole (oltre potrebbe diventare troppo denso)

## Roadmap Tecnica (specs/)

Il corso segue una progressione tecnica definita nei file in `specs/`. 
L'Architect deve usare questi file per definire i titoli e gli obiettivi dei task:
- `specs/01-crawling/`: Teoria asincrona e file system.
- `specs/02-indicizzazione/`: Strutture dati, Inverted Index.
- `specs/03-embeddings/`: ML, Vettori, AI.
- `specs/04-ricerca/`: Algoritmi di ranking, BM25.
- `specs/05-testing/`: Qualità del codice.
- `specs/06-conclusione/`: Cleanup e futuro.

## Gestione Contesto per Sessioni Lunghe

Questa generazione dura 8 ore. Il contesto si resetta ad ogni iterazione.
Per evitare allucinazioni e mantenere coerenza:

### Uso delle Memories

Ad ogni iterazione significativa, salva informazioni chiave:

```bash
# Dopo aver scritto una sezione che introduce un concetto riusato dopo
ralph tools memory add "L1: Ownership spiegato con metafora del libro prestato"

# Dopo un checkpoint
ralph tools memory add "Checkpoint: 50 sezioni, 17000 parole. Stile consolidato."

# Se scopri un pattern che funziona
ralph tools memory add "Pattern: iniziare Teoria con domanda retorica migliora il flusso"
```

Le memories vengono iniettate automaticamente ad ogni nuova iterazione
(budget: 3000 token). Questo mantiene la coerenza stilistica.

### Anti-Allucinazione

1. **Verifica sempre i task**: usa `ralph tools task ready` per sapere cosa scrivere
2. **Non inventare task**: scrivi SOLO il task assegnato, non aggiungere contenuto extra
3. **Link reali**: usa solo URL che conosci essere validi (docs.rust-lang.org, crates.io, doc.rust-lang.org/book/)
4. **Rileggi il file prima di chiudere**: verifica che il contenuto sia coerente con il titolo del task

### Risorse Sicure (URL verificati)

Usa preferibilmente questi domini per i link:
- `https://doc.rust-lang.org/book/` - The Rust Book
- `https://doc.rust-lang.org/std/` - Standard Library docs
- `https://doc.rust-lang.org/rust-by-example/` - Rust by Example
- `https://crates.io/crates/` - Crates.io
- `https://docs.rs/` - Documentazione crate
- `https://tokio.rs/` - Tokio async runtime
- `https://github.com/rust-lang/` - Repository ufficiali

## Directory di Output

```
lezioni/
  01-fondamenti/    # L1: Ownership, borrowing, struct, enum, pattern matching
  02-setup/         # L2: Installazione, cargo, IDE, toolchain, debug
  03-async/         # L3: Async/await, tokio, crawling, error handling
  04-database/      # L4: SQLite, rusqlite, serde, transazioni, indici
  05-ml/            # L5: Embedding, ONNX, vector ops, similarity
  06-search/        # L6: Tokenization, BM25, inverted index, ranking
  07-performance/   # L7: Rayon, caching, benchmarking, memory, profiling
  08-deployment/    # L8: Build release, ottimizzazioni, risorse, FAQ
```

## Completamento

Il corso e' completo quando:
- 150/200 file .md generati
- Ogni file passa tutti i gate del reviewer
- README.md con indice generato dal coordinator
