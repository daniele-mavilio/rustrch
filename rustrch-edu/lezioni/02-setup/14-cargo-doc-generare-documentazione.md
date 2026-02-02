# Cargo doc: Generare Documentazione

## Teoria

La documentazione è fondamentale per qualsiasi progetto software, e Rust la considera una priorità. Cargo include un sistema integrato per generare documentazione HTML direttamente dal codice sorgente, combinando commenti di documentazione con l'analisi del codice. Questo approccio "docs-as-code" garantisce che la documentazione sia sempre sincronizzata con l'implementazione.

I commenti di documentazione in Rust iniziano con `///` (per item) o `//!` (per documentare il modulo/crate stesso). Usano Markdown per la formattazione e supportano blocchi di codice che vengono automaticamente compilati ed eseguiti come test (doc tests). Questo garantisce che gli esempi nella documentazione siano sempre corretti e funzionanti.

Il comando `cargo doc` genera documentazione HTML browsabile, localmente o per pubblicazione su docs.rs (il repository ufficiale di documentazione Rust). La documentazione include: moduli pubblici, funzioni, struct, trait, esempi di codice, e cross-references automatiche. La qualità della documentazione è considerata parte integrante della qualità del codice in Rust.

## Esempio

Documentazione di una funzione:

```rust
/// Calcola l'n-esimo numero di Fibonacci
///
/// # Arguments
///
/// * `n` - La posizione nella sequenza (0-based)
///
/// # Returns
///
/// Il numero di Fibonacci alla posizione n
///
/// # Examples
///
/// ```
/// let fifth = fibonacci(5);
/// assert_eq!(fifth, 5);
/// ```
///
/// # Panics
///
/// Panics se n è maggiore di 50 (overflow prevention)
pub fn fibonacci(n: u32) -> u32 {
    // ...
}
```

## Pseudocodice

```rust
// COMMENTI DI DOCUMENTAZIONE

/// Documentazione di una funzione (triple slash)
pub fn funzione_documentata() {}

/*!
Documentazione del modulo/crate (bang dopo apertura)

Questa documentazione appare nella pagina principale
del modulo o della crate.
!*/

mod sottomodulo {
    //! Documentazione del modulo sottomodulo
    
    /// Documentazione di una funzione nel modulo
    pub fn funzione() {}
}

// MARKDOWN NELLA DOCUMENTAZIONE

/// # Titolo principale
/// 
/// Testo normale con **grassetto** e *corsivo*.
/// 
/// ## Lista
/// - Item 1
/// - Item 2
/// - Item 3
/// 
/// ## Link
/// Vedi anche [`altra_funzione`]
/// 
/// ## Codice
/// ```rust
/// let risultato = funzione_documentata();
/// ```
pub fn esempio_markdown() {}

// SEZIONI SPECIALI

/// Calcola l'area di un cerchio
///
/// # Arguments
///
/// * `raggio` - Il raggio del cerchio in metri
///
/// # Returns
///
/// L'area del cerchio in metri quadrati
///
/// # Examples
///
/// ```
/// let area = area_cerchio(5.0);
/// assert!((area - 78.54).abs() < 0.01);
/// ```
///
/// # Errors
///
/// Restituisce un errore se il raggio è negativo
///
/// # Safety
///
/// Questa funzione è unsafe perché... (per codice unsafe)
///
/// # Panics
///
/// Panics se il raggio è NaN
///
/// # See Also
///
/// - [`circonferenza`]
/// - [`diametro`]
///
/// # Notes
///
/// Usa la costante `std::f64::consts::PI`
pub fn area_cerchio(raggio: f64) -> f64 {
    std::f64::consts::PI * raggio * raggio
}

// COMANDI CARGO DOC

// Genera documentazione
$ cargo doc

// Genera e apre nel browser
$ cargo doc --open

// Genera anche per dipendenze private
$ cargo doc --document-private-items

// Genera senza dipendenze (più veloce)
$ cargo doc --no-deps

// Genera per tutti i target
$ cargo doc --all

// Pubblica su docs.rs (automatico per crate pubblicate)
// https://docs.rs/nome-crate

// ESEMPI DI DOCUMENTAZIONE COMPLETA

//! # Motore di Ricerca
//! 
//! Una libreria per costruire motori di ricerca in Rust.
//! 
//! ## Features
//! 
//! - Web crawling
//! - Indicizzazione full-text
//! - Ranking con BM25
//! 
//! ## Esempio rapido
//! 
//! ```no_run
//! use motore_ricerca::{Crawler, Indexer};
//! 
//! let crawler = Crawler::new();
//! let indexer = Indexer::new();
//! ```

/// Configurazione del motore di ricerca
/// 
/// # Examples
/// 
/// ```
/// use motore_ricerca::Config;
/// 
/// let config = Config::new()
///     .with_max_depth(3)
///     .with_threads(4);
/// ```
pub struct Config {
    max_depth: u32,
    threads: usize,
}

impl Config {
    /// Crea una nuova configurazione con valori di default
    /// 
    /// # Default Values
    /// 
    /// - `max_depth`: 2
    /// - `threads`: numero di CPU
    pub fn new() -> Self {
        Config {
            max_depth: 2,
            threads: num_cpus::get(),
        }
    }
    
    /// Imposta la profondità massima di crawling
    /// 
    /// # Arguments
    /// 
    /// * `depth` - Profondità massima (0 = solo pagina iniziale)
    /// 
    /// # Examples
    /// 
    /// ```
    /// # use motore_ricerca::Config;
    /// let config = Config::new().with_max_depth(5);
    /// ```
    pub fn with_max_depth(mut self, depth: u32) -> Self {
        self.max_depth = depth;
        self
    }
}

// DOCTESTS (TEST NELLA DOCUMENTAZIONE)

/// Somma due numeri
///
/// # Examples
///
/// ```
/// assert_eq!(somma(2, 2), 4);
/// ```
pub fn somma(a: i32, b: i32) -> i32 {
    a + b
}

/// Funzione che potrebbe fallire
///
/// # Examples
///
/// ```
/// assert!(potenzialmente_fallisce(true).is_ok());
/// ```
///
/// ```
/// # use std::error::Error;
/// # fn main() -> Result<(), Box<dyn Error>> {
/// let result = potenzialmente_fallisce(false)?;
/// # Ok(())
/// # }
/// ```
pub fn potenzialmente_fallisce(successo: bool) -> Result<i32, String> {
    if successo {
        Ok(42)
    } else {
        Err(String::from("Fallimento"))
    }
}

/// Questo esempio non viene compilato
///
/// ```ignore
/// codice_non_valido();
/// ```

/// Questo esempio viene compilato ma non eseguito
///
/// ```no_run
/// loop { }
/// ```

/// Questo esempio deve causare panic
///
/// ```should_panic
/// panic!("Questo è atteso");
/// ```

/// Questo esempio deve causare panic con messaggio specifico
///
/// ```should_panic(expected = "divisione per zero")]
/// let _ = 1 / 0;
/// ```

// HIDE LINES IN DOC EXAMPLES

/// Esempio con setup nascosto
///
/// ```rust
/// # fn setup() -> Database { Database::new() }
/// let db = setup();
/// let result = db.query("SELECT 1");
/// ```

// ATTRIBUTI DOCUMENTAZIONE

/// Documentazione con feature gate
#[cfg(feature = "async")]
pub mod async_impl {
    //! Implementazione asincrona
}

/// Nascondi dalla documentazione pubblica
#[doc(hidden)]
pub fn funzione_interna() {}

/// Documentazione inline
#[doc = "Questo è un breve documento"]
pub const COSTANTE: i32 = 42;

// CONFIGURAZIONE CARGO.TOML

[package]
name = "mia-crate"
version = "0.1.0"
description = "Breve descrizione per docs.rs"
repository = "https://github.com/user/repo"
license = "MIT"
readme = "README.md"
keywords = ["search", "web"]
categories = ["web-programming"]

[package.metadata.docs.rs]
# Configurazione per docs.rs
features = ["full"]  # Documenta con tutte le features
all-features = false
no-default-features = false
targets = []  # Documenta per tutti i target

// BADGE E LINK

//! [docs-badge]: https://docs.rs/mia-crate/badge.svg
//! [docs-url]: https://docs.rs/mia-crate
//! 
//! [![Documentation][docs-badge]][docs-url]

// COLLEGAMENTI INTRA-DOC

/// Vedi [`Config`] per configurazione
/// 
/// [`Config`]: struct.Config.html
/// 
/// O usa path automatici:
/// - [`crate::Config`]
/// - [`super::ParentModule`]
/// - [`Self::metodo`]
/// - [`crate::modulo::funzione`]

// PUBBLICAZIONE DOCUMENTAZIONE

// Documentazione locale
$ cargo doc
$ open target/doc/mia_crate/index.html

// Pubblicazione su crates.io (automaticamente su docs.rs)
$ cargo publish

// Verifica documentazione prima di pubblicare
$ cargo doc --no-deps
$ cargo test --doc
```

## Risorse

- [Documentation](https://doc.rust-lang.org/rustdoc/how-to-write-documentation.html)
- [Rustdoc Book](https://doc.rust-lang.org/rustdoc/index.html)
- [Docs.rs](https://docs.rs/)

## Esercizio

Documenta una semplice libreria:

1. Crea un progetto "math-lib" come libreria
2. Implementa:
   - `pub fn factorial(n: u64) -> u64`
   - `pub fn gcd(a: u64, b: u64) -> u64`
3. Aggiungi documentazione completa per entrambe con:
   - Descrizione
   - Arguments
   - Returns
   - Examples (con doctests)
4. Genera la documentazione con `cargo doc --open`

**Traccia di soluzione:**
```rust
// src/lib.rs

//! # Math Lib
//! 
//! Libreria di funzioni matematiche utili.

/// Calcola il fattoriale di un numero
///
/// # Arguments
///
/// * `n` - Numero intero non negativo
///
/// # Returns
///
/// Il fattoriale di n (n!)
///
/// # Examples
///
/// ```
/// use math_lib::factorial;
/// 
/// assert_eq!(factorial(0), 1);
/// assert_eq!(factorial(5), 120);
/// ```
///
/// # Panics
///
/// Panics se n > 20 (per prevenire overflow)
pub fn factorial(n: u64) -> u64 {
    assert!(n <= 20, "n troppo grande, causerebbe overflow");
    
    (1..=n).product()
}

/// Calcola il Massimo Comun Divisore (MCD)
///
/// # Arguments
///
/// * `a` - Primo numero
/// * `b` - Secondo numero
///
/// # Returns
///
/// Il MCD di a e b
///
/// # Examples
///
/// ```
/// use math_lib::gcd;
/// 
/// assert_eq!(gcd(48, 18), 6);
/// assert_eq!(gcd(100, 35), 5);
/// ```
pub fn gcd(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let temp = b;
        b = a % b;
        a = temp;
    }
    a
}
```
