# Cargo.toml: Features e Profili di Compilazione

## Teoria

Le **features** in Cargo permettono di rendere opzionali certe funzionalità di una crate, riducendo i tempi di compilazione e le dimensioni del binario finale quando quelle funzionalità non sono necessarie. Una feature può abilitare dipendenze opzionali, attivare altre features, o essere usata con `cfg` nel codice per includere/escludere blocchi di codice condizionalmente.

I **profili di compilazione** definiscono come Cargo compila il codice in diverse situazioni. I profili built-in sono `dev` (per sviluppo), `release` (per produzione), e `test` (per i test). Ogni profilo ha parametri configurabili come livello di ottimizzazione (`opt-level`), informazioni di debug, e Link Time Optimization (LTO). Configurare appropriatamente questi profili è cruciale per bilanciare tempo di compilazione e prestazioni runtime.

Il profilo `dev` è ottimizzato per velocità di compilazione con `opt-level = 0` (nessuna ottimizzazione), rendendo ideale per il ciclo di sviluppo. Il profilo `release` usa `opt-level = 3` (ottimizzazioni aggressive) e spesso abilita LTO per massime prestazioni. Comprendere e configurare questi profili permette di ottimizzare sia il tempo di sviluppo che le prestazioni del software in produzione.

## Esempio

Configurazione features per una libreria di database:

```toml
[features]
default = ["sqlite"]
full = ["sqlite", "postgres", "mysql", "redis"]
sqlite = ["rusqlite"]
postgres = ["tokio-postgres"]
mysql = ["mysql_async"]
redis = ["redis"]

[dependencies]
rusqlite = { version = "0.30", optional = true }
tokio-postgres = { version = "0.7", optional = true }
```

Nel codice:
```rust
#[cfg(feature = "sqlite")]
pub mod sqlite;

#[cfg(feature = "postgres")]
pub mod postgres;
```

## Pseudocodice

```toml
// FEATURES - CONFIGURAZIONE

[features]
// Feature di default (sempre abilitate se non specificato altro)
default = ["async", "logging"]

// Feature che abilitano dipendenze opzionali
async = ["tokio", "futures"]
sqlite = ["rusqlite", "serde_json"]

// Feature che abilitano altre features
full = ["async", "sqlite", "postgres", "advanced"]

// Feature standalone (flag)
advanced = []
experimental = []

// DEPENDENZE OPZIONALI

[dependencies]
// Dipendenza opzionale (solo se feature abilitata)
rusqlite = { version = "0.30", optional = true }

// Dipendenza normale (sempre inclusa)
serde = { version = "1.0", features = ["derive"] }

// ATTIVARE FEATURE DI DIPENDENZE

[dependencies]
// tokio con feature "full" abilitata
tokio = { version = "1", features = ["full"] }

// reqwest con feature "json" abilitata
reqwest = { version = "0.11", features = ["json"] }

// UTILIZZO NEL CODICE

// In src/lib.rs o altri file:
// 
// #[cfg(feature = "async")]
// pub mod async_impl;
//
// #[cfg(not(feature = "async"))]
// pub mod sync_impl;
//
// #[cfg(all(feature = "sqlite", feature = "logging"))]
// fn log_query(query: &str) { ... }

// PROFILI DI COMPILAZIONE

[profile.dev]
opt-level = 0          # 0-3 (0 = nessuna ottimizzazione)
debug = true           # Include informazioni di debug
split-debuginfo = "..." # Gestione debug info (platform-specific)
debug-assertions = true # Abilita assert! e debug_assert!
overflow-checks = true  # Controlli overflow aritmetici
lto = false           # Link Time Optimization
panic = "unwind"      # "unwind" o "abort"
incremental = true    # Compilazione incrementale
codegen-units = 256   # Unità di compilazione parallela
rpath = false         # Runtime library search path

[profile.release]
opt-level = 3          # Ottimizzazioni massime
debug = false          # No debug info
split-debuginfo = "..."
debug-assertions = false
overflow-checks = false
lto = true            # Abilita LTO
panic = "abort"       # Più veloce, meno info di debug
codegen-units = 1     # Una sola unità per ottimizzazioni migliori
strip = true          # Rimuove simboli dal binario

[profile.test]
inherits = "dev"      # Eredita da dev, poi sovrascrive
debug = true
opt-level = 0

[profile.bench]
inherits = "release"
debug = false

// OTTIMIZZAZIONI AVANZATE

[profile.release-lto]
inherits = "release"
lto = "fat"           # LTO completo (più lento, più ottimizzato)
// lto = "thin"        # LTO veloce (compromesso)

codegen-units = 1     # Massima ottimizzazione
panic = "abort"       # Rimuovi landing pads

// Per binari piccoli
[profile.minimal]
inherits = "release"
opt-level = "z"       # Ottimizza per dimensione
codegen-units = 1
lto = true
strip = true
panic = "abort"

// CONFRONTO PROFILI

// Dev: compilazione veloce, esecuzione lenta
[profile.dev]
opt-level = 0
incremental = true
codegen-units = 256

// Release: compilazione lenta, esecuzione veloce
[profile.release]
opt-level = 3
lto = true
codegen-units = 1

// Size: binario piccolo
[profile.size]
opt-level = "s"       # Ottimizza per dimensione
lto = true

// ESEMPIO PRATICO: MOTORE DI RICERCA

[package]
name = "search-engine"
version = "0.1.0"
edition = "2021"

[features]
// Default: solo funzionalità base
default = ["fs-storage"]

// Storage backends
fs-storage = []
sqlite-storage = ["rusqlite"]
redis-storage = ["redis"]

// Funzionalità avanzate
async-crawler = ["tokio", "reqwest", "scraper"]
ml-ranking = ["ndarray", "onnxruntime"]
full-text-search = ["tantivy"]

// Tutto incluso
full = ["sqlite-storage", "redis-storage", "async-crawler", 
        "ml-ranking", "full-text-search"]

[dependencies]
// Dipendenze sempre presenti
serde = { version = "1.0", features = ["derive"] }
anyhow = "1.0"
tracing = "0.1"

// Dipendenze opzionali
rusqlite = { version = "0.30", optional = true, features = ["bundled"] }
redis = { version = "0.24", optional = true }
tokio = { version = "1", optional = true, features = ["full"] }
reqwest = { version = "0.11", optional = true, features = ["json"] }
scraper = { version = "0.18", optional = true }
ndarray = { version = "0.15", optional = true }
onnxruntime = { version = "0.0.14", optional = true }
tantivy = { version = "0.21", optional = true }

[dev-dependencies]
tokio-test = "0.4"
mockito = "1.2"

[profile.dev]
# Veloce per development
opt-level = 0
incremental = true

[profile.release]
# Ottimizzato per produzione
opt-level = 3
lto = "thin"
codegen-units = 1
panic = "unwind"

[profile.release-optimized]
# Massima ottimizzazione (compilazione più lenta)
inherits = "release"
lto = "fat"

// COMANDI PER BUILD CON FEATURES

// Build con default features
cargo build

// Build senza default features
cargo build --no-default-features

// Build con feature specifica
cargo build --features sqlite-storage

// Build con multiple features
cargo build --features "async-crawler,ml-ranking"

// Build con tutte le features
cargo build --all-features

// Test con features specifiche
cargo test --features full
```

## Risorse

- [Features](https://doc.rust-lang.org/cargo/reference/features.html)
- [Profiles](https://doc.rust-lang.org/cargo/reference/profiles.html)
- [Conditional Compilation](https://doc.rust-lang.org/reference/conditional-compilation.html)

## Esercizio

Configura un progetto "web-server" con features e profili ottimizzati:

1. Features:
   - `default = ["logging"]`
   - `logging` - abilita tracing-subscriber
   - `tls` - abilita supporto HTTPS con rustls
   - `compression` - abilita compressione gzip
   - `full = ["logging", "tls", "compression"]`

2. Profili:
   - `dev`: opt-level 1 (compromesso tra velocità e ottimizzazione)
   - `release`: LTO thin, ottimizzazioni complete
   - `production`: LTO fat, panic abort, strip simboli

**Traccia di soluzione:**
```toml
[features]
default = ["logging"]
logging = ["tracing-subscriber"]
tls = ["tokio-rustls"]
compression = ["async-compression"]
full = ["logging", "tls", "compression"]

[dependencies]
tracing-subscriber = { version = "0.3", optional = true }
tokio-rustls = { version = "0.24", optional = true }
async-compression = { version = "0.4", optional = true, features = ["gzip"] }

[profile.dev]
opt-level = 1

[profile.release]
opt-level = 3
lto = "thin"

[profile.production]
inherits = "release"
lto = "fat"
panic = "abort"
strip = true
```
