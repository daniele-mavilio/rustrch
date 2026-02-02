# Gestione Versioni Rust con rustup

## Teoria

`rustup` non è solo un installer: è anche un gestore di versioni completo che permette di installare, gestire e passare facilmente tra diverse versioni di Rust. Questo è fondamentale quando si lavora su progetti che richiedono versioni specifiche di Rust, quando si vogliono testare le ultime funzionalità sperimentali, o quando si mantengono librerie che devono supportare multiple versioni di Rust (MSRV - Minimum Supported Rust Version).

Rust ha tre "release channels": Stable (stabile, aggiornata ogni 6 settimane), Beta (in preparazione per la prossima stable, utile per testare in anticipo), e Nightly (build giornaliera con le ultime funzionalità sperimentali). `rustup` permette di installare e switchare tra queste toolchain istantaneamente, e persino di installare versioni specifiche datate o compilazioni personalizzate.

Una funzionalità particolarmente utile è la capacità di specificare toolchain a livello di directory: puoi avere un progetto che usa Rust 1.65.0, un altro che usa l'ultima stable, e un terzo che usa nightly per sperimentare con funzionalità in sviluppo. `rustup` gestisce automaticamente lo switch quando cambi directory.

## Esempio

Gestione semplice delle toolchain:

```bash
# Installa nightly
$ rustup install nightly

# Passa a nightly come default
$ rustup default nightly

# Usa nightly per un comando specifico
$ rustup run nightly cargo build

# Specifica toolchain per una directory
$ cd mio-progetto
$ rustup override set 1.70.0
```

## Pseudocodice

```bash
// COMANDI BASE RUSTUP

// Lista toolchain installate
$ rustup show
// o
$ rustup toolchain list

// Installa toolchain
$ rustup install stable
$ rustup install nightly
$ rustup install beta
$ rustup install 1.70.0

// Rimuovi toolchain
$ rustup toolchain uninstall nightly

// Aggiorna tutte le toolchain
$ rustup update

// Aggiorna toolchain specifica
$ rustup update stable

// CAMBIARE TOOLCHAIN DEFAULT

// Imposta stable come default
$ rustup default stable

// Imposta nightly come default
$ rustup default nightly

// Imposta versione specifica come default
$ rustup default 1.70.0

// OVERRIDE PER DIRECTORY

// Imposta toolchain per directory corrente
$ rustup override set nightly

// Usa versione specifica
$ rustup override set 1.65.0

// Rimuovi override
$ rustup override unset

// Lista tutti gli override
$ rustup override list

// USARE TOOLCHAIN TEMPORANEAMENTE

// Esegui comando con toolchain specifica
$ rustup run nightly cargo build
$ rustup run 1.70.0 cargo test

// Shortcut: +nightly
$ cargo +nightly build
$ cargo +1.70.0 test

// COMPONENTI AGGIUNTIVI

// Lista componenti disponibili
$ rustup component list

// Installa componente
$ rustup component add clippy
$ rustup component add rustfmt
$ rustup component add rust-src
$ rustup component add rust-analysis
$ rustup component add rls

// Installa per toolchain specifica
$ rustup component add clippy --toolchain nightly

// Rimuovi componente
$ rustup component remove clippy

// TARGET MULTIPLI

// Lista target installati
$ rustup target list

// Lista target installati (installed)
$ rustup target list --installed

// Installa target
$ rustup target add x86_64-pc-windows-gnu
$ rustup target add wasm32-unknown-unknown
$ rustup target add aarch64-unknown-linux-gnu

// Rimuovi target
$ rustup target remove wasm32-unknown-unknown

// Cross-compilazione
$ cargo build --target x86_64-pc-windows-gnu

// TOOLCHAIN PERSONALIZZATE

// Installa da URL specifica
$ rustup toolchain link mia-toolchain /path/to/rustc

// Link toolchain locale
$ rustup toolchain link dev /home/user/rust/build/x86_64-unknown-linux-gnu/stage1

// Rimuovi toolchain custom
$ rustup toolchain uninstall mia-toolchain

// PINNING VERSIONE IN PROGETTO

// rust-toolchain.toml nella root del progetto
[toolchain]
channel = "1.70.0"
components = ["rustfmt", "clippy"]
targets = ["x86_64-unknown-linux-gnu"]
profile = "minimal"

// rust-toolchain (file legacy, senza estensione)
1.70.0

// MANIFESTO RUST-TOOLCHAIN.TOML

[toolchain]
# Canale: stable, beta, nightly, o versione specifica
channel = "nightly-2023-01-01"

# Componenti da installare automaticamente
components = ["rust-src", "rustfmt", "clippy", "llvm-tools-preview"]

# Target aggiuntivi
targets = ["wasm32-unknown-unknown"]

# Profilo: minimal, default, complete
profile = "default"

// PROFILES

// minimal: solo rustc, rust-std, cargo
// default: minimal + rust-docs, rustfmt, clippy
// complete: tutto

// WORKFLOW TIPICO

// 1. Sviluppo normale con stable
$ rustup default stable
$ cargo build

// 2. Testare feature sperimentali
$ rustup install nightly
$ rustup run nightly cargo build

// 3. Progetto legacy che richiede versione specifica
$ cd legacy-project
$ rustup override set 1.60.0

// 4. Cross-compilazione
$ rustup target add wasm32-unknown-unknown
$ cargo build --target wasm32-unknown-unknown

// VERIFICHE E MANUTENZIONE

// Verifica installazione
$ rustup check

// Mostra versione rustup
$ rustup --version

// Mostra help
$ rustup help

// Verifica toolchain attiva
$ rustc --print sysroot

// Mostra commit hash
$ rustc --version --verbose

// RISOLUZIONE PROBLEMI

// Se cargo/rustc non trovati:
$ source $HOME/.cargo/env
// Oppure riavvia terminale

// Reinstalla toolchain corrotta
$ rustup toolchain uninstall stable
$ rustup toolchain install stable

// Pulizia
$ rustup self uninstall  # Rimuove tutto!

// MSRV (MINIMUM SUPPORTED RUST VERSION)

// In Cargo.toml
[package]
name = "mia-libreria"
version = "1.0.0"
rust-version = "1.65"  # MSRV

// In CI, testa con MSRV
// .github/workflows/ci.yml:
// strategy:
//   matrix:
//     rust: [1.65.0, stable, nightly]

// GESTIONE NIGHTLY

// Installa nightly specifica
$ rustup install nightly-2023-10-15

// Usa nightly per feature sperimentali
$ cargo +nightly build

// Aggiorna nightly
$ rustup update nightly

// Feature flag necessarie solo in nightly
#![feature(async_closure)]
#![feature(generic_const_exprs)]

// INSTALLAZIONE DA SORGENTE

// Scarica e compila Rust da sorgente
$ git clone https://github.com/rust-lang/rust.git
$ cd rust
$ ./x.py setup
$ ./x.py build
$ rustup toolchain link stage1 build/x86_64-unknown-linux-gnu/stage1

// UTILIZZO IN SCRIPT E CI

# .github/workflows/test.yml
name: Test Multiple Versions
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        rust: [1.65.0, stable, beta, nightly]
    steps:
      - uses: actions/checkout@v3
      - name: Install Rust
        uses: dtolnay/rust-action@stable
        with:
          toolchain: ${{ matrix.rust }}
      - run: cargo test
```

## Risorse

- [rustup Documentation](https://rust-lang.github.io/rustup/)
[Override Precedence](https://rust-lang.github.io/rustup/overrides.html)
- [Toolchain Specification](https://rust-lang.github.io/rustup/concepts/toolchains.html)

## Esercizio

Sperimenta con le diverse toolchain:

1. Verifica quali toolchain hai installate
2. Installa una versione specifica (es. 1.70.0)
3. Crea due progetti:
   - "moderno": usa stable
   - "legacy": usa 1.70.0 con override
4. Verifica che ognuno usi la toolchain corretta con `rustc --version`
5. Crea un file `rust-toolchain.toml` in uno dei progetti

**Traccia di soluzione:**
```bash
# 1. Lista toolchain
rustup toolchain list

# 2. Installa versione specifica
rustup install 1.70.0

# 3. Crea progetti
mkdir -p test-toolchains
cd test-toolchains

cargo new moderno
cargo new legacy

# 4. Imposta override
cd legacy
rustup override set 1.70.0
cd ..

cd moderno
rustup override set stable
cd ..

# Verifica
(cd legacy && rustc --version)      # Mostra 1.70.0
(cd moderno && rustc --version)     # Mostra stable

# 5. Crea rust-toolchain.toml
cat > legacy/rust-toolchain.toml << 'EOF'
[toolchain]
channel = "1.70.0"
components = ["rustfmt", "clippy"]
EOF
```
