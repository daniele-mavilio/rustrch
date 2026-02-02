# Compilazione e Ciclo Edit-Compile-Run

## Teoria

Il ciclo edit-compile-run è il workflow fondamentale dello sviluppo software: si modifica il codice, lo si compila, e lo si esegue per verificare il comportamento. Rust, grazie a Cargo, rende questo ciclo fluido ed efficiente, con comandi semplici che gestiscono automaticamente le dipendenze, la ricompilazione incrementale, e l'esecuzione.

La compilazione in Rust è più lenta rispetto a linguaggi interpretati come Python o JavaScript, ma più veloce rispetto a C++ per progetti equivalenti. Cargo mitiga questo tempo attraverso la compilazione incrementale: quando modifichi un file, solo quel file e le sue dipendenze vengono ricompilati, non l'intero progetto. Questo rende il ciclo di sviluppo iterativo accettabile anche per progetti di grandi dimensioni.

Il comando `cargo check` è un'arma segreta per lo sviluppo rapido. Invece di compilare completamente il codice (generare binari), esegue solo il type checking e la verifica degli errori. È significativamente più veloce di `cargo build` e ideale per iterazioni rapide mentre scrivi codice. Solo quando sei soddisfatto del codice usi `cargo build` o `cargo run` per generare ed eseguire l'eseguibile.

## Esempio

Workflow tipico di sviluppo:

```bash
# Modifica il codice in src/main.rs
# ...

# Verifica errori (veloce)
cargo check

# Correggi eventuali errori
# ...

# Compila ed esegui
 cargo run

# I test automatizzati
cargo test

# Ottimizza per release
cargo build --release
```

Questo ciclo permette di sviluppare in modo iterativo, verificando frequentemente che il codice sia corretto.

## Pseudocodice

```bash
// CICLO EDIT-COMPILE-RUN

// Fase 1: EDIT
$ code src/main.rs
// Modifica il codice...

// Fase 2: CHECK (veloce, solo errori)
$ cargo check
    Checking mio-progetto v0.1.0
    Finished dev [unoptimized + debuginfo] target(s) in 0.15s
// Nessun errore! Procedi alla compilazione

// Se ci sono errori:
$ cargo check
    Checking mio-progetto v0.1.0
 error[E0425]: cannot find value `x` in this scope
  --> src/main.rs:10:9
   |
10 |     let y = x + 1;
   |             ^ not found in this scope

// Correggi e ripeti cargo check

// Fase 3: BUILD (compilazione completa)
$ cargo build
   Compiling mio-progetto v0.1.0
    Finished dev [unoptimized + debuginfo] target(s) in 2.34s

// Fase 4: RUN (compila se necessario ed esegue)
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.01s
     Running `target/debug/mio-progetto`
Hello, world!

// Se il codice è cambiato, cargo run ricompila automaticamente
$ cargo run
   Compiling mio-progetto v0.1.0
    Finished dev [unoptimized + debuginfo] target(s) in 1.89s
     Running `target/debug/mio-progetto`
Hello, updated world!

// COMANDI DI COMPILAZIONE

// Compilazione di sviluppo (debug)
$ cargo build
// Output: target/debug/nome-progetto

// Compilazione di release (ottimizzata)
$ cargo build --release
// Output: target/release/nome-progetto

// Compilazione di un target specifico
$ cargo build --bin nome-binario
$ cargo build --lib

// Compilazione per tutti i target
$ cargo build --all-targets

// Compilazione con features specifiche
$ cargo build --features "feature1,feature2"
$ cargo build --all-features
$ cargo build --no-default-features

// Check (più veloce, no binario)
$ cargo check
$ cargo check --all-targets

// Check con clippy (più rigoroso)
$ cargo clippy

// VERIFICA ERRORI

// Errori di compilazione
$ cargo build
error: expected `;`, found `let`
  --> src/main.rs:5:18
   |
5 |     println!("test")
   |                  ^ help: add `;` here

// Warning
$ cargo build
warning: unused variable: `x`
  --> src/main.rs:3:9
   |
3 |     let x = 5;
   |         ^ help: consider prefixing with an underscore

// Errori di stile (clippy)
$ cargo clippy
warning: equality checks against false are hard to read
  --> src/main.rs:8:8
   |
8 |     if x == false {
   |        ^^^^^^^^^^ help: try simplifying it

// ESECUZIONE

// Esegui il binario principale
$ cargo run

// Esegui con argomenti
$ cargo run -- arg1 arg2 arg3
// Nota: i -- separano argomenti di cargo da quelli del programma

// Esegui binario specifico
$ cargo run --bin nome-binario

// Esegui esempio
$ cargo run --example nome-esempio

// Esegui il binario compilato manualmente
$ ./target/debug/nome-progetto arg1 arg2

// Esegui binario di release
$ ./target/release/nome-progetto

// COMPILAZIONE INCREMENTALE

// Prima compilazione (lenta)
$ cargo build
   Compiling progetto v0.1.0
    Finished ... in 15.23s

// Seconda compilazione (veloce, nessuna modifica)
$ cargo build
    Finished ... in 0.02s  // Nessuna ricompilazione!

// Dopo modifica a main.rs
$ cargo build
   Compiling progetto v0.1.0
    Finished ... in 2.45s  // Solo main.rs ricompilato

// PULIZIA E RICOMPILAZIONE COMPLETA

// Pulisci tutti i target
$ cargo clean

// Ora la prossima build sarà completa
$ cargo build
   Compiling progetto v0.1.0
    Finished ... in 15.23s  // Ricompilazione completa

// TECNICHE PER VELOCIZZARE

// 1. Usa sempre cargo check durante lo sviluppo
$ cargo watch -x check
// Ricompila automaticamente ogni volta che salvi

// 2. Installa cargo-watch per ricompilazione automatica
$ cargo install cargo-watch
$ cargo watch -x run

// 3. Compilazione parallela (default, ma verificabile)
$ CARGO_BUILD_JOBS=4 cargo build

// 4. SSD invece di HDD (molto impattante)

// 5. Sufficiente RAM (8GB minimo, 16GB consigliato)

// DEBUGGING DEL CICLO

// Verifica cosa sta ricompilando
$ cargo build -v
// Mostra comandi rustc eseguiti

// Tempi dettagliati
$ cargo build --timings
// Genera report HTML in target/cargo-timings/

// Profilo di compilazione
$ cargo build -Z self-profile
// Analisi dettagliata (nightly only)
```

## Risorse

- [Cargo Commands](https://doc.rust-lang.org/cargo/commands/index.html)
- [Build Cache](https://doc.rust-lang.org/cargo/guide/build-cache.html)
- [Build Timings](https://doc.rust-lang.org/cargo/reference/timings.html)

## Esercizio

Pratica il ciclo edit-compile-run:

1. Crea un progetto "fibonacci"
2. Implementa una funzione `fib(n: u32) -> u32` che calcola l'n-esimo numero di Fibonacci
3. Usa `cargo check` dopo ogni modifica significativa
4. Correggi eventuali errori
5. Usa `cargo run` per testare
6. Misura il tempo: `time cargo build` vs `time cargo check`

**Traccia di soluzione:**
```rust
// src/main.rs
fn main() {
    for i in 0..10 {
        println!("fib({}) = {}", i, fib(i));
    }
}

fn fib(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fib(n - 1) + fib(n - 2),
    }
}

// Comandi da provare:
// $ cargo check          # Veloce, solo errori
// $ cargo build          # Compila
// $ cargo run            # Compila ed esegue
// $ cargo run --release  # Versione ottimizzata (molto più veloce!)
// $ time cargo check     # Misura tempo
// $ time cargo build     # Misura tempo
```
