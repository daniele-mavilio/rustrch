# FASE 1: CRAWLING DEL FILE SYSTEM

## 🎯 OBIETTIVO DIDATTICO

Insegnare allo studente come esplorare il file system in modo asincrono usando Rust.

---

## 📚 CONCETTI RUST DA INSEGNARE

### 1. Programmazione Asincrona in Rust
- Cos'è l'async/await
- Perché usarlo per l'I/O
- Il runtime tokio

### 2. Gestione dei Percorsi
- `std::path::Path` e `PathBuf`
- Percorsi assoluti vs relativi
- Manipolazione dei path

### 3. Metadati dei File
- Dimensione, data di modifica, permessi
- Come leggere i metadati

### 4. Ricorsione
- Funzioni ricorsive in Rust
- Esplorazione di directory annidate

---

## 📝 SEZIONI DA GENERARE

### Sezione 1.1: Introduzione alla Fase
- Spiegare cos'è il crawling
- Perché serve per un motore di ricerca
- Overview di cosa impareremo

### Sezione 1.2: La Programmazione Asincrona
- Spiegazione teorica dell'async
- Confronto sync vs async
- Introduzione a tokio

### Sezione 1.3: Gestione dei Percorsi in Rust
- Path e PathBuf
- Costruire percorsi
- Normalizzare percorsi

### Sezione 1.4: Leggere i Metadati
- Cosa sono i metadati
- Come accedervi in Rust
- Informazioni disponibili

### Sezione 1.5: Pseudocodice del Crawler
```plaintext
funzione esplora_directory(percorso):
    per ogni elemento in leggi_directory(percorso):
        se elemento è file:
            salva_metadati(elemento)
        se elemento è directory:
            esplora_directory(elemento.percorso)  // ricorsione
```

### Sezione 1.6: Spiegazione Dettagliata
- Riga per riga del pseudocodice
- Traduzione in concetti Rust
- Gestione degli errori (teoria)

### Sezione 1.7: Esercizi e Domande
- 5 domande di comprensione
- 2 esercizi pratici
- Riepilogo

---

## 🔗 RISORSE DA CITARE

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

---

## ⚠️ NOTE PER L'AGENT

- TUTTO IN ITALIANO
- Zero codice eseguibile
- Spiega ogni concetto come se fosse la prima volta
- Usa esempi concreti (es: "Immagina di voler cercare in /home/documenti")
