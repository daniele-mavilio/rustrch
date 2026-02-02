# Trait: Trait Bounds e Generics

## Teoria

I trait bounds sono il modo in cui Rust esprime vincoli sui tipi generici. Quando scrivi una funzione generica che lavora con un tipo `T`, puoi specificare che `T` deve implementare certi trait. Questo permette al compilatore di garantire che solo i tipi corretti possano essere usati, e permette alla funzione di chiamare i metodi di quei trait sui valori di tipo `T`.

La sintassi per i trait bounds può apparire in diversi posti: nelle parentesi angolari della funzione `<T: Trait>`, in una clausola `where` separata, o nelle struct e impl generiche. La clausola `where` è particolarmente utile quando ci sono molti bounds o quando sono complessi, migliorando la leggibilità.

I generics combinati con i trait bounds permettono di scrivere codice astratto che mantiene le prestazioni del codice specifico grazie alla monomorfizzazione. Il compilatore genera una versione specializzata della funzione per ogni combinazione di tipi concreta usata, eliminando l'overhead del dispatch dinamico. Questo è il "zero-cost abstraction" di Rust.

## Esempio

Immagina di voler ordinare qualsiasi slice di elementi che possono essere confrontati:

```rust
fn ordina<T: Ord>(slice: &mut [T]) {
    slice.sort();
}
```

Qui `T: Ord` è un trait bound che richiede che il tipo T implementi il trait `Ord` (ordinamento totale). Questo garantisce che possiamo chiamare `sort()` sulla slice, perché il metodo richiede elementi ordinabili.

Quando abbiamo molti bounds, la clausola `where` è più pulita:

```rust
fn processa<T, U>(t: T, u: U) -> String
where
    T: Display + Clone,
    U: Clone + Debug,
{
    format!("t = {}, u = {:?}", t, u)
}
```

## Pseudocodice

```rust
// Trait bounds base
fn maggiore<T: PartialOrd>(a: T, b: T) -> T {
    if a > b { a } else { b }
}

// Multipli trait bounds con +
fn stampa_e_duplica<T: Display + Clone>(item: T) {
    println!("{}", item);
    let _clone = item.clone();
}

// Clausola where per bounds complessi
fn funzione_complessa<T, U>(t: T, u: U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug + 'static,
{
    println!("t = {}, u = {:?}", t, u);
    42
}

// Struct generica con trait bounds
struct Wrapper<T: Display> {
    valore: T,
}

impl<T: Display> Wrapper<T> {
    fn nuovo(valore: T) -> Self {
        Wrapper { valore }
    }
    
    fn stampa(&self) {
        println!("Wrapped: {}", self.valore);
    }
}

// Implementazione condizionale (impl con bounds)
struct Contenitore<T> {
    dati: T,
}

// Solo per tipi che implementano Clone
impl<T: Clone> Clone for Contenitore<T> {
    fn clone(&self) -> Self {
        Contenitore {
            dati: self.dati.clone(),
        }
    }
}

// Solo per tipi che implementano Display
impl<T: Display> Contenitore<T> {
    fn mostra(&self) {
        println!("Contenuto: {}", self.dati);
    }
}

// Trait bounds sui ritorni
fn crea<T: Default>() -> T {
    T::default()
}

// Associated type bounds
trait Elaboratore {
    type Input: Display;
    type Output: Debug;
    
    fn elabora(&self, input: Self::Input) -> Self::Output;
}

// Bounds ricorsivi
fn ordina_slice<T: Ord>(slice: &mut [T]) {
    slice.sort();
}

// Bounds sui reference
fn lunghezza<T: AsRef<str>>(s: T) -> usize {
    s.as_ref().len()
}

// Trait bounds con lifetime
fn referenzia<'a, T: 'a>(t: &'a T) -> &'a T {
    t
}

// Esempio pratico: Funzioni generiche per collezioni
fn trova_massimo<T: PartialOrd + Copy>(slice: &[T]) -> Option<T> {
    if slice.is_empty() {
        return None;
    }
    
    let mut max = slice[0];
    for &item in &slice[1..] {
        if item > max {
            max = item;
        }
    }
    Some(max)
}

fn somma_numeri<T>(slice: &[T]) -> T
where
    T: std::ops::Add<Output = T> + Copy + Default,
{
    slice.iter().fold(T::default(), |acc, &x| acc + x)
}

// Bounds con generics nested
fn appiattisci<T>(nested: Vec<Vec<T>>) -> Vec<T> {
    nested.into_iter().flatten().collect()
}

// Trait objects vs Generics con bounds
// Static dispatch (monomorfizzazione)
fn usa_generico<T: Descrivibile>(item: &T) {
    item.descrivi();
}

// Dynamic dispatch (v-table)
fn usa_trait_object(item: &dyn Descrivibile) {
    item.descrivi();
}

// PhantomData per bounds su tipi non usati
use std::marker::PhantomData;

struct WrapperMarcato<T, U> {
    dati: T,
    _marker: PhantomData<U>,
}

impl<T: Clone, U> Clone for WrapperMarcato<T, U> {
    fn clone(&self) -> Self {
        WrapperMarcato {
            dati: self.dati.clone(),
            _marker: PhantomData,
        }
    }
}

// Esempio pratico: Ricerca generica
trait Ricercabile {
    fn corrisponde(&self, query: &str) -> bool;
    fn punteggio(&self, query: &str) -> f64;
}

fn cerca<T: Ricercabile>(documenti: &[T], query: &str) -> Vec<&T> {
    documenti
        .iter()
        .filter(|doc| doc.corrisponde(query))
        .collect()
}

fn cerca_e_ordina<T: Ricercabile>(documenti: &[T], query: &str) -> Vec<&T> {
    let mut risultati: Vec<&T> = cerca(documenti, query);
    risultati.sort_by(|a, b| {
        b.punteggio(query)
            .partial_cmp(&a.punteggio(query))
            .unwrap()
    });
    risultati
}
```

## Risorse

- [Trait Bounds - The Rust Book](https://doc.rust-lang.org/book/ch10-02-traits.html#trait-bound-syntax)
- [Where Clauses](https://doc.rust-lang.org/book/ch10-02-traits.html#where-clauses)
- [Generic Types](https://doc.rust-lang.org/book/ch10-01-syntax.html)

## Esercizio

Scrivi una funzione generica `calcola_media` che:
1. Accetta una slice di elementi generici T
2. Calcola e restituisce la media come f64
3. Richiede i trait bounds appropriati per fare somma e conversione

**Traccia di soluzione:**
1. La funzione deve avere signature: `fn calcola_media<T>(slice: &[T]) -> f64`
2. Serve: `T: std::ops::Add<Output = T> + Copy + Default`
3. Serve anche convertire T in f64, quindi aggiungi: `T: Into<f64>`
4. Usa fold per sommare tutti gli elementi
5. Dividi la somma per slice.len() come f64
6. Gestisci il caso slice vuota (restituisci 0.0)

**Test con:**
- &[1, 2, 3, 4, 5] (i32) → media 3.0
- &[1.5, 2.5, 3.0] (f64) → media 2.333...
