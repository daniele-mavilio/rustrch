# FASE 2: INDICIZZAZIONE CON SQLITE

## 🎯 OBIETTIVO DIDATTICO

Insegnare allo studente come memorizzare i dati raccolti in un database SQLite usando Rust.

---

## 📚 CONCETTI RUST DA INSEGNARE

### 1. Database SQLite
- Cos'è SQLite (database embedded)
- Vantaggi per applicazioni locali
- SQL di base

### 2. La Crate Rusqlite
- Connessione al database
- Esecuzione di query
- Prepared statements

### 3. Serializzazione con Serde
- Cos'è la serializzazione
- JSON in Rust
- La derive macro `#[derive(Serialize, Deserialize)]`

### 4. Strutture Dati in Rust
- Definire struct
- Campi e tipi
- Costruttori e metodi

### 5. Error Handling
- Il tipo `Result<T, E>`
- Gestione degli errori con `?`
- Panic vs Errori gestiti

---

## 📝 SEZIONI DA GENERARE

### Sezione 2.1: Introduzione alla Fase
- Perché serve un database
- Perché SQLite è perfetto per questo progetto
- Overview della fase

### Sezione 2.2: SQLite in Rust
- Spiegazione di SQLite
- Introduzione a rusqlite
- Connessione e disconnessione

### Sezione 2.3: Creare lo Schema del Database
- Tabella `file` con campi:
  - id (chiave primaria)
  - nome (testo)
  - percorso (testo)
  - dimensione (intero)
  - data_modifica (timestamp)
  - embedding (blob opzionale)

### Sezione 2.4: Serializzazione con Serde
- Cos'è serde
- Perché serve per JSON
- Esempio di struct serializzabile

### Sezione 2.5: Pseudocodice per l'Indicizzazione
```plaintext
funzione inizializza_database():
    connessione = connetti_a("database.db")
    esegui_query(connessione, """
        CREA TABELLA SE NON ESISTE file (
            id INTERO PRIMARY KEY,
            nome TESTO,
            percorso TESTO,
            dimensione INTERO,
            data_modifica TESTO
        )
    """)
    restituisci connessione

funzione salva_file(connessione, file):
    esegui_query(connessione, 
        "INSERISCI IN file (nome, percorso, dimensione, data_modifica) 
         VALORI (?, ?, ?, ?)",
        [file.nome, file.percorso, file.dimensione, file.data_modifica]
    )
```

### Sezione 2.6: Spiegazione Dettagliata
- Il prepared statement (il `?`)
- Transazioni (teoria)
- Indici per velocizzare le ricerche

### Sezione 2.7: Esercizi e Domande
- 5 domande di comprensione
- 2 esercizi pratici
- Riepilogo

---

## 🔗 RISORSE DA CITARE

- [Rusqlite Documentation](https://docs.rs/rusqlite/latest/rusqlite/)
- [Serde Documentation](https://serde.rs/)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [Rust Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)

---

## ⚠️ NOTE PER L'AGENT

- Spiega bene il concetto di prepared statement (sicurezza SQL)
- Mostra come la struct File si mappa alla tabella SQL
- Enfatizza l'importanza degli indici per le performance
