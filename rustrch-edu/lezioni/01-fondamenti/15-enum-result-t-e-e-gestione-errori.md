# Enum: Result<T, E> e Gestione Errori

## Teoria

Mentre `Option<T>` gestisce il caso in cui un valore potrebbe essere assente, `Result<T, E>` gestisce le operazioni che potrebbero fallire con un errore specifico. Questo è il meccanismo principale per la gestione degli errori in Rust, distinguendo tra errori recuperabili (gestiti con `Result`) e errori irrecuperabili (gestiti con `panic!`).

`Result<T, E>` è un enum con due varianti: `Ok(T)` che indica successo con un valore di tipo T, e `Err(E)` che indica fallimento con un errore di tipo E. A differenza delle eccezioni in altri linguaggi, dove il flusso di controllo salta in modo implicito, `Result` rende esplicito il fatto che un'operazione potrebbe fallire. Il tipo system di Rust obbliga il programmatore a gestire entrambi i casi, eliminando la possibilità di dimenticarsi di controllare un errore.

Questo approccio è chiamato "error handling esplicito" o "error propagation" ed è uno dei pilastri della filosofia di Rust: la robustezza attraverso la correttezza. Ogni funzione che può fallire dichiara esplicitamente quali errori può produrre attraverso il tipo `Result`. Questo rende il codice più verboso di quello che usa eccezioni, ma anche molto più chiaro e manutenibile: basta guardare la firma della funzione per sapere cosa può andare storto.

## Esempio

Quando apriamo un file, l'operazione può fallire per molti motivi: il file non esiste, non abbiamo i permessi, il disco è pieno, ecc. In Rust, `File::open` restituisce `Result<File, std::io::Error>`:

```rust
use std::fs::File;

let risultato = File::open("config.txt");

match risultato {
    Ok(file) => println!("File aperto con successo"),
    Err(errore) => println!("Errore nell'apertura: {}", errore),
}
```

Il tipo `std::io::Error` contiene informazioni dettagliate sull'errore: codice, messaggio, tipo di errore. Questo è molto più informativo di ricevere semplicemente `null` o una eccezione generica. Inoltre, il compilatore si assicura che non usiamo il file se l'apertura è fallita.

## Pseudocodice

```rust
// Definizione di Result (già presente in std::result::Result)
// enum Result<T, E> {
//     Ok(T),   // Operazione riuscita con valore
//     Err(E),  // Operazione fallita con errore
// }

// Esempio: Apertura file
use std::fs::File;
use std::io::{self, Read};

fn leggi_file_percorso(percorso: &str) -> Result<String, io::Error> {
    // File::open restituisce Result<File, io::Error>
    let risultato = File::open(percorso);
    
    let mut file = match risultato {
        Ok(f) => f,
        Err(e) => return Err(e),  // Propaga l'errore al chiamante
    };
    
    let mut contenuto = String::new();
    
    // read_to_string restituisce Result<usize, io::Error>
    match file.read_to_string(&mut contenuto) {
        Ok(_) => Ok(contenuto),     // Successo, restituisci il contenuto
        Err(e) => Err(e),           // Errore, propaga
    }
}

// Semplificazione con l'operatore ?
fn leggi_file_ottimizzato(percorso: &str) -> Result<String, io::Error> {
    // L'operatore ? espande automaticamente in match
    // Se Ok: estrae il valore e continua
    // Se Err: ritorna immediatamente l'errore
    let mut file = File::open(percorso)?;
    let mut contenuto = String::new();
    file.read_to_string(&mut contenuto)?;
    Ok(contenuto)
}

// Metodi utili su Result
fn metodi_result() {
    let risultato: Result<i32, &str> = Ok(42);
    let errore: Result<i32, &str> = Err("qualcosa è andato storto");
    
    // is_ok() / is_err()
    if risultato.is_ok() {
        println!("Operazione riuscita");
    }
    
    // unwrap (usa con cautela!)
    let valore = risultato.unwrap();  // 42
    // let valore = errore.unwrap();  // PANIC!
    
    // unwrap_or (valore di default)
    let valore = errore.unwrap_or(0);  // 0
    
    // unwrap_or_else (calcola default)
    let valore = errore.unwrap_or_else(|e| {
        println!("Errore: {}", e);
        0
    });
    
    // expect (come unwrap con messaggio personalizzato)
    let valore = risultato.expect("Dovrebbe sempre essere Ok");
}

// Mappare i risultati
fn mappare_result() {
    let numero: Result<i32, &str> = Ok(5);
    
    // map: trasforma il valore Ok, lascia Err invariato
    let raddoppiato = numero.map(|n| n * 2);  // Ok(10)
    
    // map_err: trasforma l'errore Err, lascia Ok invariato
    let errore: Result<i32, &str> = Err("errore di parsing");
    let errore_mappato = errore.map_err(|e| format!("Errore: {}", e));
    
    // and_then: concatena operazioni che restituiscono Result
    fn divide(a: i32, b: i32) -> Result<i32, String> {
        if b == 0 {
            Err(String::from("Divisione per zero"))
        } else {
            Ok(a / b)
        }
    }
    
    let risultato = numero.and_then(|n| divide(100, n));  // Ok(20)
}

// Esempio: Parsing con gestione errori completa
fn parse_config(input: &str) -> Result<Config, ConfigError> {
    let parti: Vec<&str> = input.split(',').collect();
    
    if parti.len() != 3 {
        return Err(ConfigError::FormatoInvalido);
    }
    
    let nome = parti[0].to_string();
    
    let eta = parti[1].parse::<u32>()
        .map_err(|_| ConfigError::EtaInvalida)?;
    
    let attivo = parti[2].parse::<bool>()
        .map_err(|_| ConfigError::FlagInvalido)?;
    
    Ok(Config { nome, eta, attivo })
}

#[derive(Debug)]
enum ConfigError {
    FormatoInvalido,
    EtaInvalida,
    FlagInvalido,
}

struct Config {
    nome: String,
    eta: u32,
    attivo: bool,
}

// Esempio: Gestione errori multipli
fn operazione_complessa() -> Result<Dati, ErroreComposto> {
    let passo1 = operazione_1()
        .map_err(ErroreComposto::DaOperazione1)?;
    
    let passo2 = operazione_2(&passo1)
        .map_err(ErroreComposto::DaOperazione2)?;
    
    let passo3 = operazione_3(passo2)
        .map_err(ErroreComposto::DaOperazione3)?;
    
    Ok(passo3)
}

enum ErroreComposto {
    DaOperazione1(String),
    DaOperazione2(String),
    DaOperazione3(String),
}

fn operazione_1() -> Result<i32, String> { Ok(1) }
fn operazione_2(n: &i32) -> Result<i32, String> { Ok(*n) }
fn operazione_3(n: i32) -> Result<Dati, String> { Ok(Dati) }
struct Dati;

// Confronto Option vs Result
fn confronto() {
    // Option: "potrebbe esserci un valore o no"
    let opzionale: Option<i32> = Some(5);
    
    // Result: "operazione potrebbe aver fallito"
    let risultato: Result<i32, String> = Ok(5);
    
    // Conversioni
    let da_option_a_result = opzionale
        .ok_or("Valore mancante");  // Some(5) -> Ok(5), None -> Err("Valore mancante")
    
    let da_result_a_option = risultato.ok();  // Ok(5) -> Some(5), Err(_) -> None
}
```

## Risorse

- [Result Enum - The Rust Book](https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html)
- [Result Documentation](https://doc.rust-lang.org/std/result/enum.Result.html)
- [Error Handling - Rust by Example](https://doc.rust-lang.org/rust-by-example/error/result.html)

## Esercizio

Scrivi una funzione `divisione_sicura` che:
1. Accetta due f64: numeratore e denominatore
2. Restituisce `Result<f64, String>`
3. Se il denominatore è 0.0, restituisci `Err("Divisione per zero non consentita")`
4. Altrimenti, restituisci `Ok(numeratore / denominatore)`

Poi scrivi un `main` che usa questa funzione con diversi input e gestisce entrambi i casi.

**Traccia di soluzione:**
1. Confronta denominatore con 0.0 (considera anche piccoli valori con epsilon)
2. Se zero, restituisci Err con messaggio appropriato
3. Altrimenti calcola e restituisci Ok(risultato)
4. Nel main, usa match o if let per gestire il Result
5. Prova sia con denominatore valido che con zero
