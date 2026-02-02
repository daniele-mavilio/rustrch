# Ownership: move semantics e Copy trait

## Teoria
In Rust, il concetto di *Ownership* è centrale per garantire la sicurezza della memoria senza un garbage collector. Un aspetto fondamentale dell'ownership è la *move semantics*, che definisce come i valori vengono trasferiti tra le variabili e le funzioni. Quando un valore non implementa il `Copy` trait e viene assegnato a una nuova variabile o passato a una funzione, la sua proprietà viene "mossa". Questo significa che la variabile o il "possessore" originale non può più accedere al valore, prevenendo l'accesso a dati invalidi o doppi rilasci di memoria.

Consideriamo un esempio con un `String`: quando creiamo una `String`, questa alloca memoria sull'heap. Se assegniamo questa `String` a una nuova variabile, Rust non ne crea una copia profonda per default. Invece, trasferisce la proprietà della memoria allocata. Questo assicura che ci sia sempre un unico possessore (owner) dei dati, il che è una garanzia di sicurezza.

Tuttavia, non tutti i tipi seguono le *move semantics*. Per i tipi semplici, come numeri interi (`i32`), booleani (`bool`) o caratteri (`char`), Rust implementa il `Copy` trait. Questo tratto (trait) indica che un tipo può essere copiato bit-a-bit senza costi aggiuntivi o effetti collaterali complessi. Quando un tipo implementa `Copy`, un'assegnazione o un passaggio a funzione non "muove" la proprietà, ma crea una copia esatta del valore. Questo è efficiente perché questi tipi non possiedono risorse esterne (come memoria sull'heap) che richiederebbero una logica di deallocazione speciale. La distinzione tra *move* e *copy* è un pilastro della gestione della memoria in Rust e comprenderla è cruciale per scrivere codice sicuro e performante.

## Esempio
Vediamo come si manifestano le *move semantics* e il `Copy` trait in pratica nel contesto del nostro motore di ricerca.

Immagina di avere una funzione che processa il contenuto di una pagina web. Quando creiamo una `String` con il titolo della pagina, questa alloca memoria sull'heap. Se passiamo questa stringa a un'altra funzione senza usarne i riferimenti, il valore viene "mosso". Questo significa che la funzione chiamante diventa il nuovo proprietario e la variabile originale non può più essere usata. Questo comportamento previene errori di doppio rilascio di memoria.

D'altra parte, quando lavoriamo con dati semplici come il numero di parole in un documento (un `i32`), il valore viene copiato automaticamente. Questo è possibile perché i tipi che implementano il `Copy` trait non gestiscono risorse esterne come la memoria sull'heap. La distinzione tra questi due comportamenti è fondamentale per capire come Rust gestisce la memoria in modo sicuro ed efficiente.

## Pseudocodice

```rust
// Dichiarazione di una variabile String, che non implementa Copy
fn esempio_move_string() {
    let stringa_originale = String::from("Hello, Rust!"); // stringa_originale detiene la proprietà dei dati
    let stringa_spostata = stringa_originale;             // La proprietà viene spostata a stringa_spostata
                                                          // stringa_originale ora non è più valida (mosso)

    // Tentare di usare stringa_originale qui causerebbe un errore di compilazione
    // per accesso a un valore mosso (uso dopo move)
    // println!("{}", stringa_originale);
    println!("Contenuto spostato: {}", stringa_spostata); // stringa_spostata è ora l'unico possessore
}

// Dichiarazione di una variabile i32, che implementa Copy
fn esempio_copy_i32() {
    let numero_originale = 100; // numero_originale detiene il valore 100
    let numero_copiato = numero_originale; // Il valore 100 viene copiato per numero_copiato
                                            // numero_originale è ancora valido (copiato)

    println!("Originale: {}", numero_originale); // Entrambe le variabili possono essere usate
    println!("Copiato: {}", numero_copiato);     // Hanno copie indipendenti dello stesso valore
}

// Struttura che contiene solo tipi Copy, quindi implementa automaticamente Copy
#[derive(Copy, Clone)] // Il compilatore può derivare Copy se tutti i campi sono Copy.
                       // Clone è spesso richiesto anche quando si deriva Copy.
struct Punto {
    x: i32,            // i32 è Copy
    y: i32,            // i32 è Copy
}

fn esempio_copy_struct() {
    let p1 = Punto { x: 10, y: 20 }; // p1 detiene la proprietà del Punto
    let p2 = p1;                     // Il Punto viene copiato per p2 (perché Punto è Copy)
                                     // p1 è ancora valido

    println!("Punto originale: ({}, {})", p1.x, p1.y); // p1 è ancora accessibile
    println!("Punto copiato: ({}, {})", p2.x, p2.y);   // p2 ha la sua copia
}
```

## Risorse
- [The Rust Book - Understanding Ownership](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
- [The Rust Book - Copy Trait](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html#the-copy-trait)
- [Documentazione standard Rust per `std::marker::Copy`](https://doc.rust-lang.org/std/marker/trait.Copy.html)
- [Documentazione standard Rust per `std::clone::Clone`](https://doc.rust-lang.org/std/clone/trait.Clone.html)

## Esercizio
Considera i seguenti frammenti di codice Rust. Spiega perché il primo frammento compila senza errori, mentre il secondo no, e come potresti modificare il secondo per farlo compilare correttamente, mantenendo l'intento originale (avere due variabili indipendenti).

```rust
// Frammento 1
fn main() {
    let a = 10;
    let b = a;
    println!("a: {}, b: {}", a, b);
}

// Frammento 2
fn main() {
    let s1 = String::from("Ciao mondo");
    let s2 = s1;
    println!("s1: {}, s2: {}", s1, s2);
}
```

Traccia di soluzione:
Il Frammento 1 compila perché `i32` è un tipo che implementa il `Copy` trait. Quando `b = a` viene eseguito, il valore di `a` viene copiato, non mosso, e quindi `a` rimane valido. Il Frammento 2 non compila perché `String` non implementa `Copy`, ma implementa `Drop`. Pertanto, quando `s2 = s1` viene eseguito, la proprietà dei dati di `s1` viene mossa a `s2`, rendendo `s1` non più valido. Tentare di usarlo successivamente è un errore di "use after move". Per far compilare il Frammento 2 mantenendo due stringhe indipendenti, si dovrebbe usare il metodo `.clone()`: `let s2 = s1.clone();`. Questo crea una copia profonda dei dati sull'heap, dando a `s2` la sua proprietà indipendente.