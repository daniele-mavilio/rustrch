# Tuple, Array e Slice

## Teoria

Rust fornisce diversi tipi composti per raggruppare multipli valori in una singola entità. I tre più fondamentali sono le tuple, gli array e le slice, ciascuno con caratteristiche specifiche che li rendono adatti a scopi diversi. Comprendere quando usare ciascuno di questi tipi è essenziale per scrivere codice idiomatico ed efficiente.

Le **tuple** sono collezioni di valori eterogenei (tipi diversi) di lunghezza fissa, definite a tempo di compilazione. Una tupla può contenere elementi di qualsiasi tipo e la loro lunghezza è parte del tipo stesso. Ad esempio, `(i32, f64, &str)` è un tipo diverso da `(i32, i32)`. Le tuple sono utili quando vuoi raggruppare valori correlati senza creare una struct dedicata, come quando una funzione deve restituire multipli valori.

Gli **array** sono collezioni di valori omogenei (tutti dello stesso tipo) di lunghezza fissa, nota a tempo di compilazione. Sono allocati sullo stack (se dichiarati come variabili locali) e la loro dimensione fa parte del tipo: `[i32; 5]` è diverso da `[i32; 3]`. Gli array sono ideali quando sai esattamente quanti elementi ti servono e questa quantità non cambia mai, come nel caso di coordinate 3D o colori RGB.

Le **slice** (`&[T]`) sono viste dinamiche su una sequenza contigua di elementi. A differenza degli array, le slice non possiedono i dati ma fanno riferimento a una porzione di un array o di un altro vettore. La loro lunghezza è determinata a runtime, non a compile time, rendendole flessibili per operazioni su sottoinsiemi di dati. Sono il tipo preferito per passare sequenze a funzioni perché funzionano sia con array che con vettori.

## Esempio

Immagina di gestire coordinate geografiche: latitude e longitude. Una tupla `(f64, f64)` è perfetta per questo caso, permettendo di raggruppare i due valori senza dover definire una struct completa. Se poi hai una lista fissa di coordinate per le capitali europee, potresti usare un array `[(f64, f64); 10]`. Quando passi queste coordinate a una funzione di calcolo della distanza, userai una slice `&[(f64, f64)]` che funziona indipendentemente dalla dimensione esatta.

Nella pratica quotidiana, quando una funzione deve restituire più valori, le tuple sono la scelta immediata. La destructuring syntax di Rust rende molto pulito lavorare con tuple: `let (lat, lon) = coordinate;`. Per le slice, il loro uso principale è nei parametri di funzione: accettare `&[T]` invece di `&Vec<T>` o `&[T; N]` rende la funzione più versatile, accettando qualsiasi sequenza contigua di elementi.

## Pseudocodice

```rust
// Tuple: collezioni eterogenee di lunghezza fissa
fn esempi_tuple() {
    // Dichiarazione di una tupla
    let persona: (&str, i32, f64) = ("Mario", 30, 1.75);
    
    // Accesso per indice
    let nome = persona.0;  // "Mario"
    let eta = persona.1;   // 30
    let altezza = persona.2;  // 1.75
    
    // Destructuring (spacchettamento)
    let (n, e, a) = persona;
    println!("{} ha {} anni e è alto {}m", n, e, a);
    
    // Tuple come valore di ritorno
    let risultato = dividi(10, 3);
    // risultato.0 = quoziente, risultato.1 = resto
    println!("{} resto {}", risultato.0, risultato.1);
    
    // Unit type: tupla vuota ()
    let unit = ();  // Usata come valore di ritorno di funzioni che non restituiscono nulla
}

fn dividi(dividendo: i32, divisore: i32) -> (i32, i32) {
    let quoziente = dividendo / divisore;
    let resto = dividendo % divisore;
    (quoziente, resto)  // Ritorno implicito senza return
}

// Array: collezioni omogenee di lunghezza fissa (conosciuta a compile time)
fn esempi_array() {
    // Array di 5 elementi i32
    let numeri: [i32; 5] = [1, 2, 3, 4, 5];
    
    // Array con stesso valore ripetuto
    let zeri: [i32; 100] = [0; 100];  // 100 zeri
    
    // Accesso per indice
    let primo = numeri[0];  // 1
    let ultimo = numeri[4];  // 5
    // let errore = numeri[10];  // PANIC: indice fuori range
    
    // Lunghezza dell'array (costante nota a compile time)
    let len = numeri.len();  // 5
    
    // Iterazione
    for numero in numeri.iter() {
        println!("{}", numero);
    }
    
    // Array multidimensionali
    let matrice: [[i32; 3]; 3] = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ];
}

// Slice: vista dinamica su una sequenza contigua
fn esempi_slice() {
    let array = [1, 2, 3, 4, 5];
    
    // Creare una slice da un array
    let slice_completa: &[i32] = &array;  // Tutto l'array
    let slice_parciale: &[i32] = &array[1..4];  // Elementi 1, 2, 3
    let slice_prefix: &[i32] = &array[..3];     // Primi 3 elementi
    let slice_suffix: &[i32] = &array[2..];     // Dal terzo in poi
    
    // La slice ha lunghezza nota solo a runtime
    println!("Lunghezza: {}", slice_parciale.len());  // 3
    
    // Slicing di stringhe (string slice)
    let testo = "Ciao, mondo!";
    let prima_parola = &testo[..4];  // "Ciao"
}

// Funzioni che accettano slice (più flessibili)
fn calcola_media(numeri: &[f64]) -> f64 {
    // Funziona con array, slice, o Vec
    if numeri.is_empty() {
        return 0.0;
    }
    let somma: f64 = numeri.iter().sum();
    somma / numeri.len() as f64
}

// Esempio completo
fn main() {
    let coordinate: (f64, f64) = (45.4642, 9.1900);  // Milano
    let (lat, lon) = coordinate;
    
    let temperature: [f64; 7] = [22.5, 23.0, 21.5, 24.0, 25.5, 23.5, 22.0];
    let media = calcola_media(&temperature);
    
    // Usare una slice per gli ultimi 3 giorni
    let ultimi_3_giorni = &temperature[4..7];
    let media_recente = calcola_media(ultimi_3_giorni);
    
    println!("Media settimanale: {:.1}°C", media);
    println!("Media ultimi 3 giorni: {:.1}°C", media_recente);
}
```

## Risorse

- [Compound Types - The Rust Book](https://doc.rust-lang.org/book/ch03-02-data-types.html#compound-types)
- [Tuples - Rust by Example](https://doc.rust-lang.org/rust-by-example/primitives/tuples.html)
- [Arrays and Slices - Rust by Example](https://doc.rust-lang.org/rust-by-example/primitives/array.html)

## Esercizio

Scrivi una funzione `trova_minimo_massimo` che accetta una slice di numeri interi e restituisce una tupla contenente (minimo, massimo). Se la slice è vuota, restituisci (0, 0).

**Traccia di soluzione:**
1. Verifica se la slice è vuota
2. Inizializza min e max con il primo elemento
3. Itera sugli elementi rimanenti aggiornando min e max
4. Restituisci la tupla (min, max)
5. Usa &[
i32] come tipo parametro per flessibilità
