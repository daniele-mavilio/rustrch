# Clippy: Linting e Best Practices Automatiche

## Teoria

Clippy è il linter ufficiale per Rust, uno strumento che analizza il codice sorgente per trovare pattern problematici, suggerire miglioramenti idiomatici, e segnalare potenziali bug prima che diventino problemi. A differenza del compilatore che si concentra sulla correttezza, Clippy si concentra sulla qualità del codice, l'efficienza, e l'aderenza alle best practices della comunità.

Clippy include centinaia di lint (regole di analisi) che coprono diversi aspetti: stile di codice, performance, correttezza, complessità, e compatibilità. Alcuni lint sono abilitati di default (deny), altri sono warning, e altri ancora sono disabilitati ma possono essere abilitati esplicitamente. Il tool può anche applicare automaticamente correzioni sicure dove possibile, risparmiando tempo manuale.

Integrare Clippy nel workflow di sviluppo è considerata una best practice nella comunità Rust. Molti progetti configurano Clippy per essere eseguito automaticamente in CI/CD, e alcuni IDE come VS Code con rust-analyzer lo integrano nativamente per feedback in tempo reale. Usare Clippy regolarmente aiuta a mantenere il codice pulito, efficiente, e idiomatico.

## Esempio

Codice problematico che Clippy rileva:

```rust
fn main() {
    let x = 5;
    if x == true {  // Clippy suggerirà: if x
        println!("vero");
    }
    
    let v = vec![1, 2, 3];
    if v.len() == 0 {  // Clippy suggerirà: v.is_empty()
        println!("vuoto");
    }
}
```

Clippy segnala:
```
warning: equality checks against true are hard to read
 --> src/main.rs:3:8
  |
3 |     if x == true {
  |        ^^^^^^^^^ help: try simplifying it

warning: length comparison to zero
 --> src/main.rs:8:8
  |
8 |     if v.len() == 0 {
  |        ^^^^^^^^^^^^ help: using `is_empty` is clearer
```

## Pseudocodice

```bash
// INSTALLAZIONE E SETUP

// Clippy è incluso in rustup
$ rustup component add clippy

// Verifica installazione
$ cargo clippy --version

// USO BASE

// Esegui clippy sul progetto
$ cargo clippy

// Esegui clippy con tutti i target
$ cargo clippy --all-targets

// Esegui clippy con tutte le features
$ cargo clippy --all-features

// Combinazione
$ cargo clippy --all-targets --all-features

// Fix automatico dove possibile
$ cargo clippy --fix

// Fix e applica (senza conferma interattiva)
$ cargo clippy --fix --allow-staged

// Fix anche modifiche non staged (pericoloso!)
$ cargo clippy --fix --allow-dirty

// LIVELLI DI SEVERITÀ

// Abilita tutti i lint (molto severo)
$ cargo clippy -- -W clippy::all

// Solo warning (default)
$ cargo clippy -- -W clippy::pedantic

// Tratta warning come errori (utile per CI)
$ cargo clippy -- -D warnings

// Disabilita lint specifico
$ cargo clippy -- -A clippy::lint_name

// CATEGORIE DI LINT

// 1. CORRETTEZZA (bug potenziali)
// - clippy::correctness: problemi che causano bug
$ cargo clippy -- -W clippy::correctness

// 2. SUSPICIOUS (codice sospetto)
// - clippy::suspicious: pattern probabilmente sbagliati
$ cargo clippy -- -W clippy::suspicious

// 3. COMPLESSITÀ (codice troppo complesso)
// - clippy::complexity: codice che può essere semplificato
$ cargo clippy -- -W clippy::complexity

// 4. PERFORMANCE
// - clippy::perf: ottimizzazioni possibili
$ cargo clippy -- -W clippy::perf

// 5. STILE
// - clippy::style: best practices idiomatiche
$ cargo clippy -- -W clippy::style

// 6. PEDANTIC (molto severo)
// - clippy::pedantic: regole severe
$ cargo clippy -- -W clippy::pedantic

// 7. RESTRICTION (disabilitati di default)
// - clippy::restriction: regole molto restrittive
$ cargo clippy -- -W clippy::restriction

// ESEMPI DI LINT COMUNI

// 1. Confronto con booleani
// ANTI-PATTERN:
if x == true { }

// CORRETTO:
if x { }

// 2. Confronto lunghezza con zero
// ANTI-PATTERN:
if vec.len() == 0 { }
if vec.len() != 0 { }

// CORRETTO:
if vec.is_empty() { }
if !vec.is_empty() { }

// 3. Unnecessary clone
// ANTI-PATTERN:
let s = string.clone();  // se string non serve più

// CORRETTO:
let s = string;  // sposta ownership

// 4. Match con singolo pattern
// ANTI-PATTERN:
match option {
    Some(x) => println!("{}", x),
    None => (),
}

// CORRETTO:
if let Some(x) = option {
    println!("{}", x);
}

// 5. Filter next
// ANTI-PATTERN:
iter.filter(|x| x > 0).next()

// CORRETTO:
iter.find(|x| x > 0)

// 6. Filter map collect
// ANTI-PATTERN:
iter.filter(|x| x.is_ok()).map(|x| x.unwrap()).collect()

// CORRETTO:
iter.flatten().collect()

// 7. Manual unwrap or
// ANTI-PATTERN:
match option {
    Some(x) => x,
    None => default,
}

// CORRETTO:
option.unwrap_or(default)

// 8. Single char pattern
// ANTI-PATTERN:
string.replace("a", "b")

// CORRETTO:
string.replace('a', 'b')

// 9. ToString in format!
// ANTI-PATTERN:
format!("{}", x.to_string())

// CORRETTO:
format!("{}", x)

// CONFIGURAZIONE CLIPPY

// In .clippy.toml o clippy.toml
// 
// disabilita lint specifici
// avoid-breaking-exported-api = false
// 
// configurazione specifica per lint
// single-char-binding-names-threshold = 5
// too-many-arguments-threshold = 10

// In Cargo.toml
// [package.metadata.clippy]
// allowed-lints = ["clippy::module_name_repetitions"]

// In codice (disabilita lint specifico)
#[allow(clippy::lint_name)]
fn funzione_con_eccezione() {}

// Disabilita per blocco
#[allow(clippy::pedantic)]
mod codice_legacy {
    // ...
}

// Disabilita globalmente nel file
#![allow(clippy::module_name_repetitions)]

// INTEGRAZIONE CON RUST-ANALYZER

// In .vscode/settings.json:
{
    "rust-analyzer.checkOnSave.command": "clippy",
    "rust-analyzer.checkOnSave.extraArgs": [
        "--all-targets",
        "--",
        "-W", "clippy::all"
    ]
}

// INTEGRAZIONE CI/CD

// .github/workflows/ci.yml
// jobs:
//   clippy:
//     runs-on: ubuntu-latest
//     steps:
//       - uses: actions/checkout@v3
//       - name: Run Clippy
//         run: cargo clippy --all-targets --all-features -- -D warnings

// COMMON FIXES

// Before:
fn example1(x: bool) {
    if x == true {
        println!("yes");
    }
}

fn example2(v: &Vec<i32>) {
    if v.len() != 0 {
        println!("not empty");
    }
}

fn example3(s: String) {
    let s2 = s.clone();
    drop(s);
    println!("{}", s2);
}

// After:
fn example1(x: bool) {
    if x {
        println!("yes");
    }
}

fn example2(v: &[i32]) {  // Also: prefer slice over &Vec
    if !v.is_empty() {
        println!("not empty");
    }
}

fn example3(s: String) {
    println!("{}", s);  // No clone needed
}

// WORKFLOW CONSIGLIATO

// 1. Sviluppo locale
$ cargo check          # Feedback rapido
$ cargo clippy         # Qualità codice

// 2. Pre-commit
$ cargo fmt
$ cargo clippy -- -D warnings
$ cargo test

// 3. CI/CD
$ cargo clippy --all-targets --all-features -- -D warnings
$ cargo test --all-features
```

## Risorse

- [Clippy Documentation](https://doc.rust-lang.org/clippy/)
- [Clippy Lints](https://rust-lang.github.io/rust-clippy/master/index.html)
- [Configuration](https://doc.rust-lang.org/clippy/configuration.html)

## Esercizio

Correggi il codice seguente usando i suggerimenti di Clippy:

```rust
fn main() {
    let v = vec![1, 2, 3];
    
    // Problema 1
    if v.len() == 0 {
        println!("Vuoto");
    }
    
    // Problema 2
    let s = String::from("hello");
    let s2 = s.clone();
    drop(s);
    println!("{}", s2);
    
    // Problema 3
    let x = true;
    if x == true {
        println!("Vero");
    }
    
    // Problema 4
    let opt = Some(5);
    match opt {
        Some(n) => println!("{}", n),
        None => (),
    }
}
```

**Traccia di soluzione:**
```rust
fn main() {
    let v = vec![1, 2, 3];
    
    // Fix 1: usa is_empty()
    if v.is_empty() {
        println!("Vuoto");
    }
    
    // Fix 2: rimuovi clone inutile
    let s = String::from("hello");
    println!("{}", s);
    
    // Fix 3: semplifica confronto booleano
    let x = true;
    if x {
        println!("Vero");
    }
    
    // Fix 4: usa if let
    let opt = Some(5);
    if let Some(n) = opt {
        println!("{}", n);
    }
}

// Esegui:
// cargo clippy --fix
// per applicare correzioni automatiche
```
