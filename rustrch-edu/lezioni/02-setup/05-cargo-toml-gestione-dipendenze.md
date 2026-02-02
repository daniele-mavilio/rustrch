# Cargo.toml: Gestione Dipendenze

## Teoria

Il file `Cargo.toml` è il cuore di un progetto Cargo. È il manifesto che definisce metadati del progetto, dipendenze esterne, features opzionali, profili di compilazione e altre configurazioni. Scritto in formato TOML (Tom's Obvious, Minimal Language), è progettato per essere facile da leggere e scrivere sia per umani che per macchine.

La sezione `[package]` contiene metadati essenziali come nome, versione, autori, descrizione e licenza del progetto. La sezione `[dependencies]` è dove dichiari le librerie esterne di cui il tuo progetto ha bisogno. Cargo scarica automaticamente queste dipendenze da crates.io (il registro ufficiale dei pacchetti Rust) o da altre fonti configurate (git, path locali).

La gestione delle versioni in Cargo segue le regole di Semantic Versioning (SemVer). Puoi specificare versioni esatte ("=1.0.0"), versioni compatibili ("^1.0.0" o semplicemente "1.0.0"), range di versioni (">=1.0, <2.0"), o anche usare dipendenze direttamente da repository Git o da path locali. Cargo risolve automaticamente le dipendenze transitive e garantisce che vengano usate versioni compatibili.

## Esempio

Un `Cargo.toml` tipico per un motore di ricerca:

```toml
[package]
name = "search-engine"
version = "0.1.0"
edition = "2021"

[dependencies]
# Dipendenza da crates.io
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
reqwest = "0.11"

# Dipendenza da git
scraper = { git = "https://github.com/rust-scraper/scraper" }

# Dipendenza locale
my-utils = { path = "../my-utils" }
```

## Pseudocodice

```toml
// CARGO.TOML COMPLETO

[package]
name = "motore-ricerca"
version = "0.1.0"
edition = "2021"
authors = ["Mario Rossi <mario@example.com>"]
description = "Motore di ricerca scritto in Rust"
documentation = "https://docs.rs/motore-ricerca"
homepage = "https://github.com/tuo-username/motore-ricerca"
repository = "https://github.com/tuo-username/motore-ricerca"
license = "MIT OR Apache-2.0"
keywords = ["search", "web", "crawler"]
categories = ["web-programming", "text-processing"]
rust-version = "1.70"  # MSRV (Minimum Supported Rust Version)

// DIPENDENZE BASE

[dependencies]
// Versione esatta
serde = "=1.0.150"

// Versione compatibile (^1.0.0 - accetta 1.x ma non 2.0)
serde_json = "1.0"

// Versione minima (>=1.0)
tokio = ">=1.0"

// Range di versioni
reqwest = ">=0.11, <0.12"

// Con features
sqlx = { version = "0.7", features = ["runtime-tokio", "sqlite"] }

// DIPENDENZE DA GIT

[dependencies]
// Branch specifico
mio-crate = { git = "https://github.com/user/repo", branch = "main" }

// Tag specifico
mio-crate = { git = "https://github.com/user/repo", tag = "v1.0.0" }

// Revisione specifica (commit)
mio-crate = { git = "https://github.com/user/repo", rev = "abc123" }

// DIPENDENZE LOCALI

[dependencies]
// Path relativo
my-library = { path = "../my-library" }

// Path assoluto (non raccomandato)
my-library = { path = "/home/user/projects/my-library" }

// VERSIONI E SEMVER

// ^1.2.3 := >=1.2.3, <2.0.0
// ~1.2.3 := >=1.2.3, <1.3.0
// >=1.2.0
// >1.2.0
// <2.0.0
// <=1.2.0
// =1.2.3 (esatta)
// * (qualsiasi versione)

[dependencies]
anyhow = "1.0"          # ^1.0.0
thiserror = "~1.0"      # ~1.0.0
regex = ">=1.0, <2.0"   # Range

// DIPENDENZE DI SVILUPPO

[dev-dependencies]
// Solo per testing, benchmarking, esempi
mockall = "0.12"
criterion = { version = "0.5", features = ["html_reports"] }

// BUILD DEPENDENCIES

[build-dependencies]
// Usate durante la fase di build (build.rs)
cc = "1.0"

// FEATURES

[features]
// Feature di default
default = ["async", "sqlite"]

// Feature opzionali
async = ["tokio", "reqwest"]
sqlite = ["sqlx/sqlite"]
postgres = ["sqlx/postgres"]
full = ["async", "sqlite", "postgres"]

[dependencies]
// Feature opzionale
sqlx = { version = "0.7", optional = true }

// PROFILES DI COMPILAZIONE

[profile.dev]
opt-level = 0          # Nessuna ottimizzazione (build veloce)
debug = true           # Informazioni di debug
lto = false           # Link Time Optimization

[profile.release]
opt-level = 3          # Ottimizzazioni massime
debug = false          # No debug info
lto = true            # Abilita LTO
panic = "abort"       # Non unwind su panic

[profile.test]
debug = true
opt-level = 0

// WORKSPACE

[workspace]
members = ["crate1", "crate2", "tools/*"]
resolver = "2"  # Resolver version 2 (raccomandato)

// PATCH (sovrascrivere dipendenze)

[patch.crates-io]
// Usa versione locale invece di crates.io
serde = { path = "../serde-fork" }

// Usa versione da git
reqwest = { git = "https://github.com/user/reqwest" }

// REPLACE (deprecated, usare patch)

[replace]
// Vecchio sistema, usare [patch] invece

// TARGET SPECIFICO

[target.'cfg(unix)'.dependencies]
// Solo su sistemi Unix
libc = "0.2"

[target.'cfg(windows)'.dependencies]
// Solo su Windows
winapi = "0.3"

[target.'cfg(target_arch = "wasm32")'.dependencies]
// Solo per WebAssembly
wasm-bindgen = "0.2"

// BINARI AGGIUNTIVI

[[bin]]
name = "server"
path = "src/bin/server.rs"

[[bin]]
name = "cli"
path = "src/bin/cli.rs"

// ESEMPIO PRATICO: Motore di ricerca

[package]
name = "rust-search"
version = "0.1.0"
edition = "2021"

[dependencies]
# Async runtime
tokio = { version = "1", features = ["full"] }

# HTTP client
reqwest = { version = "0.11", features = ["json"] }

# HTML parsing
scraper = "0.18"

# Database
rusqlite = { version = "0.30", features = ["bundled"] }

# Serialization
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"

# Error handling
anyhow = "1.0"

# Logging
tracing = "0.1"
tracing-subscriber = "0.3"

# CLI
clap = { version = "4", features = ["derive"] }

[dev-dependencies]
mockito = "1.2"
tokio-test = "0.4"

[features]
default = ["sqlite"]
sqlite = []
postgres = ["sqlx/postgres"]

[profile.release]
lto = true
codegen-units = 1
```

## Risorse

- [Cargo.toml Format](https://doc.rust-lang.org/cargo/reference/manifest.html)
- [Specifying Dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)
- [Features](https://doc.rust-lang.org/cargo/reference/features.html)

## Esercizio

Crea un `Cargo.toml` per un progetto "image-processor" con queste caratteristiche:

1. Versione 0.1.0, edition 2021
2. Dipendenze:
   - `image` (ultima versione 0.24) per processamento immagini
   - `clap` versione 4 con feature "derive" per CLI
   - `anyhow` versione 1 per error handling
   - `tokio` versione 1 con features ["rt", "macros"] per async
3. Dev-dependencies:
   - `criterion` per benchmarking
4. Features:
   - `default = ["jpeg", "png"]`
   - `jpeg` e `png` come feature opzionali
5. Profile release con LTO abilitato

**Traccia di soluzione:**
```toml
[package]
name = "image-processor"
version = "0.1.0"
edition = "2021"

[dependencies]
image = "0.24"
clap = { version = "4", features = ["derive"] }
anyhow = "1"
tokio = { version = "1", features = ["rt", "macros"] }

[dev-dependencies]
criterion = "0.5"

[features]
default = ["jpeg", "png"]
jpeg = []
png = []

[profile.release]
lto = true
```
