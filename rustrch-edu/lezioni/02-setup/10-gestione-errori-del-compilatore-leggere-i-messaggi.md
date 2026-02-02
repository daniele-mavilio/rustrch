# Gestione Errori del Compilatore: Leggere i Messaggi

## Teoria

Il compilatore Rust è famoso per i suoi messaggi di errore utili e dettagliati. A differenza di molti compilatori che producono errori crittici o generici, `rustc` cerca di spiegare cosa è andato storto, perché è un errore, e spesso suggerisce come correggerlo. Imparare a leggere e interpretare questi messaggi è fondamentale per sviluppare efficacemente in Rust.

Un messaggio di errore tipico include: il tipo di errore (es. `error[E0382]`), una descrizione testuale, la posizione esatta nel file (file, riga, colonna), un frammento di codice contestuale con evidenziazione dell'errore, e spesso uno o più suggerimenti (`help:`) o note (`note:`) aggiuntive. Errori complessi possono includere più sezioni con spiegazioni dettagliate.

Il sistema di errori di Rust distingue tra `error` (problemi che impediscono la compilazione) e `warning` (problemi che permettono la compilazione ma indicano codice potenzialmente problematico). I warning possono essere promossi a errori con `#![deny(warnings)]` o l'opzione `--deny warnings`. Comprendere entrambi è importante per scrivere codice robusto e manutenibile.

## Esempio

Esempio di errore comune - borrow checker:

```rust
fn main() {
    let s = String::from("hello");
    let r1 = &s;
    let r2 = &mut s;  // Errore!
    println!("{}", r1);
}
```

Il compilatore produce:

```
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable
 --> src/main.rs:4:14
  |
3 |     let r1 = &s;
  |              -- immutable borrow occurs here
4 |     let r2 = &mut s;
  |              ^^^^^^ mutable borrow occurs here
5 |     println!("{}", r1);
  |                  -- immutable borrow later used here
```

Questo messaggio spiega chiaramente: c'è un borrow immutabile attivo, non puoi crearne uno mutabile, e il borrow immutabile viene usato dopo.

## Pseudocodice

```rust
// STRUTTURA MESSAGGI DI ERRORE

// Tipo di errore e codice
error[E0382]: use of moved value
// ^^^^^ tipo     ^^^^^ codice errore

// Descrizione
  --> src/main.rs:5:14
//      ^^^^^^^^^^^^^ posizione

// Codice contestuale
   |
 5 |     println!("{}", s);
   |                   ^ value used here after move
   |

// Suggerimento
help: consider cloning the value
   |
 5 |     println!("{}", s.clone());
   |                    ++++++++

// NOTA IMPORTANTE
// I codici errore sono cliccabili in VS Code
// e linkano alla documentazione: https://doc.rust-lang.org/error_codes/E0382.html

// ERRORI COMUNI E COME LEGGERLI

// 1. MOVE SEMANTICS (E0382)
fn main() {
    let s = String::from("hello");
    let s2 = s;  // s viene spostato
    println!("{}", s);  // Errore!
}

// Errore:
// error[E0382]: borrow of moved value: `s`
//   --> src/main.rs:4:20
//    |
// 3  |     let s2 = s;
//    |              - value moved here
// 4  |     println!("{}", s);
//    |                    ^ value borrowed here after move

// SOLUZIONE: usa .clone() o passa per riferimento

// 2. MUTABLE BORROW (E0502)
fn main() {
    let mut v = vec![1, 2, 3];
    for i in &v {
        v.push(*i);  // Errore!
    }
}

// Errore:
// error[E0502]: cannot borrow `v` as mutable because 
//               it is also borrowed as immutable

// SOLUZIONE: collect prima o usa indici

// 3. LIFETIME (E0597)
fn main() {
    let r;
    {
        let x = 5;
        r = &x;  // Errore!
    }
    println!("{}", r);
}

// Errore:
// error[E0597]: `x` does not live long enough

// SOLUZIONE: r = x; (ownership) o sposta x fuori

// 4. TYPE MISMATCH (E0308)
fn main() {
    let x: i32 = "hello";  // Errore!
}

// Errore:
// error[E0308]: mismatched types
//   --> src/main.rs:2:18
//    |
// 2  |     let x: i32 = "hello";
//    |            ---   ^^^^^^^ expected `i32`, found `&str`

// 5. UNRESOLVED IMPORT (E0432)
use std::collections::HashMap;

fn main() {
    let m = HashSet::new();  // Errore! Non importato
}

// Errore:
// error[E0433]: failed to resolve: use of undeclared crate or module `HashSet`
// help: consider importing this struct: `use std::collections::HashSet;`

// STRUMENTI PER GESTIRE ERRORI

// 1. --explain per dettagli
$ rustc --explain E0382
// Mostra spiegazione dettagliata dell'errore

// 2. Clippy per suggerimenti aggiuntivi
$ cargo clippy
// Spesso suggerisce fix automatici

// 3. Fix automatico dove possibile
$ cargo fix
// Applica correzioni automatiche sicure

// 4. Formatta errori in JSON (per tool)
$ cargo build --message-format=json

// 5. Colore e stile
$ cargo build --color=always
$ cargo build --color=never

// GESTIONE WARNING

// Warning comuni:
warning: unused variable: `x`
  --> src/main.rs:2:9
   |
2  |     let x = 5;
   |         ^ help: consider prefixing with an underscore
   |

// Ignorare specifici warning
#[allow(unused_variables)]
fn funzione() {
    let x = 5;  // Non darà warning
}

// Trattare warning come errori
// In Cargo.toml:
// [profile.dev]
// debug = true
// 
// O nel codice:
// #![deny(warnings)]

// O da riga di comando:
$ RUSTFLAGS="-D warnings" cargo build

// PATTERN RICONOSCIMENTO ERRORI

// "cannot borrow ... as mutable"
// → Problema di borrow checker, verifica lifetime e mutabilità

// "use of moved value"
// → Problema di ownership, considera clone() o riferimenti

// "does not live long enough"
// → Problema di lifetime, variabile esce dallo scope troppo presto

// "mismatched types"
// → Type error, controlla signature e conversioni

// "expected ... found ..."
// → Spesso problema di tipo o di sintassi

// "method not found"
// → Manca import del trait o tipo sbagliato

// "unresolved import"
// → Path errato o dipendenza mancante in Cargo.toml

// ESEMPI DI FIX COMUNI

// Prima:
let s = String::from("hello");
let s2 = s;
println!("{}", s);  // Errore: use of moved value

// Dopo:
let s = String::from("hello");
let s2 = s.clone();  // O: let s2 = &s;
println!("{}", s);   // OK

// Prima:
fn lunghezza(s: &String) -> usize {
    s.len()
}

// Dopo (più idiomatico):
fn lunghezza(s: &str) -> usize {  // Accetta &str
    s.len()
}

// Prima:
let mut v = vec![1, 2, 3];
for i in &v {
    v.push(*i);  // Errore
}

// Dopo:
let mut v = vec![1, 2, 3];
let len = v.len();
for i in 0..len {
    let val = v[i];
    v.push(val);
}
```

## Risorse

- [Error Index](https://doc.rust-lang.org/error_codes/index.html)
- [Compiler Errors](https://doc.rust-lang.org/rustc/error_codes/index.html)
- [Reading Rust Errors](https://blog.rust-lang.org/2016/08/10/Shape-of-errors-to-come.html)

## Esercizio

Crea un progetto con errori intenzionali e pratica la lettura:

1. Crea un progetto "errori-pratica"
2. Scrivi codice con questi errori:
   - Move semantics error (E0382)
   - Mutable borrow error (E0502)
   - Type mismatch (E0308)
3. Leggi attentamente ogni messaggio di errore
4. Correggi gli errori uno per uno
5. Verifica che compili

**Traccia di soluzione:**
```rust
// src/main.rs - versione con errori

fn main() {
    // Errore 1: Move semantics
    let s = String::from("ciao");
    let s2 = s;
    println!("{}", s);  // CORREGGI: usa s.clone() o &s
    
    // Errore 2: Mutable borrow
    let mut v = vec![1, 2, 3];
    for i in &v {
        v.push(*i);  // CORREGGI: usa indici o collect
    }
    
    // Errore 3: Type mismatch
    let x: i32 = "hello";  // CORREGGI: "hello".len() as i32
}

// Soluzioni:
// 1. let s2 = s.clone(); o println!("{}", &s);
// 2. for i in 0..v.len() { v.push(v[i]); }
// 3. let x: i32 = "hello".len() as i32;
```
