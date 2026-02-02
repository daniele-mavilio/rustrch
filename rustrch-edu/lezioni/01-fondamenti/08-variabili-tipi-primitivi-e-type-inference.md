# Variabili, Tipi Primitivi e Type Inference

## Teoria

In Rust, ogni valore ha un tipo specifico che determina la quantità di memoria da allocare e le operazioni che si possono eseguire su quel valore. Il sistema di tipi di Rust è statico e forte, il che significa che i tipi vengono controllati a tempo di compilazione e non sono ammesse conversioni implicite tra tipi diversi. Questo approccio previene molti errori comuni prima ancora che il programma venga eseguito.

Rust distingue tra tipi primitivi scalari e composti. I tipi scalari rappresentano singoli valori e includono interi con segno e senza segno (`i8`, `i16`, `i32`, `i64`, `i128`, `isize` e le varianti `u*`), numeri in virgola mobile (`f32`, `f64`), booleani (`bool`) e caratteri Unicode (`char`). I tipi composti raggruppano multipli valori in una singola entità, come tuple e array, che esploreremo nelle prossime sezioni.

Una caratteristica potente di Rust è l'inferenza dei tipi (type inference). In molti casi, il compilatore è in grado di dedurre automaticamente il tipo di una variabile dal contesto in cui viene utilizzata, senza che il programmatore debba specificarlo esplicitamente. Questo non significa che Rust è debolmente tipizzato: i tipi esistono sempre e vengono verificati rigorosamente dal compilatore, ma la loro annotazione può essere omessa quando è ovvia dal contesto. Questo bilancia la sicurezza dei tipi con la leggibilità del codice.

## Esempio

Quando dichiariamo una variabile con `let x = 42`, Rust inferisce automaticamente che `x` è di tipo `i32` (intero a 32 bit con segno) perché questo è il tipo predefinito per i valori interi letterali. Allo stesso modo, `let y = 3.14` viene inferito come `f64` (virgola mobile a 64 bit), il tipo predefinito per i numeri decimali. Questo comportamento predefinito è stato scelto perché offre il miglior equilibrio tra precisione e prestazioni su architetture moderne.

Tuttavia, ci sono situazioni in cui il compilatore non può inferire il tipo univocamente e richiede una annotazione esplicita. Per esempio, quando convertiamo una stringa in un numero con `parse()`, il compilatore non sa se vogliamo un `i32`, un `i64` o un altro tipo numerico. In questi casi, dobbiamo specificare il tipo usando la turbofish syntax `::<Tipo>` oppure annotando la variabile con `: Tipo`. Questa esplicitazione garantisce che non ci siano ambiguità nel comportamento del programma.

## Pseudocodice

```rust
// Dichiarazione di variabili immutabili (default in Rust)
fn esempio_variabili() {
    // Il compilatore inferisce automaticamente il tipo
    let intero = 42;           // Inferito come i32
    let decimale = 3.14;       // Inferito come f64
    let booleano = true;       // Inferito come bool
    let carattere = 'A';       // Inferito come char (4 byte Unicode)
    
    // Type annotation esplicita quando necessaria
    let intero_esplicito: i64 = 42;
    let decimale_esplicito: f32 = 3.14;
}

// Tipi interi: con segno (i) e senza segno (u), varie dimensioni
fn tipi_interi() {
    // i8, i16, i32, i64, i128, isize
    // u8, u16, u32, u64, u128, usize
    
    let piccolo: i8 = -128;              // -128 a 127
    let grande: i64 = 9_000_000_000_000; // Underscore per leggibilità
    let dimensione_architettura: isize;   // Dipende dalla piattaforma (32/64 bit)
    
    // usize è usato per indici e lunghezze
    let lunghezza: usize = 100;
}

// Tipi in virgola mobile
fn tipi_float() {
    let singola_precisione: f32 = 3.14159;
    let doppia_precisione: f64 = 3.14159265358979;
    
    // Notazione scientifica
    let numero_grande = 1e6;      // 1,000,000.0 (f64)
    let numero_piccolo = 1e-6;    // 0.000001 (f64)
}

// Type inference nel parsing
fn type_inference_parse() {
    let input = "42";
    
    // Errore: il compilatore non sa che tipo parse deve restituire
    // let numero = input.parse();  // NON COMPILA
    
    // Soluzione 1: turbofish syntax
    let numero = input.parse::<i32>();
    
    // Soluzione 2: type annotation sulla variabile
    let numero: i64 = input.parse().expect("Numero non valido");
    
    // Soluzione 3: type annotation su let mut
    let mut numero = 0i32;
    numero = input.parse().unwrap();
}

// Shadowing: ri-dichiarare una variabile con lo stesso nome
fn shadowing_esempio() {
    let x = 5;           // x è i32 con valore 5
    let x = x + 1;       // Nuova variabile x con valore 6
    let x = x * 2;       // Nuova variabile x con valore 12
    let x = "testo";     // Nuova variabile x di tipo &str
    // Ogni let crea una NUOVA variabile che nasconde quella precedente
}

// Mutabilità esplicita
fn mutabilita() {
    let immutabile = 5;
    // immutabile = 6;  // ERRORE: non si può modificare
    
    let mut mutabile = 5;
    mutabile = 6;        // OK: dichiarata come mut
}

// Type aliases per leggibilità
fn type_alias() {
    // Definisci un alias per un tipo complesso
    type IDUtente = u64;
    type Coordinate = (f64, f64);
    
    let id: IDUtente = 123456789;
    let posizione: Coordinate = (45.4642, 9.1900);
}
```

## Risorse

- [Data Types - The Rust Book](https://doc.rust-lang.org/book/ch03-02-data-types.html)
- [Primitive Types - Rust Reference](https://doc.rust-lang.org/std/primitive/index.html)
- [Type Inference - Rust by Example](https://doc.rust-lang.org/rust-by-example/primitives.html)

## Esercizio

Scrivi una funzione che calcola l'area di un cerchio dato il raggio. La funzione deve:
1. Accettare il raggio come parametro (tipo f64)
2. Usare la costante PI (disponibile in std::f64::consts::PI)
3. Restituire l'area calcolata

Poi, scrivi un main che chiama questa funzione con raggio = 5.0 e stampa il risultato usando l'inferenza dei tipi (senza annotazioni esplicite dove possibile).

**Traccia di soluzione:**
```rust
fn area_cerchio(raggio: f64) -> f64 {
    std::f64::consts::PI * raggio * raggio
}

fn main() {
    let raggio = 5.0;  // Inferito come f64
    let area = area_cerchio(raggio);
    println!("L'area è: {}", area);
}
```
