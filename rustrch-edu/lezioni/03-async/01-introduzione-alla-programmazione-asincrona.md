# Introduzione alla Programmazione Asincrona in Rust

## Teoria
La programmazione asincrona è un paradigma che permette di eseguire più compiti (task) in modo concorrente, senza bloccare il thread di esecuzione principale. Immagina un cuoco in una cucina: invece di preparare un piatto dall'inizio alla fine prima di iniziare il successivo (approccio sincrono), può mettere a cuocere la pasta, nel frattempo preparare il sugo e intanto tagliare le verdure per il contorno. Quando l'acqua bolle o il sugo è pronto, sposta la sua attenzione su quel compito. Questo "non bloccarsi" in attesa che un'operazione lenta finisca è il cuore dell'approccio asincrono.

In contesti come un motore di ricerca, questo è fondamentale. Per indicizzare il web, dobbiamo effettuare migliaia di richieste di rete (I/O-bound operations) per scaricare le pagine. Un approccio sincrono sarebbe disastroso: il nostro programma passerebbe la maggior parte del tempo fermo, in attesa della risposta di un server. Con la programmazione asincrona, possiamo lanciare centinaia di richieste di download "contemporaneamente". Mentre attendiamo la risposta di un server, il nostro programma può lavorare su altre cose, come processare una pagina già scaricata o avviare nuove richieste.

Rust implementa la programmazione asincrona tramite le parole chiave `async` e `await`. Una funzione marcata come `async` non restituisce direttamente un valore, ma un `Future`. Un `Future` è un tipo speciale che rappresenta un calcolo che potrebbe non essere ancora completato. È una "promessa" di un valore futuro. L'operatore `.await` viene usato per "attendere" il completamento di un `Future` senza bloccare l'intero thread, permettendo ad un esecutore (runtime come Tokio) di gestire altri task nel frattempo.

## Esempio
Nel nostro motore di ricerca, il crawler è il componente che più beneficia dell'asincronia. Il suo compito è scaricare pagine web da una lista di URL.

**Approccio Sincrono:**
1. Prendi URL 1.
2. Invia richiesta HTTP.
3. Attendi la risposta (il programma è bloccato).
4. Processa la pagina.
5. Prendi URL 2 e ripeti.
Se ogni richiesta impiega 1 secondo, per 100 URL impiegheremmo 100 secondi.

**Approccio Asincrono:**
1. Lancia 100 task, uno per ogni URL, che inviano richieste HTTP.
2. Nessuno di questi task blocca il programma. Mentre attendono la risposta di rete, l'esecutore può gestire altri compiti.
3. Appena un server risponde, il `Future` corrispondente si "risolve", il suo task riprende l'esecuzione e processa la pagina.
In questo modo, il tempo totale non è la somma dei tempi di attesa, ma è più vicino al tempo della richiesta più lenta, con un'efficienza enormemente maggiore. Questo ci permette di parallelizzare operazioni di I/O (Input/Output) e sfruttare al massimo le risorse del sistema.

## Pseudocodice
```rust
// Per eseguire codice asincrono, serve una runtime come Tokio.
// La funzione main deve essere marcata con l'attributo di Tokio.
#[tokio::main]
async fn main() {
    // Definiamo due URL da scaricare.
    let url1 = "https://www.rust-lang.org";
    let url2 = "https://tokio.rs";

    // Chiamiamo la nostra funzione asincrona per entrambi gli URL.
    // La chiamata restituisce immediatamente un Future, non il contenuto della pagina.
    let future1 = scarica_pagina(url1);
    let future2 = scarica_pagina(url2);

    // `join!` è un costrutto che attende il completamento di più Future contemporaneamente.
    // L'esecuzione qui si sospende finché entrambe le pagine non sono state scaricate.
    let (contenuto1, contenuto2) = tokio::join!(future1, future2);

    // Stampiamo un messaggio per mostrare che abbiamo ricevuto i contenuti.
    println!("Pagina 1 scaricata! Lunghezza: {}", contenuto1.len());
    println!("Pagina 2 scaricata! Lunghezza: {}", contenuto2.len());
}

// Definiamo una funzione asincrona con la keyword `async`.
// Restituisce un `Future<String>`, anche se scriviamo solo `String`.
async fn scarica_pagina(url: &str) -> String {
    // Simuliamo una richiesta di rete che richiede tempo.
    println!("Inizio download di {}", url);
    
    // `reqwest::get` è una funzione asincrona di una libreria per richieste HTTP.
    // `.await` sospende l'esecuzione di `scarica_pagina` finché la richiesta non è completata.
    // Nel frattempo, la runtime può eseguire altri task (come l'altro download).
    let risposta = reqwest::get(url).await.unwrap();
    
    // Anche leggere il corpo della risposta è un'operazione asincrona.
    let corpo = risposta.text().await.unwrap();

    println!("Fine download di {}", url);
    // Quando la funzione termina, il Future che rappresenta si risolve con questo valore.
    corpo
}
```

## Risorse
- [The Rust Programming Language: Asynchronous Programming with `async` and `await`](https://doc.rust-lang.org/book/ch20-02-multithreaded.html) (Il libro copre il multithreading, che è la base per capire la concorrenza prima di passare all'async).
- [Rust `async` book: The `Future` Trait](https://rust-lang.github.io/async-book/02_execution/01_future.html)
- [Tokio.rs Tutorial: Hello Tokio](https://tokio.rs/tokio/tutorial/hello-tokio)

## Esercizio
Pensa ad un'altra parte del nostro motore di ricerca che potrebbe trarre vantaggio dall'essere asincrona. Potrebbe essere la scrittura dei risultati su un database o su file. Scrivi lo "scheletro" di una funzione `async` che salvi i dati di una pagina indicizzata.

**Traccia di soluzione:**
```rust
// async fn salva_dati_pagina(url: &str, contenuto: &str) -> Result<(), std::io::Error> {
//     // Qui useresti una libreria asincrona per l'accesso al database o ai file,
//     // come `tokio::fs` per scrivere su un file in modo non bloccante.
//     // L'operazione di scrittura sarebbe seguita da .await.
//     Ok(())
// }
```
