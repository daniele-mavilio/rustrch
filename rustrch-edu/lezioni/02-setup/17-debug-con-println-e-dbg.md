# Debug con println! e dbg!

## Teoria

Il debug è una parte essenziale dello sviluppo software, e Rust fornisce strumenti semplici ma potenti per ispezionare il comportamento del programma durante l'esecuzione. Le macro `println!` e `dbg!` sono i due strumenti più usati per il debugging semplice, permettendo di visualizzare valori e flusso di esecuzione senza bisogno di un debugger esterno.

`println!` è la macro di stampa generica che formatta e visualizza output sullo standard output. Offre potenti capacità di formattazione attraverso stringhe di formato, permettendo di controllare precisione, allineamento, e rappresentazione dei valori. È ideale per output formattati e messaggi informativi.

`dbg!` è una macro specificamente progettata per il debugging. A differenza di `println!`, `dbg!` stampa automaticamente il nome della variabile insieme al suo valore, include informazioni sul file e la linea dove viene chiamata, e restituisce il valore stesso (permettendo di inserirla in mezzo a espressioni). È lo strumento "quick-and-dirty" preferito per ispezionare valori durante il debug.

## Esempio

Uso di `println!` per debug:

```rust
let x = 42;
println!("Il valore di x è: {}", x);
println!("Debug completo: {:?}", some_struct);
```

Uso di `dbg!`:

```rust
let x = dbg!(42);  // Stampa: [src/main.rs:2] x = 42

// Può essere usato in mezzo a espressioni
let y = dbg!(x + 1);  // Stampa: [src/main.rs:5] x + 1 = 43
```

## Pseudocodice

```rust
// PRINTLN! PER DEBUG

// Formattazione base
let x = 42;
println!("x = {}", x);
// Output: x = 42

// Formattazione debug
let punto = (10, 20);
println!("{:?}", punto);
// Output: (10, 20)

// Formattazione pretty debug
let vettore = vec![1, 2, 3];
println!("{:#?}", vettore);
// Output:
// [
//     1,
//     2,
//     3,
// ]

// Formattazione numeri
let numero = 3.14159;
println!("{:.2}", numero);     // 3.14 (2 decimali)
println!("{:>10}", numero);    // "    3.14159" (allinea a destra)
println!("{:<10}", numero);    // "3.14159    " (allinea a sinistra)
println!("{:^10}", numero);    // "  3.14159  " (centra)
println!("{:010}", 42);        // "0000000042" (padding con zeri)
println!("{:b}", 10);          // "1010" (binario)
println!("{:x}", 255);         // "ff" (esadecimale minuscolo)
println!("{:X}", 255);         // "FF" (esadecimale maiuscolo)

// Formattazione stringhe
let nome = "Mario";
println!("Ciao, {}!", nome);
println!("Lunghezza: {}", nome.len());

// Formattazione multiple variabili
let x = 1;
let y = 2;
println!("x = {}, y = {}, somma = {}", x, y, x + y);

// Formattazione con indici
println!("{0} + {1} = {1} + {0}", x, y);

// Formattazione con nomi
println!("{nome} ha {eta} anni", nome = "Mario", eta = 30);

// DB! PER DEBUG

// Uso base
let x = dbg!(42);
// Output: [src/main.rs:2] x = 42

// In espressioni
let y = dbg!(x * 2);
// Output: [src/main.rs:5] x * 2 = 84

// Con struct
#[derive(Debug)]
struct Punto {
    x: i32,
    y: i32,
}

let p = Punto { x: 10, y: 20 };
dbg!(&p);
// Output: [src/main.rs:15] &p = Punto {
//     x: 10,
//     y: 20,
// }

// Tracciare esecuzione
fn calcola(a: i32, b: i32) -> i32 {
    dbg!(a);
    dbg!(b);
    let somma = dbg!(a + b);
    dbg!(somma * 2)
}

// In condizioni
if dbg!(x > 0) {
    println!("x è positivo");
}

// Esempio pratico: Debug di funzione
fn elabora_dati(input: Vec<i32>) -> Vec<i32> {
    dbg!(&input);  // Vedi input originale
    
    let filtrati: Vec<_> = input
        .into_iter()
        .filter(|&x| {
            let passa = x > 0;
            dbg!(x, passa);  // Vedi ogni elemento e risultato
            passa
        })
        .collect();
    
    dbg!(&filtrati);  // Vedi risultato
    filtrati
}

// COMPARAZIONE PRINTLN! VS DBG!

// Scenario: debuggare variabile
let risultato = calcola_somma(10, 20);

// Con println!
println!("risultato = {}", risultato);
// Output: risultato = 30
// Problema: devi scrivere il nome manualmente

// Con dbg!
dbg!(risultato);
// Output: [src/main.rs:5] risultato = 30
// Vantaggi: nome automatico, file e linea, restituisce valore

// CON EPRESSO

// Se vuoi output colorato e più leggibile
// [dependencies]
// owo-colors = "3"

// use owo_colors::OwoColorize;
// println!("{}", "Errore!".red());
// println!("{}", "Successo!".green());

// TECNICHE AVANZATE

// Condizionale
const DEBUG: bool = true;

macro_rules! debug_print {
    ($($arg:tt)*) => {
        if DEBUG {
            println!($($arg)*);
        }
    };
}

// Uso
debug_print!("Debug: valore = {}", x);

// Logging strutturato (alternativa migliore)
// [dependencies]
// log = "0.4"
// env_logger = "0.10"

// use log::info;
// info!("Valore x = {}", x);

// RIMOZIONE DEBUG IN PRODUZIONE

// Usare cfg per debug condizionale
#[cfg(debug_assertions)]
fn debug_function() {
    println!("Questo viene compilato solo in debug mode");
}

#[cfg(not(debug_assertions))]
fn debug_function() {
    // Niente in release
}

// O con macro
macro_rules! debug_log {
    ($($arg:tt)*) => {
        #[cfg(debug_assertions)]
        {
            println!($($arg)*);
        }
    };
}

// BEST PRACTICES

// 1. Usa dbg! per debug rapido
let x = dbg!(valore);  // Rimuovi dopo il debug

// 2. Usa println! con {:?} per struct
println!("{:?}", my_struct);

// 3. Usa {:#?} per output leggibile
println!("{:#?}", complex_data);

// 4. Commenta o rimuovi i print di debug prima del commit
// (o usa un sistema di logging appropriato)

// 5. Per debug temporaneo, usa feature gate
#[cfg(feature = "debug")]
{
    println!("Debug info: {:?}", data);
}

// ESEMPIO COMPLETO

fn main() {
    let dati = vec![1, -2, 3, -4, 5];
    
    println!("Dati di input: {:?}", dati);
    
    let positivi: Vec<_> = dati
        .iter()
        .filter(|&&x| {
            let is_pos = x > 0;
            dbg!(x, is_pos);  // Traccia ogni decisione
            is_pos
        })
        .copied()
        .collect();
    
    dbg!(&positivi);
    
    let somma: i32 = positivi.iter().sum();
    println!("Somma dei positivi: {}", somma);
}

// Output:
// Dati di input: [1, -2, 3, -4, 5]
// [src/main.rs:10] x = 1
// [src/main.rs:10] is_pos = true
// [src/main.rs:10] x = -2
// [src/main.rs:10] is_pos = false
// [src/main.rs:10] x = 3
// [src/main.rs:10] is_pos = true
// ...
// [src/main.rs:16] &positivi = [
//     1,
//     3,
//     5,
// ]
// Somma dei positivi: 9
```

## Risorse

- [Macro println!](https://doc.rust-lang.org/std/macro.println.html)
- [Macro dbg!](https://doc.rust-lang.org/std/macro.dbg.html)
- [Format Strings](https://doc.rust-lang.org/std/fmt/index.html)

## Esercizio

Debugga il seguente codice usando `dbg!`:

```rust
fn main() {
    let numeri = vec![5, 2, 8, 1, 9, 3];
    let risultato = elabora(numeri);
    println!("Risultato finale: {}", risultato);
}

fn elabora(v: Vec<i32>) -> i32 {
    let filtrati = v.into_iter().filter(|&x| x > 3).collect::<Vec<_>>();
    let somma: i32 = filtrati.iter().sum();
    somma * 2
}
```

Aggiungi `dbg!` appropriati per tracciare:
1. Il vettore di input
2. I numeri filtrati
3. La somma
4. Il risultato finale

**Traccia di soluzione:**
```rust
fn main() {
    let numeri = vec![5, 2, 8, 1, 9, 3];
    dbg!(&numeri);  // 1. Input
    
    let risultato = elabora(numeri);
    println!("Risultato finale: {}", risultato);
}

fn elabora(v: Vec<i32>) -> i32 {
    let filtrati = v.into_iter()
        .filter(|&x| {
            let passa = x > 3;
            dbg!(x, passa);  // Debug ogni elemento
            passa
        })
        .collect::<Vec<_>>();
    
    dbg!(&filtrati);  // 2. Filtrati
    
    let somma: i32 = filtrati.iter().sum();
    dbg!(somma);  // 3. Somma
    
    let risultato = somma * 2;
    dbg!(risultato)  // 4. Risultato
}
```
