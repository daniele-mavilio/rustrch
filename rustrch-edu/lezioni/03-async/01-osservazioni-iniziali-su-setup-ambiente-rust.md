## Osservazioni Iniziali su Setup Ambiente Rust

Questa sezione introduce l'ecosistema di sviluppo necessario per costruire un motore di ricerca in Rust. Prima di immergersi nella programmazione asincrona, è essenziale comprendere gli strumenti fondamentali che faciliteranno lo sviluppo efficiente e sicuro.

### Teoria

Nel contesto di un progetto complesso come un motore di ricerca, l'ambiente di sviluppo Rust richiede attenzione particolare. Rust offre garanzie di sicurezza nella gestione della memoria senza impattare sulle prestazioni, ma questo richiede un setup iniziale accurato. Il core dell'ecosistema è rappresentato da rustup, che permette di gestire molteplici versioni del compilatore rustc e del package manager Cargo. Cargo non è solo un tool per la gestione delle dipendenze, ma il pilastro dell'intero workflow di sviluppo: dalla creazione del progetto alla gestione dei moduli esterni attraverso crates.io. Per l'implementazione di un motore di ricerca, che necessita di operazioni I/O intensive e concorrenti, è cruciale integrare prematuramente elementi per la gestione asincrona. Tokio rappresenta il runtime principale per operazioni asincone in Rust, fornendo primitive essenziali come spawn di task e timer. La configurazione va oltre gli strumenti base: rustfmt e clippy ottimizzano la qualità del codice attraverso formattazione automatica e linting. Durante il setup, il programmatore deve essere consapevole delle interazioni tra componenti come il borrow checker e l'async runtime, che operano a livelli diversi dell'astrazione ma insieme garantiscono l'affidabilità del sistema. Un ambiente ben configurato riduce errori comuni legati alla concorrenza e alla gestione risorse.

### Esempio

Immagina di voler sviluppare la prima versione del crawler web per il motore di ricerca. Dopo aver installato Rust, crei il nuovo progetto con `cargo new search-engine`. Nel Cargo.toml, aggiungi le dipendenze essenziali: `tokio = { version = "1", features = ["full"] }` per il runtime async, `reqwest = "0.11"` per HTTP requests, e `anyhow = "1.0"` per gestione errori semplificata. Durante la compilazione iniziale (`cargo build`), clippy potrebbe segnalare miglioramenti al codice, incoraggiando pratiche migliori. Quando esegui (`cargo run`), il runtime Tokio gestisce automaticamente il task principale, permettendo di testare immediatilmente se le richieste HTTP raggiungono le destinazioni previste. Questo setup minimal consente di verificare sin dai primi passi che l'ambiente supporta le operazioni asincrone necessarie per efficienza del crawler.

### Pseudocodice

```rust
// Importiamo le crate essenziali per HTTP async e gestione errori
// use tokio::spawn; // per eseguire task concurrently
// use reqwest::Client; // per effettuare richieste HTTP
// use anyhow::Result; // per gestire errori in modo ergonomico

// Inizializzazione del client HTTP globale
// let client = Client::new();

// Spawn di un task async per crawling
// let handle = tokio::spawn(async move {
//     // Effettuare richiesta HTTP
//     // let response = client.get("http://example.com").send().await?;
//     // println!("Ricevuto contenuto dalla pagina");
//     Ok(())
// });

// Attendere il completamento del task
// handle.await?;
```

### Risorse

- [Rust Installation Guide](https://doc.rust-lang.org/book/ch01-01-installation.html) - Guida ufficiale per installare e configurare rustup
- [Tokio Getting Started](https://tokio.rs/tokio/tutorial/getting-started) - Introduzione pratica al runtime async
- [Cargo Documentation](https://doc.rust-lang.org/cargo/getting-started/index.html) - Gestione progetti e dipendenze
- [Clippy Linting](https://doc.rust-lang.org/clippy/) - Tool per improve codice Rust quality

### Esercizio

**Domanda:** Configura il tuo ambiente Rust per un crawler web async. Installa la toolchain, crea un nuovo progetto cargo, aggiungi le dipendenze necessarie per HTTP requests e async operations, e verifica che la compilazione funzioni senza errori.

**Traccia di soluzione:** 
- Installa rustup da rustup.rs
- Crea progetto con `cargo new crawler`
- Modifica Cargo.toml aggiungendo `tokio = "1.0"` e `reqwest = "0.11"`
- Scrivi un main.rs semplice che stampi "Environment ready"
- Esegui `cargo check` per verificare setup
- Cosa noti riguardo alle performance vs memoria rispetto a linguaggi interpretati?