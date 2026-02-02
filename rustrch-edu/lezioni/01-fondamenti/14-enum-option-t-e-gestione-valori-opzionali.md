# Enum: Option<T> e Gestione Valori Opzionali

## Teoria

In molti linguaggi di programmazione, la gestione di valori che potrebbero essere assenti è fonte di numerosi bug. Il valore `null` o `None` è spesso la causa di errori a runtime come `NullPointerException` in Java o `TypeError` in Python. Rust affronta questo problema in modo elegante attraverso l'enum `Option<T>`, che forza il programmatore a gestire esplicitamente i casi in cui un valore potrebbe mancare.

`Option<T>` è un enum definito nella standard library che ha due varianti: `Some(T)` quando c'è un valore di tipo T, e `None` quando il valore è assente. A differenza di `null` in altri linguaggi, `Option<T>` è un tipo completamente diverso da `T`: non puoi accidentalmente usare un `Option<i32>` dove ti aspetti un `i32`. Il compilatore ti costringe a "deballare" (unwrap) il valore, gestendo esplicitamente il caso `None`.

Questo approccio rende impossibile dimenticarsi di gestire il caso in cui un valore è assente. Ogni operazione che potrebbe fallire o restituire un valore opzionale restituisce invece un `Option<T>`, e il type system di Rust garantisce che devi controllare il risultato prima di usarlo. Questo elimina una classe intera di bug che altrimenti emergerebbero solo a runtime.

## Esempio

Immagina una funzione che cerca un elemento in un database. In molti linguaggi, potrebbe restituire `null` se non trova nulla. In Rust, restituirebbe `Option<Elemento>`:

```rust
fn cerca_elemento(id: u64) -> Option<Elemento> {
    // ... logica di ricerca
    if trovato {
        Some(elemento)
    } else {
        None
    }
}
```

Il chiamante è ora obbligato a gestire entrambi i casi:

```rust
match cerca_elemento(123) {
    Some(elem) => println!("Trovato: {}", elem.nome),
    None => println!("Elemento non trovato"),
}
```

Questo pattern è onnipresente in Rust: operazioni su vettori (`get`), parsing di numeri (`parse`), ricerche in mappe (`get` su HashMap), tutte restituiscono `Option<T>`.

## Pseudocodice

```rust
// Definizione di Option (già presente in std::option::Option)
// enum Option<T> {
//     Some(T),  // Contiene un valore
//     None,     // Nessun valore
// }

// Creare Option
fn creazione_option() {
    let qualcosa: Option<i32> = Some(5);
    let niente: Option<i32> = None;
    
    // Da valore a Option
    let numero = 42;
    let opzionale = Some(numero);
    
    // Funzioni che restituiscono Option
    let vettore = vec![1, 2, 3];
    let primo = vettore.get(0);   // Some(&1)
    let quarto = vettore.get(10);  // None (indice fuori range)
}

// Estrarre valori da Option
fn estrazione_option() {
    let valore: Option<String> = Some(String::from("ciao"));
    
    // Metodo 1: match (il più sicuro e esplicito)
    match valore {
        Some(testo) => println!("Valore: {}", testo),
        None => println!("Nessun valore"),
    }
    
    // Metodo 2: if let (quando ci interessa solo il caso Some)
    if let Some(testo) = valore {
        println!("Trovato: {}", testo);
    }
    
    // Metodo 3: unwrap (panic se None - NON sicuro!)
    // let testo = valore.unwrap();  // Panic se valore è None
    
    // Metodo 4: unwrap_or (valore di default se None)
    let testo = valore.unwrap_or(String::from("default"));
    
    // Metodo 5: unwrap_or_else (calcola default solo se necessario)
    let testo = valore.unwrap_or_else(|| String::from("default"));
}

// Metodi utili su Option
fn metodi_option() {
    let x: Option<i32> = Some(5);
    let y: Option<i32> = None;
    
    // is_some() / is_none()
    if x.is_some() {
        println!("x ha un valore");
    }
    
    // map: trasforma il valore se presente
    let raddoppiato = x.map(|n| n * 2);  // Some(10)
    let raddoppiato_y = y.map(|n| n * 2);  // None
    
    // and_then: concatena operazioni che restituiscono Option
    fn divide_se_pari(n: i32) -> Option<i32> {
        if n % 2 == 0 {
            Some(n / 2)
        } else {
            None
        }
    }
    
    let risultato = x.and_then(divide_se_pari);  // Some(2) perché 5 non è pari... wait, ritorna None
    // Correzione: 5 non è pari, quindi divide_se_pari(5) restituisce None
    
    // filter: mantiene solo se il predicato è true
    let maggiore_di_3 = x.filter(|n| *n > 3);  // Some(5)
    let maggiore_di_10 = x.filter(|n| *n > 10);  // None
    
    // or / or_else: fornisce alternativa se None
    let alternativa = y.or(Some(10));  // Some(10)
    let alternativa2 = x.or(Some(10));  // Some(5), ignora l'alternativa
}

// Esempio pratico: parsing con gestione errori
fn parse_numero_safe(input: &str) -> Option<i32> {
    // parse restituisce Result, ok() lo converte in Option
    input.parse::<i32>().ok()
}

// Esempio: Ricerca in collezioni
fn trova_indice(vettore: &[i32], target: i32) -> Option<usize> {
    for (i, &valore) in vettore.iter().enumerate() {
        if valore == target {
            return Some(i);
        }
    }
    None
}

// Combinare più Option
fn combina_option() {
    let a: Option<i32> = Some(5);
    let b: Option<i32> = Some(3);
    let c: Option<i32> = None;
    
    // Somma solo se entrambi presenti
    let somma = match (a, b) {
        (Some(x), Some(y)) => Some(x + y),
        _ => None,
    };  // Some(8)
    
    // Con il ? operator (vedremo più avanti con Result)
    fn somma_opzionale(a: Option<i32>, b: Option<i32>) -> Option<i32> {
        Some(a? + b?)
    }
}

// Esempio: Configurazione opzionale
struct Config {
    nome_host: Option<String>,
    porta: Option<u16>,
    timeout: Option<u64>,
}

impl Config {
    fn new() -> Config {
        Config {
            nome_host: None,
            porta: Some(8080),  // Default
            timeout: Some(30),
        }
    }
    
    fn host(&self) -> &str {
        // unwrap_or restituisce il valore o il default
        self.nome_host.as_deref().unwrap_or("localhost")
    }
    
    fn porta(&self) -> u16 {
        self.porta.unwrap_or(8080)
    }
}
```

## Risorse

- [Option Enum - The Rust Book](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html#the-option-enum-and-its-advantages-over-null-values)
- [Option Documentation](https://doc.rust-lang.org/std/option/enum.Option.html)
- [Option and Null - Rust by Example](https://doc.rust-lang.org/rust-by-example/error/option_unwrap.html)

## Esercizio

Implementa una funzione `trova_elemento_massimo` che accetta una slice di i32 e restituisce `Option<&i32>`:
- Se la slice è vuota, restituisci `None`
- Altrimenti, restituisci `Some(&elemento_massimo)`

Poi scrivi una funzione `main` che usa questo risultato in modo sicuro.

**Traccia di soluzione:**
1. Se la slice è vuota, return None
2. Inizializza max con il primo elemento (riferimento)
3. Itera sugli elementi rimanenti, aggiornando max se necessario
4. Restituisci Some(max)
5. Nel main, usa match o if let per gestire il risultato
