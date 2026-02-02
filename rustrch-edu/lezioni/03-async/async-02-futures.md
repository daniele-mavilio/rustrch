## Teoria

Le funzioni async in Rust rappresentano il fondamento del programming asincrono, consentendo di scrivere codice che sembra sequenziale ma viene eseguito in modo non bloccante. Una funzione async restituisce un `Future`, che è essenzialmente una promessa che un valore sarà disponibile in futuro. Il `Future` implementa il trait `std::future::Future` e ha un metodo `poll` che il runtime chiama per controllare se il futuro è pronto.

L'operatore `await` è il cuore dell'async programming: sospende l'esecuzione della funzione corrente fino a quando il `Future` non è completato, senza bloccare il thread. Questo permette a Rust di essere efficiente anche in contesti concorrenti, poiché un singolo thread può gestire migliaia di futures simultaneamente.

Un concetto chiave è il pinning: i futures possono contenere riferimenti a se stessi, quindi devono essere "pinnati" in memoria per evitare problemi di validità. Rust usa `Pin<P>` per questo scopo, e le funzioni async automaticamente restituiscono future pinnate tramite il runtime.

## Esempio

Immagina di avere un servizio che deve elaborare richieste utente: leggere da database, fare calcoli, e scrivere risultati. Senza async, ogni richiesta bloccherebbe il server. Con async:

```rust
async fn process_request(user_id: u64) -> Result<UserData, Error> {
    let user = get_user_from_db(user_id).await?;  // aspetta il DB
    let processed = compute_heavy_task(&user).await?;  // aspetta il calcolo
    save_to_db(&processed).await?;  // aspetta il salvataggio
    Ok(processed)
}
```

Questo permette al server di servire migliaia di richieste contemporaneamente su pochi thread.

## Pseudocodice

```rust
// Definire un future semplice
async fn simple_future() -> i32 {
    // Questa funzione torna un Future che risolve a i32
    42 // il valore finale
}

// Usare await per aspettare un futuro
async fn caller() {
    let value = simple_future().await; // sospende fino a che non è pronto
    println!("Valore: {}", value);
}

// Creare futures annidati
async fn nested_async() {
    // Un futuro dentro un altro
    let inner = async { 
        std::thread::sleep(std::time::Duration::from_secs(1)); // simulare lavoro
        "risultato interno"
    };
    let result = inner.await; // aspettare l'interno
    println!("Risultato: {}", result);
}

// Gestire multiple futures
async fn multiple_tasks() {
    // Creare due task indipendenti
    let task1 = async { 1 + 1 };
    let task2 = async { 2 * 2 };
    
    // Aspettare entrambi in parallelo (in Rust vero usiamo join!)
    let (res1, res2) = (task1.await, task2.await);
    println!("Risultati: {} e {}", res1, res2);
}
```

## Risorse

- [Futures Explained - Official Rust](https://doc.rust-lang.org/std/future/)
- [Async Book - Async Functions](https://rust-lang.github.io/async-book/03_async_await/01_chapter.html)
- [Tokio Examples - Basic Futures](https://github.com/tokio-rs/tokio/tree/master/examples)

## Esercizio

Scrivi una funzione async che simula il download di due file da internet. La funzione deve:

1. Definire due futures separati che "scaricano" (usa sleep di 1 e 2 secondi per simulare)
2. Usare await per aspettare il completamento di entrambi
3. Restituire una tupla con i tempi totali
4. Gestire eventuali errori con Result