## Teoria

L'asincrono programming cambia il modo in cui pensiamo alla concorrenza. In Rust, l'asincrono non è solo un modo per evitare il blocco, ma un modello che permette di scrivere codice concorrente in modo sicuro e prevedibile. A differenza dei thread che sono pesanti e costosi da creare, i future sono leggeri e possono essere creati in grandi quantità.

Quando una funzione viene marcata come `async`, il compilatore la trasforma in una macchina a stati che implementa il trait `Future`. Questo significa che il codice viene "tagliato" in punti dove può essere sospeso, e il runtime gestisce la ripresa quando i dati sono pronti.

Obbligatorio capire che `await` non è magia: semplicemente dice al runtime "sono bloccato qui, sveglia me quando questo futuro è pronto, e nel frattempo esegui altri futures". Questo modello cooperativo garantisce che non ci siano race conditions nascoste come in altri linguaggi.

## Esempio

Un crawler web semplice che scarica molteplici pagine in parallelo rende chiaro il potere dell'asincrono:

```rust
use reqwest;

async fn crawl_pages(urls: Vec<&str>) -> Result<Vec<String>, Error> {
    let futures: Vec<_> = urls.into_iter()
        .map(|url| async move {
            reqwest::get(url).await?.text().await
        })
        .collect();
    
    // Aspetta tutti i download in parallelo
    futures_util::future::try_join_all(futures).await
}
```

Questo codice scarica tutte le URL contemporaneamente invece di sequenzialmente.

## Pseudocodice

```rust
// Sintassi base di una funzione async
async fn basic_async() -> i32 {
    // Il corpo della funzione è "normale"
    let x = 10;
    let y = 20;
    x + y // restituisce un Future<i32>
}

// Usare await per sospendere
async fn using_await() {
    println!("Prima");
    
    // Questo sospende per 1 secondo
    tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
    
    println!("Dopo 1 secondo");
}

// Futures concatenati
async fn chained_futures() -> Result<String, Error> {
    // Ogni await sospende la funzione
    let data = fetch_data().await?;
    let processed = process_data(data).await?;
    let saved = save_to_db(processed).await?;
    Ok(saved)
}

// Gestire errori in async
async fn error_handling() -> Result<(), Error> {
    match fallible_operation().await {
        Ok(val) => println!("Successo: {}", val),
        Err(e) => {
            eprintln!("Errore: {}", e);
            return Err(e);
        }
    }
    
    Ok(())
}
```

## Risorse

- [Asynchronous Programming in Rust](https://doc.rust-lang.org/async-book/)
- [Futures in Rust - Standard Library](https://doc.rust-lang.org/std/future/)
- [Async/Await Tutorial](https://rust-lang.github.io/async-book/03_async_await/01_chapter.html)

## Esercizio

Implementa una funzione async chiamata `sequential_vs_parallel` che dimostri la differenza tra eseguire due operazioni I/O in sequenza e in parallelo:

1. Crea due funzioni async che simulino operazioni I/O (usa `tokio::time::sleep`)
2. Misura il tempo totale per eseguirle sequenzialmente (await -> await)
3. Misura il tempo totale per eseguirle in parallelo (join!)
4. Restituisci una tupla con i due tempi misurati