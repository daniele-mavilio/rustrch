# Async/Await in Rust

## Teoria

L'asincronia in Rust viene gestita in modo elegante attraverso la sintassi `async` e `await`. Questa combinazione permette di scrivere codice asincrono che sembra sincrono, rendendo il flusso di esecuzione più leggibile e naturale. La keyword `async` trasforma una funzione in una funzione asincrona che restituisce un Future, mentre `await` sospende l'esecuzione della funzione asincrona fino a quando il Future non è completato, senza bloccare il thread.

Quando dichiari una funzione con `async fn`, stai creando una funzione che può sospendersi durante l'esecuzione e riprendere più tardi. Questo è fondamentale per le operazioni I/O come richieste HTTP, letture da database, o attesa di eventi. Il vantaggio principale è che il runtime può eseguire altri task durante queste attese, massimizzando l'efficienza.

La sintassi `await` può essere usata solo all'interno di funzioni `async`. Quando incontri un `.await`, la funzione cede il controllo al runtime, che può eseguire altri task. Una volta completato il Future, l'esecuzione riprende esattamente dal punto dove si era interrotta. Questo modello è detto "cooperative multitasking": i task collaborano cedendo il controllo quando sono in attesa, invece di essere forzatamente interrotti.

## Esempio

Immagina di dover scaricare più pagine web per un motore di ricerca. Senza async/await, dovresti usare callback complessi o gestire manualmente i thread. Con async/await, il codice diventa lineare e leggibile:

```rust
async fn scarica_pagine(urls: Vec<&str>) -> Vec<String> {
    let mut risultati = Vec::new();
    for url in urls {
        // Qui la funzione si sospende, ma il thread rimane libero
        let contenuto = scarica_pagina(url).await;
        risultati.push(contenuto);
    }
    risultati
}
```

L'esecuzione procede in modo sequenziale per come leggiamo il codice, ma il runtime può eseguire altri task durante ogni `.await`. Questo permette di gestire migliaia di connessioni contemporaneamente con un singolo thread, riducendo drasticamente l'overhead di memoria rispetto a un approccio multi-thread tradizionale.

## Pseudocodice

```rust
// Dichiariamo una funzione asincrona che scarica dati
async fn fetch_dati(url: &str) -> Result<String, Errore> {
    // Creiamo un client HTTP (operazione istantanea)
    let client = Client::new();
    
    // Avviamo la richiesta HTTP
    // NOTA: qui non aspettiamo ancora, creiamo solo il Future
    let richiesta = client.get(url);
    
    // Con .await sospendiamo l'esecuzione fino al completamento
    // Il runtime può eseguire altri task nel frattempo
    let risposta = richiesta.send().await?;
    
    // Anche la lettura del body è asincrona
    // Usiamo di nuovo .await per aspettare i dati
    let testo = risposta.text().await?;
    
    // Restituiamo il risultato
    Ok(testo)
}

// Funzione che coordina più operazioni asincrone
async fn processa_multipli(urls: &[&str]) -> Vec<String> {
    // Vector per raccogliere i risultati
    let mut completati = Vec::new();
    
    // Iteriamo sugli URL
    for url in urls {
        // Ogni chiamata .await permette al runtime di fare altro
        match fetch_dati(url).await {
            Ok(dati) => {
                // Se va bene, salviamo i dati
                completati.push(dati);
            }
            Err(e) => {
                // Gestiamo l'errore senza bloccare tutto
                println!("Errore con {}: {:?}", url, e);
            }
        }
    }
    
    // Restituiamo tutti i risultati raccolti
    completati
}

// Per eseguire il codice asincrono serve un runtime
fn main() {
    // Tokio fornisce il runtime per eseguire async code
    tokio::runtime::Runtime::new()
        .unwrap()
        .block_on(async {
            // Qui dentro possiamo usare .await
            let urls = vec!["https://example.com", "https://rust-lang.org"];
            let risultati = processa_multipli(&urls).await;
            println!("Scaricati {} documenti", risultati.len());
        });
}
```

## Risorse

- [The Rust Book - Async/Await](https://doc.rust-lang.org/book/ch17-01-futures-and-async.html)
- [Async Rust Book](https://rust-lang.github.io/async-book/)
- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust by Example - Async](https://doc.rust-lang.org/rust-by-example/std_misc/async.html)
- [Crates.io - Tokio](https://crates.io/crates/tokio)

## Esercizio

**Obiettivo:** Crea una funzione asincrona che simuli il crawling di un sito web.

**Traccia:**

1. Scrivi una funzione `async fn crawl_page(url: &str) -> Result<String, String>` che restituisca un messaggio di successo o errore dopo un ritardo simulato di 100ms.

2. Crea una funzione `async fn crawl_site(urls: &[&str])` che chiami `crawl_page` per ogni URL e collezioni i risultati.

3. Nel `main`, usa il runtime Tokio per eseguire `crawl_site` su un vettore di 3 URL fittizi.

**Suggerimento:** Usa `tokio::time::sleep(Duration::from_millis(100)).await` per simulare il ritardo di rete. Ricorda che `.await` va usato solo dentro funzioni `async`.
