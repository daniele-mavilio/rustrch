# Differenza tra Codice Sincrono e Asincrono

## Teoria

Immagina di essere in una caffetteria. Nel modello **sincrono**, quando ordini un caffè, resti in piedi al bancone ad aspettare che il barista lo prepari. Non puoi fare altro finché il caffè non è pronto. Questo è esattamente come funziona il codice sincrono: le operazioni vengono eseguite una dopo l'altra, in sequenza, e ogni operazione blocca l'esecuzione fino al suo completamento.

Nel modello **asincrono**, invece, ordini il caffè, ti siedi a un tavolo e continui a leggere il giornale. Quando il caffè è pronto, il barista ti chiama. Nel frattempo, hai fatto altre cose utili invece di aspettare inattivo. Il codice asincrono permette di avviare operazioni lunghe (come scaricare file o interrogare database) senza bloccare l'esecuzione del programma.

La differenza fondamentale sta nel **controllo del flusso**. Nel codice sincrono, tu (il programmatore) controlli esattamente quando ogni operazione inizia e finisce. Nel codice asincrono, deleghi il controllo a un runtime che gestisce l'esecuzione concorrente delle operazioni. Rust implementa l'asincronia attraverso il tipo `Future`, che rappresenta un'operazione che potrebbe non essere completata immediatamente ma lo sarà in futuro.

## Esempio

Consideriamo un motore di ricerca che deve scaricare 100 pagine web. In modalità sincrona, scaricheresti la pagina 1, aspetti che finisca, poi scarichi la pagina 2, aspetti, e così via. Se ogni pagina richiede 2 secondi, il totale è 200 secondi.

In modalità asincrona, avvii tutti e 100 i download contemporaneamente. Mentre una pagina sta scaricando (operazione di I/O), il processore è libero di gestire altre richieste. Quando una pagina è pronta, il sistema la processa immediatamente. Il tempo totale si riduce drasticamente, vicino al tempo della pagina più lenta, non alla somma di tutte.

Questo pattern è essenziale per applicazioni web moderne. Un server sincrono può gestire un cliente alla volta, mentre uno asincrono può servire migliaia di richieste simultanee con le stesse risorse hardware.

## Pseudocodice

```rust
// Esempio di codice SINCRONO: blocca l'esecuzione
fn scarica_pagine_sincrono(urls: Vec<String>) -> Vec<String> {
    // Crea un vettore per memorizzare i contenuti
    let mut risultati = Vec::new();
    
    // Per ogni URL nella lista
    for url in urls {
        // QUESTA RIGA BLOCCA: aspetta che il download finisca
        // Durante questa attesa, il programma non fa null'altro
        let contenuto = download_http_bloccante(&url);
        
        // Solo dopo il download, aggiunge al risultato
        risultati.push(contenuto);
    }
    
    // Restituisce tutti i contenuti scaricati
    risultati
}

// Esempio di codice ASINCRONO: non blocca
async fn scarica_pagine_asincrono(urls: Vec<String>) -> Vec<String> {
    // Crea un vettore di Future (promesse di lavoro futuro)
    let mut tasks = Vec::new();
    
    // Per ogni URL, crea un task asincrono
    for url in urls {
        // spawn crea un nuovo task che gira in parallelo
        // NON aspetta che finisca, prosegue immediatamente
        let task = tokio::spawn(async move {
            // Questo download è asincrono, non blocca gli altri task
            download_http_asincrono(&url).await
        });
        
        // Aggiunge il task alla lista
        tasks.push(task);
    }
    
    // Ora aspetta che TUTTI i task finiscano
    // Durante l'attesa, il runtime esegue altri task pronti
    let mut risultati = Vec::new();
    for task in tasks {
        // .await sospende questo punto fino al completamento
        let contenuto = task.await.unwrap();
        risultati.push(contenuto);
    }
    
    risultati
}

// Funzione principale asincrona
#[tokio::main]
async fn main() {
    let urls = vec![
        "https://esempio.com/1".to_string(),
        "https://esempio.com/2".to_string(),
    ];
    
    // Avvia tutti i download in parallelo
    let pagine = scarica_pagine_asincrono(urls).await;
    
    // Stampa i risultati
    for pagina in pagine {
        println!("Scaricata: {}", pagina.len());
    }
}
```

## Risorse

- [Async Programming in Rust - Rust Book](https://rust-lang.github.io/async-book/)
- [The Rust Programming Language - Concurrency](https://doc.rust-lang.org/book/ch16-00-concurrency.html)
- [Tokio - Asynchronous Runtime for Rust](https://tokio.rs/)
- [Futures and Async/Await in Rust](https://doc.rust-lang.org/std/future/index.html)
- [Rust by Example - Async/Await](https://doc.rust-lang.org/rust-by-example/std_misc/async.html)

## Esercizio

**Problema**: Hai una lista di 5 URL di blog che vuoi scaricare per il tuo motore di ricerca. Scrivi una funzione asincrona che le scarichi tutte in parallelo e restituisca il numero totale di caratteri scaricati.

**Traccia di soluzione**:

1. Crea una funzione `async fn conta_caratteri(urls: Vec<String>) -> usize`
2. Usa `tokio::spawn` per creare un task per ogni URL
3. Ogni task dovrebbe scaricare il contenuto e restituire la lunghezza
4. Usa `join_all` o un ciclo con `.await` per raccogliere i risultati
5. Somma tutte le lunghezze e restituisci il totale

**Suggerimento**: Ricorda che `.await` può essere usato solo dentro funzioni async. Se vuoi testare il codice, annota la funzione main con `#[tokio::main]`.
