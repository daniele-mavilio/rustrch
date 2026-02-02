# L3.06: Runtime Async con Tokio

## Teoria

La programmazione asincrona in Rust necessita di un runtime per eseguire le funzioni async, poiché il linguaggio definisce solo come scriverle. Tokio è il runtime più utilizzato, offrendo un executor che schedula i futuri e un reattore che monitora eventi I/O come richieste di rete.

In codice sincrono, le operazioni bloccanti fermano il thread, limitando la scalabilità per molteplici I/O simultanee. Tokio usa multiplexing non bloccante: pochi thread (uno per core) eseguono task concorrenti. Quando un task attende I/O, viene sospeso e il runtime passa ad altri, risvegliandolo quando dati arrivano.

Per il motore di ricerca, Tokio è cruciale nel crawling parallelo e gestione query. Elimina la necessità di molti thread, evitando sprechi risorse e deadlock. Fornisce primitive sicure: canali, mutex async, timer.

Configurazioni runtime: single-thread semplice, multi-thread scalabile. Per I/O intenso, multi-thread con work-stealing è ideale. #[tokio::main] semplifica l'avvio, permettendo codice intuitivo che funziona in parallelo sottotraccia.

## Esempio

Immagina di costruire un semplice crawler web che deve scaricare pagine da più URL contemporaneamente. In un approccio sincrono, il programma scaricherebbe una pagina alla volta, attendendo che ogni richiesta completi prima di iniziare la successiva, causando lunghi tempi di attesa se un sito è lento. Con Tokio, puoi lanciare tutte le richieste in parallelo: definire una funzione async per scaricare una pagina, poi usare tokio::spawn per crearne istanze multiple che lavorano contemporaneamente.

Nel contesto del nostro motore di ricerca, pensando a un sistema che elabora query di ricerca ricevute via HTTP. Senza asincronia, il server servirebbe una richiesta alla volta, rendendo l'applicazione lenta per più utenti. Con Tokio, puoi gestire migliaia di richieste simultaneamente, scalando orizzontalmente senza aumentare threads. Questo è possibile grazie al runtime che gestisce automaticamente il passaggio tra task attivi e inattivi.

Durante lo sviluppo, l'uso di Tokio significa scrivere codice intuitivo: usa async/await come se fosse codice sequenziale, ma dietro le quinte tutto accade in concorrenza. Per misurare prestazioni, puoi cronometrare l'esecuzione totale con un approccio parallelizzato versus uno sequenziale, dimostrando come Tokio riduca drasticamente i tempi per operazioni I/O-bound.

## Pseudocodice

```
// Importa le crate necessarie: tokio per il runtime e futures per utilità asincrone
use tokio;
use futures;

// Definisce una funzione asincrona che simula il download di una pagina web
async fn download_page(url: &str) -> Result<String, Box<dyn std::error::Error>> {
    // In una implementazione reale, usa reqwest per fare richieste HTTP
    // Qui simuliamo un'attesa asincrona
    tokio::time::sleep(tokio::time::Duration::from_millis(100)).await;
    Ok(format!("Contenuto di {}", url))
}

// Funzione principale marcata con #[tokio::main] per abilitare il runtime
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Elenco di URL da elaborare
    let urls = vec!["https://example1.com", "https://example2.com", "https://example3.com"];

    // Usa iteratori per creare task asincroni per ogni URL
    let tasks: Vec<_> = urls.into_iter().map(|url| {
        // Spawn di ogni task in background
        tokio::spawn(async move { download_page(&url).await })
    }).collect();

    // Attende che tutti i task completino usando try_join_all
    let results = futures::future::try_join_all(tasks).await?;

    // Elabora i risultati di ogni download completato
    for result in results {
        println!("Scaricato: {}", result?);
    }

    Ok(())
}
```

## Risorse

- https://docs.rs/tokio/latest/tokio/
- https://tokio.rs/tokio/tutorial/
- https://doc.rust-lang.org/book/ch16-02-threads.html
- https://crates.io/crates/tokio

## Esercizio

Implementa un programma Rust che utilizzi Tokio per scaricare in parallelo il contenuto da cinque URL HTTP diversi. Per ogni URL, simula un ritardo casuale tra 100-500 ms per emulare richieste reali. Usa tokio::spawn per lanciare i task concorrenti e futures::future::try_join_all per sincronizzarli. Gestisci eventuali errori di rete restituendo un messaggio appropriato invece del contenuto. Misura e stampa il tempo totale di esecuzione per dimostrare il beneficio del parallelismo asincrono rispetto a un approccio sequenziale. Bonus: compara i tempi lanciando gli stessi URL in sequenza versus in parallelo.