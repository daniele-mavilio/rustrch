# Cargo test: Test di Integrazione e Organizzazione

## Teoria

Mentre i test unitari verificano singole unità di codice in isolamento, i test di integrazione verificano che le diverse parti del sistema funzionino correttamente insieme. In Rust, i test di integrazione vanno nella directory `tests/` a livello di progetto, non nel codice sorgente. Ogni file in `tests/` viene compilato come crate separato che linka la libreria principale, permettendo di testare l'API pubblica come la vedrebbe un utente esterno.

Questa separazione architetturale è importante: i test di integrazione possono usare solo gli item pubblici (`pub`) esportati dalla libreria, proprio come farebbe un codice esterno. Questo garantisce che l'API pubblica sia testata in modo realistico. Se hai bisogno di testare implementazioni interne, usa test unitari nel modulo `#[cfg(test)]`.

L'organizzazione dei test è fondamentale per progetti di grandi dimensioni. Rust permette di organizzare i test in file separati, moduli, e sottodirectory. I test possono condividere codice comune attraverso moduli di supporto in `tests/common/` che non vengono eseguiti come test (richiedono esplicito `mod common`).

## Esempio

Struttura di un progetto con test di integrazione:

```
mio-progetto/
├── Cargo.toml
├── src/
│   └── lib.rs
└── tests/
    ├── test_integrazione.rs
    └── common/
        └── mod.rs
```

In `tests/test_integrazione.rs`:
```rust
// Test di integrazione - crate separato
use mio_progetto::funzione_pubblica;

mod common;  // Carica codice comune

#[test]
fn test_flusso_completo() {
    common::setup();
    
    let risultato = funzione_pubblica();
    assert_eq!(risultato, 42);
    
    common::teardown();
}
```

## Pseudocodice

```bash
// STRUTTURA TEST DI INTEGRAZIONE

// File system:
my-project/
├── Cargo.toml
├── src/
│   └── lib.rs
└── tests/
    ├── integration_test.rs
    └── common/
        └── mod.rs

// src/lib.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub struct Database {
    connection: String,
}

impl Database {
    pub fn connect(url: &str) -> Result<Self, String> {
        Ok(Database {
            connection: url.to_string(),
        })
    }
    
    pub fn query(&self, sql: &str) -> Vec<String> {
        vec![format!("Risultato di: {}", sql)]
    }
}

// tests/integration_test.rs
use my_project::{add, Database};

// Test di integrazione semplice
#[test]
fn test_add_integration() {
    assert_eq!(add(2, 2), 4);
    assert_eq!(add(-1, 1), 0);
}

// Test che usano API pubblica
#[test]
fn test_database_connection() {
    let db = Database::connect("test://localhost")
        .expect("Connessione fallita");
    
    let risultati = db.query("SELECT * FROM users");
    assert!(!risultati.is_empty());
}

// tests/common/mod.rs
// Codice condiviso tra test (NON è un test!)

pub fn setup() {
    println!("Setup ambiente di test");
    // Inizializza risorse
}

pub fn teardown() {
    println!("Cleanup ambiente di test");
    // Pulisci risorse
}

pub fn crea_database_test() -> Database {
    Database::connect("test://localhost")
        .expect("Database di test non disponibile")
}

// Usare codice comune
// tests/another_test.rs
use my_project::Database;

mod common;  // Importa il modulo common

#[test]
fn test_with_common() {
    common::setup();
    
    let db = common::crea_database_test();
    let results = db.query("SELECT 1");
    assert_eq!(results.len(), 1);
    
    common::teardown();
}

// ORGANIZZAZIONE AVANZATA

// tests/api/
// └── user_api.rs
// tests/db/
// └── connection.rs
// tests/e2e/
// └── workflow.rs

// Esegui test specifici
$ cargo test --test integration_test
$ cargo test --test user_api

// Esegui tutti i test di integrazione
$ cargo test --test '*'

// ESCLUDERE FILE DA TEST

// tests/helpers.rs
// Questo file verrebbe eseguito come test!

// Soluzione: metti in subdirectory
// tests/helpers/mod.rs
// E importa dove necessario: mod helpers;

// COMANDI UTILI

// Esegui tutti i test (unitari + integrazione)
$ cargo test

// Solo test di integrazione
$ cargo test --test '*'

// Specifico file di test
$ cargo test --test integration_test

// Specifico test in file specifico
$ cargo test --test integration_test test_nome

// Mostra output
$ cargo test -- --nocapture

// Parallelismo
$ cargo test -- --test-threads=4

// DOCUMENTAZIONE COME TEST

// src/lib.rs
/// Add two numbers
///
/// # Examples
///
/// ```
/// use my_project::add;
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

// Esegui doc tests
$ cargo test --doc

// Esempi fallibili
/// # Examples
///
/// ```should_panic
/// // Questo esempio deve panicare
/// panic!("oh no!");
/// ```

/// ```ignore
/// // Questo esempio non viene compilato
/// codice_non_valido()
/// ```

/// ```no_run
/// // Questo esempio viene compilato ma non eseguito
/// std::process::Command::new("rm").arg("-rf").output();
/// ```

// FIXTURE E SETUP COMPLESSO

// tests/fixture.rs
use std::sync::Once;

static INIT: Once = Once::new();

fn setup_once() {
    INIT.call_once(|| {
        // Setup eseguito solo una volta
        env_logger::init();
    });
}

#[test]
fn test_with_global_setup() {
    setup_once();
    // ...
}

// TEMP DIR PER TEST

// [dev-dependencies]
// tempdir = "0.3"

// use tempdir::TempDir;
// use std::fs::File;
// use std::io::Write;

// #[test]
// fn test_with_temp_dir() {
//     let tmp_dir = TempDir::new("test").unwrap();
//     let file_path = tmp_dir.path().join("test.txt");
//     
//     let mut file = File::create(&file_path).unwrap();
//     writeln!(file, "test content").unwrap();
//     
//     // Test con file...
//     
//     // tmp_dir viene automaticamente eliminato alla fine
// }

// MOCK E STUB

// [dev-dependencies]
// mockall = "0.12"

// #[cfg(test)]
// use mockall::automock;

// #[automock]
// pub trait Database {
//     fn query(&self, sql: &str) -> Vec<String>;
// }

// #[test]
// fn test_with_mock() {
//     let mut mock = MockDatabase::new();
//     mock.expect_query()
//         .with(mockall::predicate::eq("SELECT 1"))
//         .times(1)
//         .returning(|_| vec!["1".to_string()]);
//     
//     let result = mock.query("SELECT 1");
//     assert_eq!(result, vec!["1"]);
// }

// CONFRONTO: UNIT VS INTEGRATION

// Test Unitaro (in src/)
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_privata() {
        // Può testare funzioni private!
        assert_eq!(funzione_privata(), 42);
    }
}

// Test di Integrazione (in tests/)
// use my_project::*;

// #[test]
// fn test_pubblica() {
//     // Può testare SOLO API pubbliche
//     assert_eq!(funzione_pubblica(), 42);
// }

// BEST PRACTICES

// 1. Nomenclatura chiara
#[test]
fn test_add_with_positive_numbers() {}
#[test]
fn test_add_with_negative_numbers() {}
#[test]
fn test_add_returns_zero_for_opposites() {}

// 2. Un concetto per test
#[test]
fn test_divide() {
    // NO: testa troppe cose
    assert_eq!(divide(10, 2), 5);
    assert_eq!(divide(9, 3), 3);
    assert!(divide(5, 0).is_err());
}

// SI: separa in test specifici
#[test]
fn test_divide_by_positive() {
    assert_eq!(divide(10, 2), 5);
}

#[test]
#[should_panic]
fn test_divide_by_zero_panics() {
    divide(5, 0);
}

// 3. Arrange-Act-Assert
#[test]
fn test_example() {
    // Arrange (setup)
    let input = vec![3, 1, 2];
    
    // Act (azione)
    let result = sort(input);
    
    // Assert (verifica)
    assert_eq!(result, vec![1, 2, 3]);
}
```

## Risorse

- [Integration Tests](https://doc.rust-lang.org/book/ch11-03-test-organization.html#integration-tests)
- [Test Organization](https://doc.rust-lang.org/book/ch11-03-test-organization.html)
- [Writing Tests](https://doc.rust-lang.org/book/ch11-01-writing-tests.html)

## Esercizio

Crea test di integrazione per una semplice API:

1. Crea un progetto "api-server" con una libreria
2. In `src/lib.rs`, implementa:
   - `pub struct User { name: String, age: u32 }`
   - `pub fn create_user(name: &str, age: u32) -> User`
   - `pub fn is_adult(user: &User) -> bool`
3. Crea `tests/user_tests.rs` con test di integrazione
4. Testa creazione utente e verifica età
5. Crea `tests/common/mod.rs` con helper condivisi

**Traccia di soluzione:**
```rust
// src/lib.rs
pub struct User {
    pub name: String,
    pub age: u32,
}

impl User {
    pub fn new(name: &str, age: u32) -> Self {
        User {
            name: name.to_string(),
            age,
        }
    }
}

pub fn is_adult(user: &User) -> bool {
    user.age >= 18
}

// tests/user_tests.rs
use api_server::{User, is_adult};

mod common;

#[test]
fn test_create_user() {
    let user = User::new("Mario", 25);
    assert_eq!(user.name, "Mario");
    assert_eq!(user.age, 25);
}

#[test]
fn test_is_adult_true() {
    let user = User::new("Adulto", 25);
    assert!(is_adult(&user));
}

#[test]
fn test_is_adult_false() {
    let user = User::new("Minorenne", 16);
    assert!(!is_adult(&user));
}

#[test]
fn test_boundary_age() {
    let user = User::new("AppenaMaggiorenne", 18);
    assert!(is_adult(&user));
}

// tests/common/mod.rs
pub fn setup() {
    // Setup comune se necessario
    println!("Setup test");
}
```
