# FASE 5: TESTING E OTTIMIZZAZIONE

## 🎯 OBIETTIVO DIDATTICO

Insegnare allo studente come testare e ottimizzare un'applicazione Rust.

---

## 📚 CONCETTI RUST DA INSEGNARE

### 1. Testing in Rust
- Test unitari con `#[test]`
- Test di integrazione
- Assert macro (`assert!`, `assert_eq!`, `assert_ne!`)

### 2. Benchmarking
- Criterion per benchmark
- Misurare performance
- Identificare colli di bottiglia

### 3. Ottimizzazione
- Profiling (teoria)
- Caching
- Parallelismo con Rayon

### 4. Gestione Memoria
- Heap vs Stack
- Allocazioni
- Ottimizzare uso memoria

### 5. Async Performance
- Pool di thread
- Non bloccare il runtime
- Ottimizzare query async

---

## 📝 SEZIONI DA GENERARE

### Sezione 5.1: Introduzione alla Fase
- Perché testare è importante
- Tipi di test
- Overview dell'ottimizzazione

### Sezione 5.2: Test Unitari in Rust
- Sintassi `#[test]`
- Test passano/falliscono
- Test di funzioni individuali

### Sezione 5.3: Pseudocodice per Test del Crawler
```plaintext
#[test]
funzione test_crawl_directory_semplice():
    // Crea directory temporanea
    dir_temp = crea_directory_temporanea()
    crea_file(dir_temp, "test.txt", "contenuto")
    
    // Esegui crawling
    risultati = esplora_directory(dir_temp)
    
    // Verifica
    asserisci_uguale(lunghezza(risultati), 1)
    asserisci_uguale(risultati[0].nome, "test.txt")
    
    // Pulisci
    elimina_directory(dir_temp)

#[test]
funzione test_crawl_directory_vuota():
    dir_temp = crea_directory_temporanea()
    risultati = esplora_directory(dir_temp)
    asserisci_uguale(lunghezza(risultati), 0)
```

### Sezione 5.4: Test di Integrazione
- Testare flussi completi
- Setup e teardown
- Test del database

### Sezione 5.5: Pseudocodice per Test di Ricerca
```plaintext
#[test]
funzione test_ricerca_trova_file():
    // Setup: inserisci file nel database
    db = inizializza_database_test()
    inserisci_file(db, "rust-tutorial.pdf", "/docs/", 1024)
    
    // Esegui ricerca
    risultati = ricerca(db, "rust tutorial")
    
    // Verifica
    asserisci_maggiore(lunghezza(risultati), 0)
    asserisci_contiene(risultati[0].nome, "rust")
    
    // Cleanup
    chiudi_database(db)
```

### Sezione 5.6: Benchmarking
- Perché misurare
- Criterion crate
- Esempi di benchmark

### Sezione 5.7: Ottimizzazione Performance
- Caching dei risultati
- Indici database
- Query ottimizzate

### Sezione 5.8: Parallelismo con Rayon
- Cos'è Rayon
- Parallelizzare il crawling
- Iteratori paralleli

### Sezione 5.9: Pseudocodice per Crawling Parallelo
```plaintext
funzione esplora_directory_parallela(percorso):
    elementi = leggi_directory(percorso)
    
    // Processa in parallelo
    risultati = parallelizza_per(elementi, funzione(elemento):
        se elemento è file:
            restituisci estrai_metadati(elemento)
        se elemento è directory:
            restituisci esplora_directory_parallela(elemento.percorso)
    )
    
    restituisci appiattisci(risultati)
```

### Sezione 5.10: Esercizi e Domande
- 5 domande di comprensione
- 2 esercizi pratici
- Riepilogo

---

## 🔗 RISORSE DA CITARE

- [Rust Testing](https://doc.rust-lang.org/book/ch11-00-testing.html)
- [Criterion.rs](https://bheisler.github.io/criterion.rs/book/)
- [Rayon Documentation](https://docs.rs/rayon/latest/rayon/)
- [Rust Performance Book](https://nnethercote.github.io/perf-book/)
- [Effective Rust](https://www.lurklurk.org/effective-rust/)

---

## ⚠️ NOTE PER L'AGENT

- I test sono concetto importante: spiega bene setup/teardown
- Benchmarking: enfatizza l'importanza di misurare prima di ottimizzare
- Rayon: spiega che è "parallelismo senza dolore"
