# Cargo test: Scrivere e Eseguire Test Unitari

## Teoria

Il testing è una parte fondamentale dello sviluppo software in Rust. Cargo include un framework di testing integrato che permette di scrivere, organizzare ed eseguire test in modo semplice ed efficiente. I test in Rust sono funzioni speciali annotate con `#[test]` che verificano il comportamento del codice attraverso asserzioni.

I test unitari verificano singole unità di codice (funzioni, metodi, moduli) in isolamento. Vanno scritti nello stesso file del codice che testano, tipicamente in un modulo annidato `#[cfg(test)]` per essere compilati solo durante i test. Questo mantiene i test vicini al codice che verificano e permette di testare funzioni private.

Le macro di asserzione principali sono: `assert!` (verifica che un'espressione sia true), `assert_eq!` (verifica uguaglianza), `assert_ne!` (verifica disuguaglianza), e `assert_matches!` (verifica che un valore matchi un pattern). Quando un'asserzione fallisce, il test fallisce e Cargo mostra dettagli sull'errore. I test possono anche essere organizzati in moduli e filtrati per nome.

## Esempio

Test unitario di una funzione di parsing:

```rust
// src/parser.rs
pub fn parse_number(input: &str) -> Result<i32, ParseError> {
    input.parse().map_err(|_| ParseError::InvalidNumber)
}

#[derive(Debug, PartialEq)]
pub enum ParseError {
    InvalidNumber,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_valid_number() {
        assert_eq!(parse_number("42"), Ok(42));
        assert_eq!(parse_number("-10"), Ok(-10));
    }

    #[test]
    fn test_parse_invalid_number() {
        assert_eq!(parse_number("abc"), Err(ParseError::InvalidNumber));
        assert_eq!(parse_number(""), Err(ParseError::InvalidNumber));
    }
}
```

## Pseudocodice

```rust
// ANATOMIA DI UN TEST

#[test]
fn nome_test() {
    // Setup
    let input = prepara_dati();
    
    // Esecuzione
    let risultato = funzione_da_testare(input);
    
    // Verifica
    assert_eq!(risultato, valore_atteso);
}

// MACRO DI ASSERZIONE

// assert! - verifica che sia true
assert!(risultato.is_ok());
assert!(valore > 0, "Il valore deve essere positivo, era: {}", valore);

// assert_eq! - verifica uguaglianza
assert_eq!(somma(2, 2), 4);
assert_eq!(vettore, vec![1, 2, 3]);

// assert_ne! - verifica disuguaglianza
assert_ne!(risultato, 0);

// assert_matches! - verifica pattern (unstable, usa match)
match risultato {
    Ok(_) => (),
    Err(_) => panic!("Doveva essere Ok"),
}

// panic! - fallimento esplicito
if risultato < 0 {
    panic!("Risultato negativo non atteso: {}", risultato);
}

// ORGANIZZAZIONE TEST

// In src/lib.rs o src/modulo.rs
pub fn funzione_pubblica() -> i32 { 42 }

fn funzione_privata() -> i32 { 42 }

#[cfg(test)]  // Compila solo durante i test
mod tests {
    use super::*;  // Importa tutto dal modulo genitore
    
    #[test]
    fn test_pubblica() {
        assert_eq!(funzione_pubblica(), 42);
    }
    
    #[test]
    fn test_privata() {
        // Possiamo testare funzioni private!
        assert_eq!(funzione_privata(), 42);
    }
    
    // Test con should_panic
    #[test]
    #[should_panic]
    fn test_panic() {
        panic!("Questo panic è atteso");
    }
    
    // Test con should_panic e messaggio atteso
    #[test]
    #[should_panic(expected = "divisione per zero")]
    fn test_divisione_zero() {
        dividi(10, 0);
    }
    
    // Test ignorato
    #[test]
    #[ignore]
    fn test_lento() {
        // Questo test viene saltato di default
    }
    
    // Test ignorato con motivo
    #[test]
    #[ignore = "non implementato ancora"]
    fn test_non_pronto() {
        // ...
    }
}

// COMANDI CARGO TEST

// Esegui tutti i test
$ cargo test

// Esegui test specifico
$ cargo test nome_test

// Esegui test che matchano pattern
$ cargo test parse
// Esegue test_parse_valid, test_parse_invalid, etc.

// Esegui test ignorati
$ cargo test -- --ignored

// Esegui tutti i test inclusi ignorati
$ cargo test -- --include-ignored

// Mostra output anche per test passati
$ cargo test -- --nocapture

// Esegui test in un thread solo (sequenziale)
$ cargo test -- --test-threads=1

// Ferma al primo fallimento
$ cargo test -- --fail-fast

// Lista tutti i test senza eseguirli
$ cargo test -- --list

// Verbose
$ cargo test -- --nocapture

// Test in release mode
$ cargo test --release

// Test con features specifiche
$ cargo test --features "feature1"

// FIXTURE E SETUP

#[cfg(test)]
mod tests {
    use super::*;
    
    // Setup comune
    fn setup() -> Configurazione {
        Configurazione::nuovo()
    }
    
    // Cleanup (usare Drop o funzione esplicita)
    fn teardown(config: Configurazione) {
        config.pulisci();
    }
    
    #[test]
    fn test_con_setup() {
        let config = setup();
        // ... test ...
        teardown(config);
    }
    
    // Usare result nei test
    #[test]
    fn test_con_result() -> Result<(), String> {
        let valore = operazione()?;
        assert_eq!(valore, 42);
        Ok(())
    }
}

// TEST CON RISULTATI FLOAT

#[test]
fn test_float() {
    let risultato = calcola(0.1, 0.2);
    // Non usare assert_eq! per float!
    // assert_eq!(risultato, 0.3);  // PUO' FALLIRE!
    
    // Usa approssimazione
    assert!((risultato - 0.3).abs() < 1e-10);
    
    // O con approx crate
    // assert_approx_eq!(risultato, 0.3, 1e-10);
}

// TEST CON COLLEZIONI

#[test]
fn test_vettore() {
    let risultato = elabora_dati();
    
    // Verifica lunghezza
    assert_eq!(risultato.len(), 3);
    
    // Verifica contenuto
    assert!(risultato.contains(&42));
    
    // Verifica ordinamento
    assert!(risultato.windows(2).all(|w| w[0] <= w[1]));
}

// TEST DOCUMENTAZIONE (Doc Tests)

/// Somma due numeri
///
/// # Examples
///
/// ```
/// use mio_crate::somma;
/// 
/// let risultato = somma(2, 2);
/// assert_eq!(risultato, 4);
/// ```
pub fn somma(a: i32, b: i32) -> i32 {
    a + b
}

// Gli esempi nella documentazione vengono eseguiti come test!
$ cargo test --doc

// ESEMPI PRATICI

// Test di una funzione matematica
#[test]
fn test_fattoriale() {
    assert_eq!(fattoriale(0), 1);
    assert_eq!(fattoriale(1), 1);
    assert_eq!(fattoriale(5), 120);
    assert_eq!(fattoriale(10), 3_628_800);
}

// Test con Option
#[test]
fn test_trova_elemento() {
    let v = vec![1, 2, 3];
    assert_eq!(trova(&v, 2), Some(1));  // indice 1
    assert_eq!(trova(&v, 4), None);
}

// Test con Result
#[test]
fn test_parsing() {
    assert!(parse_numero("42").is_ok());
    assert!(parse_numero("abc").is_err());
    
    // Verifica valore specifico
    assert_eq!(parse_numero("42").unwrap(), 42);
}

// Test di struct
#[test]
fn test_struct() {
    let utente = Utente::nuovo("Mario");
    assert_eq!(utente.nome(), "Mario");
    assert!(utente.attivo());
}
```

## Risorse

- [Testing](https://doc.rust-lang.org/book/ch11-01-writing-tests.html)
- [Test Organization](https://doc.rust-lang.org/book/ch11-03-test-organization.html)
- [Assertions](https://doc.rust-lang.org/std/macro.assert.html)

## Esercizio

Scrivi test per una funzione di ricerca:

1. Crea un progetto "ricerca-test"
2. Implementa `fn cerca(haystack: &str, needle: &str) -> Option<usize>`
3. Scrivi test per:
   - Trovare una sottostringa all'inizio
   - Trovare una sottostringa in mezzo
   - Trovare una sottostringa alla fine
   - Non trovare la sottostringa (None)
   - Stringa vuota come needle
   - Stringa vuota come haystack

**Traccia di soluzione:**
```rust
// src/lib.rs

pub fn cerca(haystack: &str, needle: &str) -> Option<usize> {
    haystack.find(needle)
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_inizio() {
        assert_eq!(cerca("hello world", "hello"), Some(0));
    }
    
    #[test]
    fn test_mezzo() {
        assert_eq!(cerca("hello world", "world"), Some(6));
    }
    
    #[test]
    fn test_fine() {
        assert_eq!(cerca("hello", "o"), Some(4));
    }
    
    #[test]
    fn test_non_trovato() {
        assert_eq!(cerca("hello", "xyz"), None);
    }
    
    #[test]
    fn test_needle_vuoto() {
        assert_eq!(cerca("hello", ""), Some(0));
    }
    
    #[test]
    fn test_haystack_vuoto() {
        assert_eq!(cerca("", "hello"), None);
    }
}

// Esegui con: cargo test
```
