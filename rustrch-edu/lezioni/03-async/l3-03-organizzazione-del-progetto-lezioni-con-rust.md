## Teoria

L'organizzazione di un progetto Rust complesso come un motore di ricerca richiede una struttura modulare e ben pensata per facilitare la manutenibilità, la scalabilità e la collaborazione. In Rust, i progetti utilizzano crate (librerie o binari) che possono essere organizzati in workspace quando il progetto cresce oltre un singolo crate. Un workspace permette di condividere dipendenze tra diversi crate senza duplicazioni, semplificando la compilazione e la gestione delle versioni. 

Le strutture chiave di un progetto Rust includono: Cargo.toml per le dipendenze e la configurazione, src/ per il codice sorgente con lib.rs come punto d'ingresso della libreria, e test/ per i test. Per un motore di ricerca, è fondamentale separare i moduli logici: un modulo per il crawling web asincrono, uno per l'indicizzazione dei contenuti, uno per l'archiviazione su database, e uno per l'interfaccia di ricerca. Questa separazione segue il principio di responsabilità singola, permettendo sviluppi indipendenti e testing isolato.

I moduli in Rust, dichiarati con `mod`, aiutano a organizzare il codice in file separati. Un file lib.rs può esportare moduli pubblici con `pub mod`, controllando la visibilità tramite `pub`. Per progetti complessi, si utilizzano workspace con Cargo.toml root che elenca i membri nel campo [workspace], ogni crate con il proprio Cargo.toml. Gestire errori tra moduli richiederà tipi di errori personalizzati, spesso con derive(Debug, thiserror::Error) per una gestione uniforme.

## Esempio

Immagina di costruire un motore di ricerca per documenti tecnici. Organizzeresti il progetto in un workspace con tre crate principali: `crawler` per raccogliere pagine web, `indexer` per elaborare e indicizzare contenuti, e `search` per le query utente. Il crawler utilizzerebbe tokio per HTTP requests asincrone, scaricando pagine e salvandole in un buffer condiviso. L'indexer leggerebbe da questo buffer, tokenizzerebbe il testo rimuovendo stop words, e costruirebbe un inverted index su SQLite con indici ottimizzati. Infine, `search` esporrebbe un'API REST con Hyper, riceviendo query che vengono elaborate attraverso BM25 scoring per ritornare risultati ordinati.

In pratica, ogni crate avrebbe directory src/ con moduli suddivisi: nel crawler, mod network per richieste, mod parser per HTML. L'indexer avrebbe mod tokenizer e mod indexer. Condividerebbero strutture dati comuni attraverso un crate `common` nel workspace. Questa organizzazione permette di sviluppare il crawler indipendentemente dall'indexer, facilitando test unitari per ciascun componente e deployment separati se necessario.

## Pseudocodice

```
// Struttura del workspace nel Cargo.toml principale
// [workspace]
// members = ["crawl", "indexer", "search", "common"]
//
// // Nel crawler/Cargo.toml dipendenze
// tokio = "1.0"
// reqwest = { version = "0.11", features = ["json"] }
//
// // Codice struttura in src/lib.rs del crawler
// pub mod network;
// pub mod parser;
// pub mod buffer;
// // Qui definiamo la funzione main del crate
//
// // Modulo network per HTTP requests
// // Gestisce connessioni, retry e rate limiting
//
// // Modulo parser elabora HTML e estrae testo
//
// // Modulo buffer condivide dati con indexer usando canali tokio
//
// // Nel common/src/lib.rs strutture condivise
// pub struct Document { url: String, content: String }
// pub struct SearchQuery { terms: Vec<String> }
//
// // L'indexer importa common for tipi
// use common::Document;
// // Costruisce inverted index su database
//
// // Il search importa sia indexer sia crawler per query pipeline
```

## Risorse

- [Managing Growing Projects with Packages, Crates, and Modules](https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html)
- [The Manifest Format - Cargo.toml](https://doc.rust-lang.org/cargo/reference/manifest.html)
- [Workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html)

## Esercizio

Come organizzeresti i moduli per aggiungere una funzionalità di caching dei risultati di ricerca nel motore? Traccia soluzione: Crea un crate "cache" nel workspace con moduli lru_cache per implementazione, redis_connector per storage distribuito, policy per strategia di invalidazione. Nel crate search, importa cache e integra nella pipeline dopo BM25 scoring, verificando hit prima di query su inverted index.

