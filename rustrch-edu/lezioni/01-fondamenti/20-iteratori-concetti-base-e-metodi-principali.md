# Iteratori: Concetti Base e Metodi Principali

## Teoria

Gli iteratori sono uno degli strumenti più potenti e idiomatici in Rust. Invece di manipolare collezioni direttamente con loop, gli iteratori forniscono un modo dichiarativo e composable di processare sequenze di dati. Quasi tutte le collezioni in Rust implementano il trait `IntoIterator`, permettendo di iterare sui loro elementi in modo uniforme.

Un iteratore è un oggetto che produce una sequenza di valori, tipicamente uno alla volta. Il trait fondamentale è `Iterator` che richiede il metodo `next()`, che restituisce `Option<Self::Item>`. Quando ci sono ancora elementi, restituisce `Some(item)`; quando la sequenza è esaurita, restituisce `None`. Questo semplice protocollo permette costrutti potenti come `for` loop, adapter methods, e lazy evaluation.

La lazy evaluation (valutazione pigra) significa che gli iteratori non processano gli elementi finché non è necessario. Quando concateni multiple operazioni (map, filter, take), non vengono create collezioni intermedie; ogni elemento fluisce attraverso l'intera catena prima di passare al successivo. Questo è efficiente in termini di memoria e permette di lavorare con sequenze potenzialmente infinite.

## Esempio

Consideriamo un motore di ricerca che deve processare milioni di documenti. Usando iteratori, possiamo filtrare, trasformare e limitare i risultati senza mai caricare tutto in memoria:

```rust
let risultati: Vec<Documento> = database
    .iter_documenti()           // Iteratore lazy
    .filter(|doc| doc.punteggio > 0.5)  // Filtro
    .take(100)                   // Prendi solo i primi 100
    .collect();                  // Materializza in vettore
```

Senza iteratori, dovremmo caricare tutti i documenti in memoria, filtrarli, e poi prendere i primi 100. Con iteratori, ogni documento viene processato individualmente e scartato se non soddisfa i criteri, mantenendo l'uso di memoria costante indipendentemente dalla dimensione del database.

## Pseudocodice

```rust
// Creare iteratori
fn creare_iteratori() {
    let vettore = vec![1, 2, 3, 4, 5];
    
    // Da vettore (prende riferimento)
    let iter = vettore.iter();
    
    // Da vettore (prende ownership)
    let iter_owned = vettore.into_iter();
    
    // Da range
    let range = 1..10;  // 1 a 9
    let range_incluso = 1..=10;  // 1 a 10
    
    // Da slice
    let slice = &[1, 2, 3];
    let iter_slice = slice.iter();
}

// Metodo next()
fn uso_next() {
    let v = vec![1, 2, 3];
    let mut iter = v.iter();
    
    // next() restituisce Option<&T>
    assert_eq!(iter.next(), Some(&1));
    assert_eq!(iter.next(), Some(&2));
    assert_eq!(iter.next(), Some(&3));
    assert_eq!(iter.next(), None);  // Finito
}

// Metodi di consumo (consumono l'iteratore)
fn metodi_consumo() {
    let v = vec![1, 2, 3, 4, 5];
    
    // count(): conta gli elementi
    let n = v.iter().count();  // 5
    
    // sum(): somma gli elementi
    let somma: i32 = v.iter().sum();  // 15
    
    // product(): prodotto degli elementi
    let prodotto: i32 = v.iter().product();  // 120
    
    // collect(): raccoglie in una collezione
    let raddoppiati: Vec<i32> = v.iter().map(|x| x * 2).collect();
    // [2, 4, 6, 8, 10]
    
    // fold(): riduce a un singolo valore
    let somma = v.iter().fold(0, |acc, x| acc + x);  // 15
    
    // any() / all(): controlli booleani
    let ha_pari = v.iter().any(|x| x % 2 == 0);  // true
    let tutti_positivi = v.iter().all(|x| *x > 0);  // true
    
    // find(): trova il primo elemento
    let primo_pari = v.iter().find(|&&x| x % 2 == 0);  // Some(&2)
    
    // position(): trova l'indice del primo elemento
    let indice = v.iter().position(|&x| x == 3);  // Some(2)
    
    // max() / min()
    let max = v.iter().max();  // Some(&5)
    let min = v.iter().min();  // Some(&1)
}

// Adattatori (non consumano, restituiscono nuovo iteratore)
fn adattatori() {
    let v = vec![1, 2, 3, 4, 5];
    
    // map(): trasforma ogni elemento
    let quadrati: Vec<i32> = v.iter()
        .map(|x| x * x)
        .collect();  // [1, 4, 9, 16, 25]
    
    // filter(): mantiene solo elementi che soddisfano il predicato
    let pari: Vec<&i32> = v.iter()
        .filter(|&&x| x % 2 == 0)
        .collect();  // [&2, &4]
    
    // take(): prende solo i primi N elementi
    let primi_3: Vec<&i32> = v.iter().take(3).collect();  // [&1, &2, &3]
    
    // skip(): salta i primi N elementi
    let ultimi_2: Vec<&i32> = v.iter().skip(3).collect();  // [&4, &5]
    
    // enumerate(): indice + valore
    let con_indice: Vec<(usize, &i32)> = v.iter().enumerate().collect();
    // [(0, &1), (1, &2), (2, &3), ...]
    
    // zip(): combina due iteratori
    let nomi = vec!["a", "b", "c"];
    let valori = vec![1, 2, 3];
    let combinati: Vec<(&str, i32)> = nomi.iter()
        .zip(valori.iter())
        .map(|(n, &v)| (*n, v))
        .collect();
    // [("a", 1), ("b", 2), ("c", 3)]
}

// Iteratori infiniti
fn iteratori_infiniti() {
    // repeat(): ripete un valore all'infinito
    let infiniti_1 = std::iter::repeat(1);
    
    // repeat_with(): ripete il risultato di una closure
    let casuali = std::iter::repeat_with(|| rand::random::<f64>());
    
    // from_fn(): genera valori da una closure
    let mut contatore = 0;
    let numeri = std::iter::from_fn(move || {
        contatore += 1;
        Some(contatore)
    });
    
    // Successions: 0, 1, 2, 3, ...
    let successions = 0..;
    
    // Per renderli utili, dobbiamo limitarli
    let primi_5: Vec<i32> = successions.take(5).collect();  // [0, 1, 2, 3, 4]
}

// Esempio pratico: Processamento testo
fn processa_linee(linee: &[String]) -> Vec<String> {
    linee.iter()
        .enumerate()
        .filter(|(_, linea)| !linea.trim().is_empty())  // Ignora vuote
        .filter(|(_, linea)| !linea.starts_with('#'))   // Ignora commenti
        .map(|(i, linea)| format!("{}: {}", i + 1, linea.trim()))
        .collect()
}

// Esempio: Cerca nei documenti
struct Documento {
    id: u64,
    titolo: String,
    parole_chiave: Vec<String>,
}

fn trova_documenti_con_parola(documenti: &[Documento], parola: &str) -> Vec<&Documento> {
    documenti.iter()
        .filter(|doc| doc.parole_chiave.iter().any(|k| k == parola))
        .collect()
}
```

## Risorse

- [Iterators - The Rust Book](https://doc.rust-lang.org/book/ch13-02-iterators.html)
- [Iterator Trait](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
- [Iterators - Rust by Example](https://doc.rust-lang.org/rust-by-example/trait/iter.html)

## Esercizio

Implementa una funzione `media_pari_maggiori_di` che:
1. Accetta una slice di i32 e un valore soglia
2. Calcola la media dei numeri pari maggiori della soglia
3. Restituisce `Option<f64>` (None se non ci sono numeri validi)

**Traccia di soluzione:**
1. Usa iter() per creare un iteratore
2. filter() per selezionare solo pari > soglia
3. collect() in un vettore o usa fold/sum con count
4. Se il conteggio è 0, restituisci None
5. Altrimenti calcola la media come f64 e restituisci Some(media)
6. Alternativa: usa filter().map().collect() poi calcola media
