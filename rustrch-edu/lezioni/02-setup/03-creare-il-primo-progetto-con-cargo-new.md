# Creare il Primo Progetto con cargo new

## Teoria

`cargo new` è il comando che inizializza un nuovo progetto Rust con tutta la struttura necessaria per iniziare a sviluppare. A differenza di creare manualmente file e directory, `cargo new` configura automaticamente il progetto seguendo le convenzioni della comunità Rust, creando una struttura standard che altri sviluppatori Rust riconosceranno immediatamente.

Il comando può creare due tipi di progetti: binari (applicazioni eseguibili) e librerie (codice riutilizzabile). Di default crea un binario, ma l'opzione `--lib` crea una libreria. La differenza principale è nel file principale: i binari hanno `src/main.rs` con una funzione `main()`, mentre le librerie hanno `src/lib.rs` esportando funzionalità pubbliche.

La struttura creata include: `Cargo.toml` (manifesto del progetto con metadati e dipendenze), `src/` (directory per il codice sorgente), `.gitignore` (preconfigurato per Rust), e opzionalmente un repository Git inizializzato. Questa struttura standardizzata permette a Cargo di gestire build, test e dipendenze in modo automatico.

## Esempio

Per creare un'applicazione di ricerca:

```bash
cargo new motore-ricerca
cd motore-ricerca
```

Questo crea:
```
motore-ricerca/
├── Cargo.toml
├── src/
│   └── main.rs
└── .gitignore
```

`Cargo.toml` conterrà:
```toml
[package]
name = "motore-ricerca"
version = "0.1.0"
edition = "2021"

[dependencies]
```

E `src/main.rs`:
```rust
fn main() {
    println!("Hello, world!");
}
```

## Pseudocodice

```bash
// Creare un progetto binario (default)
$ cargo new nome_progetto

// Creare un progetto binario esplicitamente
$ cargo new --bin nome_progetto

// Creare una libreria
$ cargo new --lib nome_libreria

// Creare progetto senza repository git
$ cargo new --vcs none nome_progetto

// Creare progetto in directory esistente
$ cargo init

// Struttura progetto binario
$ cargo new mia-app
$ tree mia-app
mia-app/
├── Cargo.toml          # Manifesto del progetto
├── src/
│   └── main.rs        # Entry point dell'applicazione
└── .gitignore         # Ignora target/ e Cargo.lock

// Contenuto Cargo.toml
// [package]
// name = "mia-app"
// version = "0.1.0"
// edition = "2021"
// 
// [dependencies]

// Contenuto src/main.rs iniziale
// fn main() {
//     println!("Hello, world!");
// }

// Struttura progetto libreria
$ cargo new --lib mia-lib
$ tree mia-lib
mia-lib/
├── Cargo.toml
├── src/
│   └── lib.rs         # Codice libreria
└── .gitignore

// Contenuto src/lib.rs iniziale
// pub fn add(left: usize, right: usize) -> usize {
//     left + right
// }
// 
// #[cfg(test)]
// mod tests {
//     use super::*;
// 
//     #[test]
//     fn it_works() {
//         let result = add(2, 2);
//         assert_eq!(result, 4);
//     }
// }

// Modificare Cargo.toml per aggiungere metadati
[package]
name = "motore-ricerca"
version = "0.1.0"
edition = "2021"
authors = ["Il Tuo Nome <email@example.com>"]
description = "Un motore di ricerca semplice in Rust"
license = "MIT"
repository = "https://github.com/tuo-username/motore-ricerca"

// Primo programma modificato
// src/main.rs
fn main() {
    let nome = "Motore di Ricerca";
    let versione = env!("CARGO_PKG_VERSION");
    
    println!("Benvenuto in {} v{}", nome, versione);
    println!("Stato: Inizializzazione...");
    
    // Leggi argomenti da riga di comando
    let args: Vec<String> = std::env::args().collect();
    
    if args.len() > 1 {
        println!("Argomenti ricevuti: {:?}", &args[1..]);
    } else {
        println!("Nessun argomento. Uso: {} <query>", args[0]);
    }
}

// Compilazione ed esecuzione
$ cargo run
   Compiling motore-ricerca v0.1.0
    Finished dev [unoptimized + debuginfo] target(s) in 0.52s
     Running `target/debug/motore-ricerca`
Benvenuto in Motore di Ricerca v0.1.0
Stato: Inizializzazione...
Nessun argomento. Uso: motore-ricerca <query>

// Con argomenti
$ cargo run -- "rust tutorial"
Benvenuto in Motore di Ricerca v0.1.0
Argomenti ricevuti: ["rust tutorial"]

// Eseguibile di release
$ cargo build --release
$ ./target/release/motore-ricerca
```

## Risorse

- [Cargo Guide](https://doc.rust-lang.org/cargo/guide/creating-a-new-project.html)
- [First Project](https://doc.rust-lang.org/book/ch01-03-hello-cargo.html)
- [Package Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html)

## Esercizio

Crea il tuo primo progetto Rust completo:

1. Crea un nuovo progetto binario chiamato "primo-rust"
2. Modifica `main.rs` per:
   - Stampare un messaggio di benvenuto con il nome del progetto
   - Chiedere il nome dell'utente (usa println! per simulare)
   - Salutare l'utente personalizzato
3. Compila con `cargo build`
4. Esegui con `cargo run`
5. Crea anche una versione di release

**Traccia di soluzione:**
```bash
# Crea progetto
cargo new primo-rust
cd primo-rust

# Modifica src/main.rs:
fn main() {
    println!("Benvenuto in Primo Rust!");
    println!("Inserisci il tuo nome: [simulato]");
    
    let nome = "Studente";
    println!("Ciao, {}! Benvenuto nel mondo Rust.", nome);
    
    println!("Versione progetto: {}", env!("CARGO_PKG_VERSION"));
}

# Build e run
cargo build
cargo run

# Versione release
cargo build --release
./target/release/primo-rust  # Linux/Mac
# o .\target\release\primo-rust.exe  # Windows
```
