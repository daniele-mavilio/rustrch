# Componenti della Toolchain: rustc, cargo, rustfmt, clippy

## Teoria

La toolchain di Rust non è solo il compilatore: è un ecosistema completo di strumenti progettati per rendere lo sviluppo produttivo e piacevole. I componenti principali sono: `rustc` (il compilatore), `cargo` (il gestore di pacchetti e build system), `rustfmt` (il formattatore automatico di codice), e `clippy` (il linter avanzato). Comprendere cosa fa ciascuno strumento è essenziale per lavorare efficacemente con Rust.

`rustc` è il compilatore principale che trasforma il codice sorgente Rust in binari eseguibili. Sebbene sia possibile usarlo direttamente (come abbiamo fatto nell'esercizio precedente), nella pratica quotidiana si usa raramente in modo esplicito perché `cargo` lo invoca automaticamente. Tuttavia, capire come funziona `rustc` è utile per debugging avanzato e per configurazioni particolari.

`cargo` è il cuore dell'ecosistema Rust. Gestisce dipendenze, compila progetti, esegue test, genera documentazione, e molto altro. È analogo a `npm` per JavaScript, `pip` per Python, o `Maven` per Java, ma integrato in un unico strumento. Con `cargo` puoi creare un nuovo progetto con `cargo new`, compilarlo con `cargo build`, eseguirlo con `cargo run`, e testarlo con `cargo test`.

`rustfmt` garantisce che il codice sia formattato in modo coerente seguendo le convenzioni ufficiali. Questo elimina discussioni sullo stile nel team e rende il codice uniforme. `clippy` va oltre il compilatore segnalando pattern problematici, suggerendo miglioramenti idiomatici, e aiutando a scrivere codice più efficiente e sicuro.

## Esempio

Sequenza tipica di lavoro:

```bash
# Crea un nuovo progetto
cargo new mio_progetto
cd mio_progetto

# Scrivi codice, poi formatta automaticamente
cargo fmt

# Verifica la qualità del codice
cargo clippy

# Compila e esegui
cargo run

# Esegui i test
cargo test
```

Questo workflow integrato rende lo sviluppo in Rust molto fluido rispetto a dover gestire manualmente compilatore, formattatore e linter come strumenti separati.

## Pseudocodice

```bash
// RUSTC - Il compilatore

// Compilazione semplice
$ rustc main.rs
// Genera eseguibile 'main' (o 'main.exe' su Windows)

// Compilazione con ottimizzazioni
$ rustc -O main.rs
// Codice ottimizzato per release

// Generare solo l'assembly
$ rustc --emit=asm main.rs

// Compilazione con debug info
$ rustc -g main.rs
// Include informazioni per il debugger

// Mostrare warning aggiuntivi
$ rustc -W warnings main.rs

// CARGO - Gestore di pacchetti e build

// Creare nuovo progetto binario
$ cargo new nome_progetto
// Crea directory con Cargo.toml e src/main.rs

// Creare nuova libreria
$ cargo new --lib nome_libreria
// Crea directory con Cargo.toml e src/lib.rs

// Build del progetto
$ cargo build
// Compila in modalità debug (target/debug/)

// Build di release
$ cargo build --release
// Compila con ottimizzazioni (target/release/)

// Compila ed esegue
$ cargo run
// Compila e poi esegue il binario

// Esegui con argomenti
$ cargo run -- arg1 arg2
// I -- separano argomenti di cargo da quelli del programma

// Check veloce (senza generare binario)
$ cargo check
// Verifica errori di compilazione più velocemente

// Esegui test
$ cargo test
// Compila ed esegue tutti i test

// Esegui test specifico
$ cargo test nome_test

// Genera documentazione
$ cargo doc
// Genera HTML in target/doc/

// Apri documentazione nel browser
$ cargo doc --open

// Aggiorna dipendenze
$ cargo update
// Scarica nuove versioni compatibili

// Pulisci build precedenti
$ cargo clean
// Rimuove directory target/

// RUSTFMT - Formattazione automatica

// Formatta tutto il progetto
$ cargo fmt

// Verifica formattazione senza modificare
$ cargo fmt -- --check
// Utile per CI/CD

// Formatta file specifico
$ rustfmt src/main.rs

// Configurazione in rustfmt.toml
// max_width = 100
// tab_spaces = 4

// CLIPPY - Linter avanzato

// Esegui clippy sul progetto
$ cargo clippy

// Clippy con tutti i warning
$ cargo clippy -- -W clippy::all

// Clippy pedante (più severo)
$ cargo clippy -- -W clippy::pedantic

// Fix automatico dove possibile
$ cargo clippy --fix

// Esempi di errori che clippy trova:
// - Variabili non usate
// - Pattern non idiomatici
// - Possibili panic
// - Ottimizzazioni suggerite

// ALTRE UTILITÀ DELLA TOOLCHAIN

// RLS (Rust Language Server) - deprecato, usa rust-analyzer
// $ rustup component add rls

// Rust Analyzer (installato separatamente)
// Estensione VS Code moderna per IDE features

// LLVM Tools (strumenti di basso livello)
$ rustup component add llvm-tools-preview

// Miri (interprete per verificare unsafe code)
$ rustup component add miri
$ cargo miri test
```

## Risorse

- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [Rustfmt](https://github.com/rust-lang/rustfmt)
- [Clippy](https://doc.rust-lang.org/clippy/)

## Esercizio

Crea un nuovo progetto Cargo e sperimenta con i vari comandi:

1. Crea un progetto chiamato "calcolatrice"
2. Implementa una semplice funzione che somma due numeri
3. Usa `cargo check` per verificare errori
4. Usa `cargo clippy` per vedere suggerimenti
5. Usa `cargo fmt` per formattare il codice
6. Usa `cargo build` e `cargo run` per compilare ed eseguire

**Traccia di soluzione:**
```bash
# Crea progetto
cargo new calcolatrice
cd calcolatrice

# Modifica src/main.rs:
fn main() {
    let a = 5;
    let b = 3;
    println!("{} + {} = {}", a, b, somma(a, b));
}

fn somma(x: i32, y: i32) -> i32 {
    x + y
}

# Comandi da provare
cargo check      # Veloce, solo check errori
cargo clippy     # Vedi suggerimenti
cargo fmt        # Formatta codice
cargo build      # Compila
cargo run        # Compila ed esegue
```
