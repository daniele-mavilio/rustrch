# Workspace Cargo per Progetti Multi-Crate

## Teoria

Man mano che i progetti crescono, spesso diventa necessario suddividerli in più crate separate: una libreria principale, eseguibili, utility, o pacchetti condivisi. Cargo Workspace è una funzionalità che permette di gestire multiple crate correlate in un singolo progetto condividendo le dipendenze e garantendo che tutte le crate siano coerenti tra loro.

Un workspace è definito da un file `Cargo.toml` alla root che elenca i membri (le crate che fanno parte del workspace). Ogni membro ha il proprio `Cargo.toml` e può dipendere dagli altri membri del workspace. La directory `target/` è condivisa, riducendo lo spazio su disco e i tempi di compilazione, e il file `Cargo.lock` è unico per tutto il workspace, garantendo che tutte le crate usino le stesse versioni delle dipendenze.

I workspace sono ideali per: progetti con libreria + binari multipli, monorepo con pacchetti correlati, sviluppo di ecosistemi (libreria core + adapter + tool), o semplicemente per organizzare codice in unità logiche separate mantenendo la sincronizzazione.

## Esempio

Struttura di un workspace tipico:

```
mio-workspace/
├── Cargo.toml              # Workspace manifest
├── Cargo.lock              # Condiviso
├── target/                 # Condiviso
├── libreria-core/
│   ├── Cargo.toml
│   └── src/lib.rs
├── app-cli/
│   ├── Cargo.toml
│   └── src/main.rs
└── app-server/
    ├── Cargo.toml
    └── src/main.rs
```

`Cargo.toml` del workspace:
```toml
[workspace]
members = [
    "libreria-core",
    "app-cli",
    "app-server",
]
resolver = "2"
```

## Pseudocodice

```bash
// STRUTTURA WORKSPACE

// File: Cargo.toml (root)
[workspace]
members = ["crate1", "crate2", "utils/*"]
resolver = "2"

[workspace.package]
version = "1.0.0"
authors = ["Team <team@example.com>"]
edition = "2021"
license = "MIT"
repository = "https://github.com/org/project"

[workspace.dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
anyhow = "1.0"

// CRATE MEMBRO

// File: crate1/Cargo.toml
[package]
name = "crate1"
version.workspace = true
authors.workspace = true
edition.workspace = true
license.workspace = true

[dependencies]
serde = { workspace = true }
tokio = { workspace = true }
crate2 = { path = "../crate2" }  # Dipendenza da altro membro

// File: crate2/Cargo.toml
[package]
name = "crate2"
version.workspace = true

[dependencies]
anyhow = { workspace = true }

// ESEMPI PRATICI

// Esempio 1: Libreria + CLI + Server
// 
// my-search-engine/
// ├── Cargo.toml
// ├── search-lib/
// │   ├── Cargo.toml
// │   └── src/
// │       └── lib.rs
// ├── search-cli/
// │   ├── Cargo.toml
// │   └── src/
// │       └── main.rs
// └── search-server/
//     ├── Cargo.toml
//     └── src/
//         └── main.rs

// Cargo.toml (workspace)
[workspace]
members = ["search-lib", "search-cli", "search-server"]
resolver = "2"

[workspace.dependencies]
tokio = { version = "1", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
anyhow = "1.0"

// search-lib/Cargo.toml
[package]
name = "search-lib"
version = "0.1.0"
edition = "2021"

[dependencies]
tokio = { workspace = true }
serde = { workspace = true }

// search-cli/Cargo.toml
[package]
name = "search-cli"
version = "0.1.0"
edition = "2021"

[dependencies]
search-lib = { path = "../search-lib" }
anyhow = { workspace = true }

// Esempio 2: Utils multiple
//
// Cargo.toml
[workspace]
members = ["utils/*", "apps/*"]

// utils/logger/Cargo.toml
[package]
name = "logger"

// utils/config/Cargo.toml
[package]
name = "config"

// apps/main-app/Cargo.toml
[package]
name = "main-app"

[dependencies]
logger = { path = "../../utils/logger" }
config = { path = "../../utils/config" }

// COMANDI NEL WORKSPACE

// Build di tutto il workspace
$ cargo build

// Build di crate specifico
$ cargo build -p crate1

// Test di tutto il workspace
$ cargo test

// Test di crate specifico
$ cargo test -p crate1

// Run di un eseguibile specifico
$ cargo run -p app-cli

// Check di tutto
$ cargo check --all

// Dipendenze del workspace
$ cargo tree
$ cargo tree -p crate1

// AGGIUNGERE NUOVA CRATE

// 1. Crea directory
$ mkdir nuova-crate
$ cd nuova-crate
$ cargo init --lib

// 2. Aggiorna workspace Cargo.toml
members = [..., "nuova-crate"]

// 3. Definisci dipendenze
// nuova-crate/Cargo.toml
[package]
name = "nuova-crate"
version.workspace = true

[dependencies]
# dipendenze...

// WORKSPACE METADATA

// Inherit da workspace
[package]
name = "my-crate"
version.workspace = true
authors.workspace = true
description.workspace = true
documentation.workspace = true
readme.workspace = true
homepage.workspace = true
repository.workspace = true
license.workspace = true
keywords.workspace = true
categories.workspace = true
edition.workspace = true
rust-version.workspace = true

// In workspace Cargo.toml
[workspace.package]
version = "1.0.0"
authors = ["Team"]
edition = "2021"
license = "MIT"
repository = "https://..."

// DEPENDENZE WORKSPACE

// Definisci nel workspace
[workspace.dependencies]
serde = "1.0"
tokio = { version = "1", features = ["full"] }

// Usa nei membri
[dependencies]
serde = { workspace = true }
tokio = { workspace = true, features = ["rt"] }  # Override features

// TARGET WORKSPACE

[workspace]
members = ["crate1", "crate2"]
default-members = ["crate1"]  # Default per cargo build/run

// PROFILE WORKSPACE

// Definisci nel workspace (applica a tutti i membri)
[profile.dev]
opt-level = 1

[profile.release]
lto = true

// FEATURES WORKSPACE

[workspace.dependencies]
my-lib = { path = "my-lib", default-features = false }

// PATCH WORKSPACE

[patch.crates-io]
crate1 = { path = "../crate1" }

// PATCH nel workspace applica a tutti i membri

// ESEMPI AVANZATI

// Esempio: Condividi codice tra binari
// workspace/
// ├── Cargo.toml
// ├── shared/
// │   ├── Cargo.toml
// │   └── src/lib.rs
// ├── cli1/
// │   ├── Cargo.toml
// │   └── src/main.rs
// └── cli2/
//     ├── Cargo.toml
//     └── src/main.rs

// shared/Cargo.toml
[package]
name = "shared"

// cli1/Cargo.toml
[dependencies]
shared = { path = "../shared" }

// Esempio: Testing con setup condiviso
// tests/ nella root del workspace
// Non funziona con workspace - usa crate specifiche

// Esempio: Dev dependencies condivise
[workspace.dependencies]
mockall = { version = "0.12", optional = true }

// Esempio: Versioni consistenti
// Tutte le crate usano la stessa versione di serde
// definita nel workspace

// VANTAGGI WORKSPACE

// 1. Compilazione incrementale condivisa
// - Modifica a una crate non ricompila tutto

// 2. Dipendenze deduplicate
// - Una sola versione di ogni crate

// 3. Versioni consistenti
// - Tutte usano le stesse dipendenze

// 4. Target condiviso
// - Una sola directory target/

// 5. Lock file unico
// - Tutte sincronizzate sulla stessa versione

// LIMITAZIONI

// - Non puoi avere dipendenze circolari tra membri
// - Più complesso per progetti semplici
// - Pubblicazione su crates.io richiede coordinamento

// COMANDI UTILI

// Lista membri
$ cargo metadata --format-version 1 | jq '.workspace_members'

// Build solo membri modificati
$ cargo build --workspace

// Check veloce di tutto
$ cargo check --all

// Test con code coverage
$ cargo tarpaulin --workspace

// Documentazione di tutto
$ cargo doc --workspace --no-deps
```

## Risorse

- [Workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html)
[Workspace Guide](https://doc.rust-lang.org/cargo/reference/workspaces.html)
- [Advanced Workspaces](https://matklad.github.io/2021/08/22/large-rust-workspaces.html)

## Esercizio

Crea un workspace per un motore di ricerca:

1. Crea directory `search-engine-workspace`
2. Inizializza workspace con 3 membri:
   - `search-core` (libreria core)
   - `search-cli` (CLI tool)
   - `search-web` (server web)
3. Configura dipendenze workspace:
   - `serde`, `tokio`, `anyhow`
4. Fai dipendere cli e web da core
5. Builda tutto con `cargo build`

**Traccia di soluzione:**
```bash
# Crea struttura
mkdir search-engine-workspace
cd search-engine-workspace

# Crea workspace manifest
cat > Cargo.toml << 'EOF'
[workspace]
members = ["search-core", "search-cli", "search-web"]
resolver = "2"

[workspace.dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
anyhow = "1.0"
EOF

# Crea crate
cargo new --lib search-core
cargo new --bin search-cli
cargo new --bin search-web

# Configura search-core
# (già fatto da cargo new --lib)

# Configura search-cli
cat > search-cli/Cargo.toml << 'EOF'
[package]
name = "search-cli"
version = "0.1.0"
edition = "2021"

[dependencies]
search-core = { path = "../search-core" }
serde = { workspace = true }
anyhow = { workspace = true }
EOF

# Configura search-web
cat > search-web/Cargo.toml << 'EOF'
[package]
name = "search-web"
version = "0.1.0"
edition = "2021"

[dependencies]
search-core = { path = "../search-core" }
tokio = { workspace = true }
serde = { workspace = true }
EOF

# Builda
$ cargo build
```
