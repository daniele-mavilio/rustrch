# Rustfmt: Formattazione Automatica del Codice

## Teoria

`rustfmt` è il formattatore automatico ufficiale per Rust. Riformatta il codice sorgente secondo le convenzioni ufficiali di stile, garantendo consistenza in tutto il progetto e eliminando discussioni sullo stile nel team. Un codice formattato uniformemente è più facile da leggere, mantenere, e revisionare.

Il tool usa regole di formattazione basate sulla style guide ufficiale di Rust. Gestisce automaticamente: indentazione, spaziature, allineamenti, lunghezza delle righe, organizzazione degli import, formattazione di macro, e molto altro. Quando `rustfmt` riformatta il codice, il comportamento deve essere deterministico: eseguirlo multiple volte sullo stesso codice non dovrebbe produrre risultati diversi.

Integrare `rustfmt` nel workflow è semplice: si può eseguire manualmente con `cargo fmt`, configurarlo per l'esecuzione automatica al salvataggio nell'IDE, o integrarlo in CI/CD per verificare che il codice sia formattato correttamente. Molti progetti richiedono che il codice sia formattato prima di essere mergiato.

## Esempio

Codice prima di rustfmt:

```rust
fn main(){
let x=5;
if x>3{
println!("maggiore");
}
}
```

Dopo `cargo fmt`:

```rust
fn main() {
    let x = 5;
    if x > 3 {
        println!("maggiore");
    }
}
```

Il codice è automaticamente riorganizzato con indentazione corretta, spazi appropriati, e struttura pulita.

## Pseudocodice

```bash
// INSTALLAZIONE

// Rustfmt è incluso nel componente rustfmt
$ rustup component add rustfmt

// Verifica installazione
$ rustfmt --version

// COMANDI BASE

// Formatta tutto il progetto
$ cargo fmt

// Verifica formattazione (non modifica)
$ cargo fmt -- --check

// Formatta file specifico
$ rustfmt src/main.rs

// Formatta con verbosità
$ cargo fmt -- --verbose

// CONFIGURAZIONE

// Crea rustfmt.toml o .rustfmt.toml
// Nella root del progetto

// Esempio di configurazione
// rustfmt.toml
max_width = 100
tab_spaces = 4
edition = "2021"

// Configurazione completa
// rustfmt.toml
max_width = 100
hard_tabs = false
tab_spaces = 4
newline_style = "Unix"
use_small_heuristics = "Default"
reorder_imports = true
reorder_modules = true
remove_nested_parens = true
edition = "2021"
merge_derives = true
use_try_shorthand = true
use_field_init_shorthand = true
force_explicit_abi = true

// OPZIONI COMUNI

// max_width: lunghezza massima riga (default: 100)
max_width = 100

// tab_spaces: spazi per indentazione (default: 4)
tab_spaces = 4

// hard_tabs: usa tab invece di spazi (default: false)
hard_tabs = false

// newline_style: stile newline (Unix/Windows)
newline_style = "Unix"

// reorder_imports: riordina import (default: true)
reorder_imports = true

// reorder_modules: riordina moduli (default: true)
reorder_modules = true

// use_small_heuristics: linee corte (default)
use_small_heuristics = "Default"
// Opzioni: "Default", "Off", "Max"

// merge_derives: unisce derive multipli
merge_derives = true
// #[derive(Debug)]
// #[derive(Clone)]
// diventa:
// #[derive(Debug, Clone)]

// use_try_shorthand: ? invece di try!
use_try_shorthand = true

// use_field_init_shorthand: field init shorthand
use_field_init_shorthand = true
// Point { x: x, y: y } diventa Point { x, y }

// INTEGRAZIONE IDE

// VS Code
// settings.json:
{
    "editor.formatOnSave": true,
    "[rust]": {
        "editor.defaultFormatter": "rust-lang.rust-analyzer"
    }
}

// Vim
// vim-rust o ALE plugin
// let g:rustfmt_autosave = 1

// IntelliJ IDEA
// Settings → Languages → Rust → Rustfmt

// CI/CD

// .github/workflows/format.yml
// name: Format
// on: [push, pull_request]
// jobs:
//   format:
//     runs-on: ubuntu-latest
//     steps:
//       - uses: actions/checkout@v3
//       - name: Check formatting
//         run: cargo fmt -- --check

// PRE-COMMIT HOOK

// .git/hooks/pre-commit
#!/bin/bash
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.rs$')
if [ -n "$files" ]; then
    cargo fmt -- $files
    git add $files
fi

// Make executable:
// chmod +x .git/hooks/pre-commit

// ESEMPI DI FORMATTAZIONE

// Prima:
fn foo < T > ( x : T ) where T : Clone { if x . clone () . clone ( ) { println ! ( "ok" ) ; } }

// Dopo:
fn foo<T>(x: T)
where
    T: Clone,
{
    if x.clone().clone() {
        println!("ok");
    }
}

// Prima:
use std::collections::{HashMap,HashSet,BTreeMap};

// Dopo:
use std::collections::{BTreeMap, HashMap, HashSet};

// Prima:
match x {
  Some(1) => { println!("uno"); },
  Some(2) => { println!("due"); },
  _ => { println!("altro"); },
}

// Dopo:
match x {
    Some(1) => {
        println!("uno");
    }
    Some(2) => {
        println!("due");
    }
    _ => {
        println!("altro");
    }
}

// Prima:
#[derive(Debug)]
#[derive(Clone)]
struct Point {
    x: i32,
    y: i32,
}

// Dopo:
#[derive(Clone, Debug)]
struct Point {
    x: i32,
    y: i32,
}

// CONFIGURAZIONE PER PROGETTO

// Crea file rustfmt.toml nella root del progetto:
// Questo file dovrebbe essere versionato

// Esempio per progetto con preferenze specifiche
max_width = 120
tab_spaces = 4
hard_tabs = false
newline_style = "Unix"
use_small_heuristics = "Max"
reorder_imports = true
reorder_modules = true
remove_nested_parens = true
edition = "2021"

// OVERRIDE FILE SPECIFICI

// Ignorare formattazione per un file
// Aggiungi in cima al file:
// #[rustfmt::skip]

// Ignorare un item specifico
#[rustfmt::skip]
fn codice_non_formattato() {
let x=5;
let y    =    10;
}

// Ignorare un modulo intero
#[rustfmt::skip]
mod codice_generato;

// CHECK VS FORMAT

// Solo verifica (utile per CI)
$ cargo fmt -- --check

// Se il codice non è formattato, esce con codice 1

// Formatta effettivamente
$ cargo fmt

// WORKFLOW CONSIGLIATO

// 1. Configura IDE per formattare al salvataggio
// 2. Aggiungi check formattazione al pre-commit hook
// 3. Aggiungi check formattazione alla CI
// 4. Esegui cargo fmt prima di ogni commit

// DIFFERENZE CON EDIZIONI

// Formattazione può variare leggermente tra edizioni
// Specifica l'edizione nel config:
edition = "2021"

// o usa --edition:
$ rustfmt --edition 2021 src/main.rs

// TROUBLESHOOTING

// Se rustfmt fallisce:
// 1. Verifica che il codice compili
// 2. Controlla errori di sintassi
// 3. Prova con --verbose per più dettagli

// Esempio di errore:
// $ cargo fmt
// error: unable to format file
// 
// Soluzione: risolvi errori di compilazione prima
```

## Risorse

- [Rustfmt](https://github.com/rust-lang/rustfmt)
[Config Options](https://rust-lang.github.io/rustfmt/)
- [Style Guide](https://doc.rust-lang.org/style-guide/)

## Esercizio

Pratica la formattazione con rustfmt:

1. Crea un file `non-formattato.rs` con codice Rust malformattato:
   - Indentazione irregolare
   - Spaziature incoerenti
   - Righe troppo lunghe
   - Import non ordinati

2. Esegui `rustfmt non-formattato.rs`

3. Verifica il risultato

4. Crea un file `rustfmt.toml` con configurazione personalizzata
   - max_width = 80
   - tab_spaces = 2

5. Riformatta e confronta le differenze

**Traccia di soluzione:**
```rust
// non-formattato.rs (prima)
fn  main   (  ){
let    x=5;
if x>3{
println!("maggiore");   
    for i in 0..10{
        println!("{}", i);
    }
}
}

use std::collections::{HashMap,BTreeMap,HashSet};

#[derive(Debug)]
#[derive(Clone)]
struct Point{x:i32,y:i32}

// Dopo rustfmt:
fn main() {
    let x = 5;
    if x > 3 {
        println!("maggiore");
        for i in 0..10 {
            println!("{}", i);
        }
    }
}

use std::collections::{BTreeMap, HashMap, HashSet};

#[derive(Clone, Debug)]
struct Point {
    x: i32,
    y: i32,
}
```
