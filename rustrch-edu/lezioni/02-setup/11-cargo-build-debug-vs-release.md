# Cargo build: Debug vs Release

## Teoria

Cargo gestisce automaticamente due profili di compilazione principali: `dev` (debug) e `release`. Questi profili determinano il trade-off tra velocità di compilazione e prestazioni del codice generato. Comprendere la differenza è essenziale per scegliere il profilo giusto per ogni fase dello sviluppo.

Il profilo `dev` (usato da `cargo build` e `cargo run`) è ottimizzato per il ciclo di sviluppo: compila velocemente, include informazioni di debug complete, abilita controlli di overflow, e usa `panic = "unwind"` per permettere il recovery da panic. Il codice generato è meno ottimizzato ma ideale per iterazioni rapide e debugging.

Il profilo `release` (usato da `cargo build --release`) è ottimizzato per la produzione: applica ottimizzazioni aggressive (opt-level = 3), può abilitare LTO (Link Time Optimization), rimuove controlli di debug, e opzionalmente usa `panic = "abort"` per binari più piccoli e veloci. La compilazione è significativamente più lenta ma il risultato è molto più performante.

## Esempio

Confronto pratico:

```bash
# Build di debug (sviluppo)
$ cargo build
# Compila in ~2 secondi
# Eseguibile: target/debug/mio-progetto (2.5MB)
# Performance: base

# Build di release (produzione)
$ cargo build --release
# Compila in ~15 secondi
# Eseguibile: target/release/mio-progetto (850KB)
# Performance: 10-100x migliore
```

Per un algoritmo di sorting, la versione release può essere 20-50 volte più veloce della versione debug.

## Pseudocodice

```bash
// CONFRONTO PROFILI

// DEBUG (dev)
$ cargo build
// o
$ cargo run

// Caratteristiche:
// - opt-level = 0 (nessuna ottimizzazione)
// - debug = true (informazioni complete)
// - debug-assertions = true (assert! attivi)
// - overflow-checks = true (controlli overflow)
// - panic = "unwind" (stack unwinding)
// - incremental = true (compilazione incrementale)
// - codegen-units = 256 (parallelismo)

// RELEASE
$ cargo build --release

// Caratteristiche:
// - opt-level = 3 (ottimizzazioni massime)
// - debug = false (no debug info)
// - debug-assertions = false (assert! disabilitati)
// - overflow-checks = false (no controlli)
// - panic = "unwind" (default) o "abort" (configurabile)
// - lto = false (default) o true/fat/thin (configurabile)
// - codegen-units = 16 (default) o 1 (massima ottimizzazione)
// - strip = false (default) o true (rimuove simboli)

// CONFIGURAZIONE IN CARGO.TOML

[profile.dev]
opt-level = 0
debug = true
split-debuginfo = "..."
debug-assertions = true
overflow-checks = true
lto = false
panic = "unwind"
incremental = true
codegen-units = 256
rpath = false

[profile.release]
opt-level = 3
debug = false
split-debuginfo = "..."
debug-assertions = false
overflow-checks = false
lto = false
panic = "unwind"
incremental = false
codegen-units = 16
rpath = false

// PROFILI PERSONALIZZATI

[profile.release-optimized]
inherits = "release"
lto = "fat"
codegen-units = 1
panic = "abort"

[profile.small]
inherits = "release"
opt-level = "z"  # Ottimizza per dimensione
lto = true
codegen-unints = 1
panic = "abort"
strip = true

// UTILIZZO PROFILI PERSONALIZZATI

$ cargo build --profile release-optimized
// Output in target/release-optimized/

$ cargo build --profile small
// Output in target/small/

// LIVELLI DI OTTIMIZZAZIONE

opt-level = 0    # Nessuna ottimizzazione (default dev)
opt-level = 1    # Ottimizzazioni basiche
opt-level = 2    # Ottimizzazioni moderate
opt-level = 3    # Ottimizzazioni aggressive (default release)
opt-level = "s"  # Ottimizza per dimensione piccola
opt-level = "z"  # Ottimizza per dimensione minima (aggressive)

// LINK TIME OPTIMIZATION (LTO)

lto = false      # Nessun LTO (default)
lto = true       # LTO completo (più lento, migliore)
lto = "thin"     # Thin LTO (compromesso)
lto = "fat"      # LTO completo esplicito
lto = "off"      # Disabilita esplicitamente

// PANIC HANDLING

panic = "unwind"  # Default, permette catch di panic
panic = "abort"   # Termina immediatamente, binario più piccolo

// PRATICHE CONSIGLIATE

// 1. Sviluppo: usa sempre cargo build / cargo run
$ cargo run -- arg1 arg2

// 2. Benchmark: usa sempre --release
$ cargo run --release -- arg1 arg2

// 3. Test di performance
$ time cargo run --release

// 4. Dimensione binario
$ ls -lh target/release/mio-progetto

// 5. Profiling: compila con debug symbols anche in release
[profile.release]
debug = true  # Necessario per profiling

// 6. Verifica ottimizzazioni
$ cargo build --release -v

// CONFRONTO PERFORMANCE (esempio tipico)

// Fibonacci(40):
// Debug:   ~15 secondi
// Release: ~0.3 secondi (50x più veloce)

// Sorting 1M elementi:
// Debug:   ~2.5 secondi
// Release: ~0.15 secondi (16x più veloce)

// Esempio benchmark
fn main() {
    let start = std::time::Instant::now();
    
    // Operazione costosa
    let mut sum = 0u64;
    for i in 0..10_000_000 {
        sum += i * i;
    }
    
    let duration = start.elapsed();
    println!("Somma: {}", sum);
    println!("Tempo: {:?}", duration);
}

// Debug output:
// Tempo: 2.456s

// Release output:
// Tempo: 0.001s (2000x più veloce!)

// ESEMPI REALI

// 1. Algoritmo di ricerca
$ cargo run  # Debug - lento ma debuggabile
$ cargo run --release  # Release - veloce per benchmark

// 2. Web server
$ cargo run  # Development - hot reload rapido
$ cargo run --release  # Production - massima throughput

// 3. Tool CLI
$ cargo install --path .  # Installa versione release
$ cargo install --path . --debug  # Installa versione debug

// 4. Libreria
// Per librerie, --release influenza solo test e benchmark
$ cargo test --release  # Test con ottimizzazioni
$ cargo bench  # Sempre in release
```

## Risorse

- [Profiles](https://doc.rust-lang.org/cargo/reference/profiles.html)
- [Optimization](https://doc.rust-lang.org/cargo/reference/profiles.html#opt-level)
- [Release Builds](https://doc.rust-lang.org/book/ch14-01-release-profiles.html)

## Esercizio

Confronta debug vs release con un benchmark:

1. Crea un progetto "benchmark-test"
2. Implementa una funzione che calcola la somma dei quadrati da 0 a 10M
3. Misura il tempo con `std::time::Instant`
4. Esegui con `cargo run` e annota il tempo
5. Esegui con `cargo run --release` e confronta
6. Crea un profilo `ultra` con LTO completo e confronta

**Traccia di soluzione:**
```rust
// src/main.rs
use std::time::Instant;

fn main() {
    let start = Instant::now();
    
    let mut sum: u64 = 0;
    for i in 0..10_000_000u64 {
        sum = sum.wrapping_add(i * i);
    }
    
    let duration = start.elapsed();
    println!("Risultato: {}", sum);
    println!("Tempo impiegato: {:?}", duration);
}

// Cargo.toml aggiuntivo:
[profile.ultra]
inherits = "release"
lto = "fat"
codegen-units = 1

// Comandi:
// $ cargo run                    # Profilo dev
// $ cargo run --release          # Profilo release
// $ cargo run --profile ultra    # Profilo ultra
```
