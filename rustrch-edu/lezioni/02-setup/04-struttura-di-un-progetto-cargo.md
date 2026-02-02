# Struttura di un Progetto Cargo

## Teoria

Un progetto Cargo segue una struttura convenzionale che permette al build system di trovare automaticamente i file sorgente, i test, gli esempi e altre risorse. Comprendere questa struttura è fondamentale per organizzare progetti di medie e grandi dimensioni in modo che siano manutenibili e seguano le convenzioni della comunità Rust.

La directory principale del progetto contiene il file `Cargo.toml`, che è il manifesto del progetto con metadati e configurazioni. La directory `src/` contiene il codice sorgente principale: `main.rs` per i binari o `lib.rs` per le librerie. I test di integrazione vanno in `tests/`, i benchmark in `benches/`, gli esempi in `examples/`, e gli eseguibili aggiuntivi in `src/bin/`.

Questa struttura non è solo una convenzione: Cargo la usa per determinare cosa compilare e come. Ad esempio, i file in `tests/` vengono compilati come crate separati che linkano la libreria principale, permettendo di testare l'API pubblica. I file in `examples/` mostrano come usare la libreria e vengono compilati con `cargo run --example nome`.

## Esempio

Un progetto ben strutturato:

```
mio-progetto/
├── Cargo.toml          # Manifesto
├── Cargo.lock          # Versioni esatte delle dipendenze
├── src/
│   ├── main.rs        # Entry point (binario)
│   ├── lib.rs         # Oppure libreria principale
│   └── bin/           # Eseguibili aggiuntivi
│       └── extra.rs   # cargo run --bin extra
├── tests/             # Test di integrazione
│   └── integrazione.rs
├── benches/           # Benchmark
│   └── performance.rs
├── examples/          # Esempi d'uso
│   └── semplice.rs    # cargo run --example semplice
└── target/            # Output compilazione (auto-generata)
```

## Pseudocodice

```rust
// STRUTTURA BASE PROGETTO

// File: Cargo.toml
[package]
name = "mio-progetto"
version = "0.1.0"
edition = "2021"
authors = ["Nome Autore <email@example.com>"]
description = "Descrizione del progetto"
license = "MIT OR Apache-2.0"
repository = "https://github.com/username/mio-progetto"

[dependencies]
// Dipendenze esterne qui

[dev-dependencies]
// Dipendenze solo per testing

// File: src/main.rs (per binari)
fn main() {
    println!("Hello from main!");
}

// File: src/lib.rs (per librerie)
pub fn funzione_pubblica() -> i32 {
    42
}

mod modulo_privato {
    pub fn funzione() {}
}

// MULTIPLI BINARI

// src/bin/server.rs
fn main() {
    println!("Avvio server...");
}

// src/bin/client.rs
fn main() {
    println!("Avvio client...");
}

// Compilazione ed esecuzione
$ cargo run --bin server
$ cargo run --bin client

// TEST DI INTEGRAZIONE

// tests/test_integrazione.rs
use mio_progetto::funzione_pubblica;

#[test]
fn test_funzione() {
    assert_eq!(funzione_pubblica(), 42);
}

// ESEMPI

// examples/usa_libreria.rs
use mio_progetto::funzione_pubblica;

fn main() {
    let risultato = funzione_pubblica();
    println!("Risultato: {}", risultato);
}

// Esecuzione esempio
$ cargo run --example usa_libreria

// ORGANIZZAZIONE CODICE CON MODULI

// src/lib.rs
pub mod parser;
pub mod indexer;
pub mod searcher;

// src/parser.rs
pub struct Parser;
impl Parser {
    pub fn new() -> Self { Parser }
}

// src/indexer.rs
pub struct Indexer;
impl Indexer {
    pub fn new() -> Self { Indexer }
}

// src/searcher.rs
pub struct Searcher;
impl Searcher {
    pub fn new() -> Self { Searcher }
}

// UTILIZZO
use mio_progetto::{parser::Parser, indexer::Indexer};

let parser = Parser::new();
let indexer = Indexer::new();

// DIRECTORY TARGET

// target/debug/        - Build di sviluppo
// target/release/      - Build di release
// target/doc/          - Documentazione HTML
// target/package/      - Pacchetti per crates.io

// FILE CARGO.LOCK

// Generato automaticamente da Cargo
// Blocca le versioni esatte delle dipendenze
// Da includere in version control per binari
// Opzionale per librerie (solo se binario)

// STRUTTURA PROGETTO COMPLESSO

// mio-progetto/
// ├── Cargo.toml
// ├── src/
// │   ├── main.rs
// │   ├── lib.rs
// │   ├── core/           # Modulo core
// │   │   ├── mod.rs
// │   │   ├── types.rs
// │   │   └── utils.rs
// │   ├── io/             # Modulo I/O
// │   │   ├── mod.rs
// │   │   ├── reader.rs
// │   │   └── writer.rs
// │   └── bin/            # Binari aggiuntivi
// │       ├── tool1.rs
// │       └── tool2.rs
// ├── tests/
// │   ├── integration_test1.rs
// │   └── integration_test2.rs
// ├── benches/
// │   └── benchmark.rs
// ├── examples/
// │   ├── basic.rs
// │   └── advanced.rs
// └── target/

// MODULO CON SOTTOMODULI

// src/core/mod.rs
pub mod types;
pub mod utils;

pub use types::Config;
pub use utils::helper;

// src/core/types.rs
pub struct Config {
    pub name: String,
}

// src/core/utils.rs
pub fn helper() {}

// COMANDI UTILI PER ESPLORARE

$ cargo tree
// Mostra l'albero delle dipendenze

$ cargo metadata
// Mostra metadati del progetto in JSON

$ cargo locate-project
// Trova il percorso del Cargo.toml
```

## Risorse

- [Project Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html)
- [Package Format](https://doc.rust-lang.org/cargo/reference/manifest.html)
- [Workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html)

## Esercizio

Crea un progetto "web-crawler" con questa struttura:

```
web-crawler/
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── lib.rs
│   ├── crawler.rs      # Modulo crawling
│   └── parser.rs       # Modulo parsing
├── tests/
│   └── integration.rs
└── examples/
    └── simple.rs
```

Implementa:
1. In `lib.rs`, definisci la struttura `WebCrawler` pubblica
2. In `crawler.rs`, implementa un metodo `fetch()` che restituisce una stringa
3. In `parser.rs`, implementa un metodo `extract_links()` che prende html e restituisce Vec<&str>
4. In `main.rs`, usa la libreria
5. Scrivi un test di integrazione in `tests/integration.rs`

**Traccia di soluzione:**
```rust
// src/lib.rs
pub mod crawler;
pub mod parser;

pub use crawler::WebCrawler;
pub use parser::LinkParser;

// src/crawler.rs
pub struct WebCrawler;

impl WebCrawler {
    pub fn new() -> Self { WebCrawler }
    
    pub fn fetch(&self, url: &str) -> String {
        format!("Contenuto di {}", url)
    }
}

// src/parser.rs
pub struct LinkParser;

impl LinkParser {
    pub fn extract_links(html: &str) -> Vec<&str> {
        // Semplice implementazione
        vec!["http://example.com"]
    }
}

// tests/integration.rs
use web_crawler::{WebCrawler, LinkParser};

#[test]
fn test_crawler() {
    let crawler = WebCrawler::new();
    let content = crawler.fetch("test");
    assert!(content.contains("test"));
}
```
