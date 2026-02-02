## Teoria

Nella costruzione di un motore di ricerca in Rust, è fondamentale padroneggiare i comandi essenziali di Cargo, il gestore di pacchetti e compilatore di Rust. Cargo non solo organizza e compila il progetto, ma gestisce anche le dipendenze, i test e la pubblicazione. Inizieremo esplorando i comandi più utilizzati nel ciclo di sviluppo giornaliero. Il comando `cargo new` crea un nuovo progetto con la struttura base: file Cargo.toml per le configurazioni e directory src per il codice sorgente. Per compilare il progetto usiamo `cargo build`, che produce un eseguibile ottimizzato nella directory target, mentre `cargo run` compila ed esegue direttamente l'applicazione. Durante lo sviluppo, invece, sfruttiamo `cargo check` per verificarne sintatticamente valido senza generare l'eseguibile, velocizzando significativamente l'iterazione.

Per la gestione delle dipendenze, `cargo add` permette di aggiungere crate al file Cargo.toml in modo sicuro, mentre `cargo update` aggiorna le versioni compatibili. Per i test, `cargo test` esegue automaticamente tutti i test definiti nel progetto, supportando anche il testing unitario e integrato. In ambiente di produzione, `cargo build --release` produce un eseguibile ottimizzato con massima performance. Infine, `cargo doc --open` genera e apre la documentazione locale del progetto, essenziale per esplorare le API. La conoscenza di questi comandi è cruciale poiché semplifica il workflow di sviluppo e permette di concentrarsi sul codice piuttosto che sui dettagli di compilazione.

## Esempio

Immaginiamo di iniziare a sviluppare il crawler per il nostro motore di ricerca. Dopo aver creato il progetto con `cargo new search_engine`, dobbiamo aggiungere alcune dipendenze fondamentali. Usiamo `cargo add tokio` per l'asincronia, `cargo add reqwest` per le HTTP requests, e `cargo add serde` per la serializzazione dei dati. Durante lo sviluppo della funzione di crawling, eseguiamo frequentemente `cargo check` per verificare che il codice compili correttamente senza perdere tempo nella compilazione completa. Quando vogliamo testare il crawler su un sito semplice, usiamo `cargo run` per avviare l'applicazione e vedere se le pagine vengono scaricate correttamente.

Nel debugging di un problema di parsing HTML, aggiungiamo stampe di debug temporanee e usiamo `cargo run` per testare iterativamente. Una volta soddisfatti di una funzione, scriviamo test unitari e li eseguiamo con `cargo test`, assicurandoci che il comportamento atteso sia mantenuto. Prima del deployment, eseguiamo `cargo build --release` per ottenere l'eseguibile ottimizzato, poi generiamo la documentazione con `cargo doc --open` per verificare che tutto sia ben documentato. Questo workflow iterativo permette di sviluppare in modo efficiente mantenendo alta qualità e documentazione aggiornata.

## Pseudocodice

```rust
// Struttura tipica di un nuovo progetto Rust
// cargo new motore_ricerca
// ├── Cargo.toml (configurazione e dipendenze)
// └── src/
//     └── main.rs (punto di ingresso)

// Inizializzazione di un nuovo crate con async runtime
// cargo new --lib motore_core
// ├── Cargo.toml
// └── src/
//     └── lib.rs (definizione della libreria)

// Workflow tipico durante lo sviluppo
// 1. Controllo sintassi senza compilare
cargo check
// Output: messaggi di errore/compilazione senza eseguibile

// 2. Compilazione completa in modalità debug
cargo build
// Output: target/debug/motore_ricerca[.exe]

// 3. Compilazione ottimizzata per produzione
cargo build --release
// Output: target/release/motore_ricerca ottimizzato

// 4. Esecuzione dell'applicazione compilata
cargo run
// Equivalent to: cargo build && ./target/debug/motore_ricerca

// 5. Esecuzione dei test definiti nel progetto
cargo test
// Trova automaticamente tutti i test marcati con #[test]

// 6. Aggiornamento delle dipendenze alle versioni compatibili
cargo update
// Modifica Cargo.lock mantenendo vincoli di versionamento

// 7. Generazione documentazione dalla documentazione inline
cargo doc --open
// Crea docs HTML e le apre nel browser predefinito
```

## Risorse

- https://doc.rust-lang.org/cargo/commands/index.html - Documentazione ufficiale di tutti i comandi Cargo
- https://doc.rust-lang.org/book/ch01-00-getting-started.html - Guida introduttiva a Rust e Cargo
- https://doc.rust-lang.org/rust-by-example/hello.html - Esempi pratici di progetti Rust semplici
- https://crates.io/crates/cargo-edit - Crate per comandi add/remove avanzati delle dipendenze

## Esercizio

Implementa uno script che automatizzi la creazione e setup iniziale di un nuovo progetto Rust per il motore di ricerca. Lo script dovrebbe:

1. Creare un nuovo progetto chiamato "motore_ricerca" usando cargo new
2. Aggiungere le dipendenze essenziali per async, HTTP, serializzazione usando cargo add
3. Generare la struttura base delle directory (crawler/, indexing/, search/)
4. Compilare il progetto in modalità debug e controllare eventuali errori
5. Eseguire cargo doc per verificare che la documentazione sia generata correttamente

Traccia di soluzione: Inizia con cargo new motore_ricerca --lib, poi usa cargo add per ogni dipendenza (tokio, reqwest, serde), crea le directory con mkdir, infine cargo check e cargo doc per validare tutto.