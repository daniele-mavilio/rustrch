# Pubblicare su crates.io: Preparazione

## Teoria

`crates.io` è il registro ufficiale dei pacchetti Rust, analogo a npm per JavaScript o PyPI per Python. Pubblicare una crate su crates.io rende il tuo codice disponibile alla comunità Rust globale, permettendo ad altri sviluppatori di usarlo come dipendenza nei loro progetti con un semplice `cargo add nome-crate`.

Prima di pubblicare, è essenziale preparare adeguatamente la crate: verificare che il nome sia disponibile e segua le convenzioni, assicurarsi che abbia una licenza compatibile con l'open source (MIT, Apache-2.0, o dual license MIT/Apache-2.0 sono le scelte standard), scrivere documentazione completa, includere un README chiaro, e assicurarsi che la crate compili e passi tutti i test. Una volta pubblicata, una versione non può mai essere rimossa o sovrascritta, quindi è importante verificare tutto prima del `cargo publish`.

Il processo di pubblicazione richiede un account su crates.io e un API token. Cargo gestisce l'autenticazione e la pubblicazione in modo sicuro. È anche possibile pubblicare su registry alternativi o privati configurando l'URL del registry in `Cargo.toml`.

## Esempio

Preparazione per la pubblicazione:

```bash
# 1. Verifica che il nome sia disponibile
$ cargo search nome-mia-crate

# 2. Aggiorna Cargo.toml con metadati
[package]
name = "nome-mia-crate"
version = "0.1.0"
edition = "2021"
authors = ["Il Tuo Nome <email@example.com>"]
description = "Una breve descrizione"
license = "MIT OR Apache-2.0"
repository = "https://github.com/username/repo"
documentation = "https://docs.rs/nome-mia-crate"
readme = "README.md"
keywords = ["rust", "web", "async"]
categories = ["web-programming", "asynchronous"]

# 3. Scrivi README.md
# 4. Verifica tutto compili
$ cargo build
$ cargo test
$ cargo doc

# 5. Pubblica
$ cargo publish
```

## Pseudocodice

```bash
// PREPARAZIONE ALA PUBBLICAZIONE

// 1. Verifica nome disponibile
$ cargo search mia-crate

// 2. Controlla metadati in Cargo.toml
[package]
name = "mia-crate"                    # Deve essere univoco su crates.io
version = "0.1.0"                     # Segui semver
authors = ["Nome <email@example.com>"]
edition = "2021"
description = "Descrizione breve (max 255 chars)"
documentation = "https://docs.rs/mia-crate"
homepage = "https://github.com/user/mia-crate"
repository = "https://github.com/user/mia-crate"
license = "MIT OR Apache-2.0"         # SPDX expression
license-file = "LICENSE"              # Se non usi SPDX
keywords = ["keyword1", "keyword2"]   # Max 5, da elenco approvato
categories = ["category"]              # Da elenco approvato
readme = "README.md"
exclude = ["tests/", "benches/", ".github/"]  # File da escludere
include = ["src/", "Cargo.toml", "README.md", "LICENSE"]
rust-version = "1.65"                  # MSRV

// 3. Scegli licenza
// Opzioni comuni:
// - "MIT"
// - "Apache-2.0"
// - "MIT OR Apache-2.0" (dual license, raccomandato)
// - "GPL-3.0"
// - "BSD-3-Clause"

// Crea file LICENSE
$ curl -o LICENSE https://www.apache.org/licenses/LICENSE-2.0.txt
// o usa generatori online

// 4. Scrivi README.md
// Esempio:
// # Mia Crate
// 
// Breve descrizione.
// 
// ## Installazione
// 
// ```toml
// [dependencies]
// mia-crate = "0.1.0"
// ```
// 
// ## Esempio
// 
// ```rust
// use mia_crate::funzione;
// 
// fn main() {
//     funzione();
// }
// ```
// 
// ## License
// 
// MIT OR Apache-2.0

// 5. Documentazione
// - Aggiungi doc comment a tutti i tipi pubblici
// - Include esempi nei doc tests
// - Verifica con: cargo doc --no-deps

// 6. Verifica qualità
$ cargo build
$ cargo test
$ cargo clippy -- -D warnings
$ cargo fmt --check
$ cargo doc --no-deps

// 7. Verifica pacchetto
$ cargo package --list          # Lista file inclusi
$ cargo package --allow-dirty   # Crea .crate senza commit

// 8. Testa installazione locale
$ cargo install --path .

// PUBBLICAZIONE

// 1. Login su crates.io
$ cargo login
// Inserisci API token da https://crates.io/me

// 2. Pubblica
$ cargo publish

// 3. Pubblica dry-run (test)
$ cargo publish --dry-run

// 4. Forza pubblicazione (se necessario)
$ cargo publish --allow-dirty

// VERSIONAMENTO

// Segui Semantic Versioning:
// MAJOR.MINOR.PATCH
// 
// MAJOR: Breaking changes (1.0.0 → 2.0.0)
// MINOR: New features, backward compatible (1.0.0 → 1.1.0)
// PATCH: Bug fixes (1.0.0 → 1.0.1)

// Pre-release:
// 1.0.0-alpha.1
// 1.0.0-beta.2
// 1.0.0-rc.1

// Build metadata:
// 1.0.0+build.123

// Comandi versione:
$ cargo bump minor    # Richiede cargo-bump
$ cargo set-version 1.2.0  # Richiede cargo-edit

// YANK (Ritira versione)

// Se pubblichi accidentalmente o scopri security issue:
$ cargo yank --vers 0.1.0

// Ripristina yank:
$ cargo yank --vers 0.1.0 --undo

// NOTA: yank non rimuove il codice, solo impedisce nuove dipendenze

// OWNERSHIP E TEAM

// Aggiungi owner
$ cargo owner --add username

// Rimuovi owner
$ cargo owner --remove username

// Lista owners
$ cargo owner --list

// Aggiungi team GitHub
$ cargo owner --add github:org:team

// PRE-PUBLISH CHECKLIST

// □ Versione aggiornata (segue semver)
// □ CHANGELOG.md aggiornato
// □ README.md chiaro e completo
// □ Documentazione completa (cargo doc)
// □ Tutti i test passano (cargo test)
// □ Clippy senza warning (cargo clippy)
// □ Formattazione corretta (cargo fmt --check)
// □ License file presente
// □ .gitignore appropriato
// □ No file sensibili nel pacchetto
// □ Cargo.toml con tutti i metadati
// □ Repository linkato
// □ Keywords e categories validi

// METADATA EXTRA

[package.metadata.docs.rs]
features = ["full"]
all-features = false
no-default-features = false
targets = []
rustc-args = ["--cfg", "docsrs"]

// [package.metadata.playground]
// features = ["full"]

// [badges]
// maintenance = { status = "actively-developed" }
// is-it-maintained-issue-resolution = { repository = "..." }
// is-it-maintained-open-issues = { repository = "..." }

// CI/CD PER PUBBLICAZIONE

// .github/workflows/release.yml:
// name: Release
// on:
//   push:
//     tags:
//       - 'v*'
// jobs:
//   publish:
//     runs-on: ubuntu-latest
//     steps:
//       - uses: actions/checkout@v3
//       - uses: dtolnay/rust-action@stable
//       - name: Publish
//         run: cargo publish --token ${{ secrets.CRATES_IO_TOKEN }}

// COMANDI UTILI

// Crea template per nuova crate
$ cargo new --lib mia-crate

// Verifica prima di pubblicare
$ cargo publish --dry-run

// Installa da crates.io
$ cargo install mia-crate

// Aggiorna versione in dipendenze
$ cargo update -p mia-crate

// Cerca crate
$ cargo search keyword

// Info su crate
$ cargo info mia-crate  # Richiede cargo-info
```

## Risorse

- [Publishing on crates.io](https://doc.rust-lang.org/cargo/reference/publishing.html)
[crates.io Policies](https://crates.io/policies)
- [SemVer](https://semver.org/)

## Esercizio

Prepara una crate per la pubblicazione:

1. Crea una libreria `hello-utils`
2. Implementa una funzione `greet(name: &str) -> String`
3. Aggiungi documentazione completa
4. Crea README.md
5. Scegli licenza MIT
6. Verifica con `cargo package --list`
7. (Opzionale) Pubblica su crates.io

**Traccia di soluzione:**
```bash
# 1. Crea libreria
cargo new --lib hello-utils
cd hello-utils

# 2. Implementa in src/lib.rs:
/// Saluta una persona
///
/// # Examples
///
/// ```
/// use hello_utils::greet;
///
/// let greeting = greet("World");
/// assert_eq!(greeting, "Hello, World!");
/// ```
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

# 3. Aggiorna Cargo.toml
cat > Cargo.toml << 'EOF'
[package]
name = "hello-utils"
version = "0.1.0"
edition = "2021"
authors = ["Tu <tu@example.com>"]
description = "A simple greeting library"
license = "MIT"
repository = "https://github.com/tu/hello-utils"
readme = "README.md"
keywords = ["greeting", "hello"]
categories = ["text-processing"]

[dependencies]
EOF

# 4. Crea README.md
echo "# Hello Utils

A simple greeting library.

## Usage

\`\`\`toml
[dependencies]
hello-utils = \"0.1.0\"
\`\`\`

## Example

\`\`\`rust
use hello_utils::greet;

fn main() {
    println!(\"{}\", greet(\"World\"));
}
\`\``

## License

MIT" > README.md

# 5. Crea LICENSE (MIT)
curl -o LICENSE https://raw.githubusercontent.com/github/choosealicense.com/gh-pages/_licenses/mit.txt

# 6. Verifica
cargo test
cargo doc --no-deps
cargo package --list

# 7. Pubblica (se vuoi)
# cargo login
# cargo publish
```
