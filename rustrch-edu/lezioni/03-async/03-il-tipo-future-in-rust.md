# Il Tipo Future in Rust

## Teoria

In Rust, il cuore della programmazione asincrona è il trait `Future`. Questo trait rappresenta un'operazione asincrona che potrebbe non essere completata immediatamente. A differenza di altri linguaggi dove le operazioni async partono automaticamente, in Rust le Future sono **lazy** (pigre): vengono create ma non eseguite finché qualcuno non le "polla" esplicitamente.

Il trait `Future` è definito nella standard library e ha una struttura essenziale:

```rust
pub trait Future {
    type Output;
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
}
```

Il metodo `poll` è il meccanismo chiave: quando viene chiamato, la Future controlla se l'operazione è completata. Se sì, restituisce `Poll::Ready(valore)`. Se no, restituisce `Poll::Pending` e si assicura di essere "risvegliata" (wake up) quando pronta. Questo meccanismo di polling permette a Rust di gestire migliaia di operazioni concorrenti senza bloccare thread, perché il runtime può decidere quando controllare lo stato di ciascuna operazione.

Un aspetto fondamentale è il tipo `Pin`: quando polliamo una Future, dobbiamo assicurarci che il suo indirizzo in memoria non cambi durante l'esecuzione. Questo è necessario perché le Future possono contenere riferimenti a se stesse (self-referential structs), e spostare l'oggetto in memoria renderebbe invalidi quei riferimenti.

## Esempio

Immagina di voler scaricare una pagina web. In Python, `requests.get()` blocca immediatamente il thread. In Rust, creare una Future è come preparare una richiesta senza inviarla:

```rust
// Questo crea solo la Future, NON esegue nulla!
let future = reqwest::get("https://example.com");

// La future esiste ma non ha fatto alcuna richiesta HTTP
// È solo una struttura dati che DESCRIBE cosa fare
```

La richiesta HTTP verrà effettuata solo quando qualcuno (tipicamente il runtime Tokio) chiama `poll()` su questa Future. Questo approccio lazy dà al programmatore controllo totale su quando e dove avviene il lavoro effettivo.

Quando Tokio esegue `poll()`, succede questo:
1. Se la connessione di rete è pronta, restituisce `Poll::Ready(risposta)`
2. Se deve aspettare, registra un "waker" e restituisce `Poll::Pending`
3. Quando i dati arrivano dalla rete, il waker notifica Tokio di richiamare `poll()`

## Pseudocodice

```rust
// Il trait Future definisce il contratto per tutte le operazioni async
pub trait Future {
    // Ogni Future produce un tipo di output specifico
    type Output;
    
    // Il metodo poll controlla se l'operazione è completata
    // Restituisce Poll::Ready(T) se finita, Poll::Pending se in corso
    fn poll(
        // Pin assicura che la Future non si sposti in memoria
        self: Pin<&mut Self>, 
        // Context contiene il "waker" per risvegliare la Future
        cx: &mut Context<'_>
    ) -> Poll<Self::Output>;
}

// Enum Poll rappresenta i due stati possibili
pub enum Poll<T> {
    // L'operazione è completata e ha prodotto un valore
    Ready(T),
    // L'operazione è ancora in corso, verrà controllata più tardi
    Pending,
}

// Esempio di implementazione manuale di una Future
struct DownloadFuture {
    // Stato interno che traccia il progresso
    url: String,
    stato: StatoDownload,
}

enum StatoDownload {
    Iniziale,      // Appena creata, nessuna richiesta fatta
    InCorso,       // Richiesta inviata, aspettando risposta
    Completato,    // Download finito
}

impl Future for DownloadFuture {
    type Output = Vec<u8>;
    
    fn poll(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        // Match sullo stato corrente
        match self.stato {
            // Se siamo allo stato iniziale, avviamo il download
            StatoDownload::Iniziale => {
                // Invia la richiesta HTTP (operazione non bloccante)
                self.stato = StatoDownload::InCorso;
                // Registra il waker per essere notificati quando pronti
                registra_waker(&self.url, cx.waker());
                // Diciamo al runtime che non siamo ancora pronti
                Poll::Pending
            }
            
            // Se il download è in corso, controlliamo se i dati sono arrivati
            StatoDownload::InCorso => {
                if dati_pronti(&self.url) {
                    // I dati sono arrivati! Cambiamo stato
                    self.stato = StatoDownload::Completato;
                    // Leggiamo i dati e restituiamoli
                    let dati = leggi_dati(&self.url);
                    Poll::Ready(dati)
                } else {
                    // Ancora in attesa, il waker ci risveglierà
                    Poll::Pending
                }
            }
            
            // Stato finale, non dovremmo mai essere qui
            StatoDownload::Completato => {
                panic!("Future già completata!")
            }
        }
    }
}

// Funzione helper per creare la Future (lazy!)
fn download(url: &str) -> DownloadFuture {
    // Solo creazione, NESSUN download reale avviene qui
    DownloadFuture {
        url: url.to_string(),
        stato: StatoDownload::Iniziale,
    }
}
```

## Risorse

- [The Rust Book - Async/Await](https://doc.rust-lang.org/book/ch17-01-futures-and-syntax.html)
- [Rust Async Book - The Future Trait](https://rust-lang.github.io/async-book/02_execution/02_future.html)
- [Rust By Example - Async/Await](https://doc.rust-lang.org/rust-by-example/std_misc/async_await.html)
- [Docs.rs - std::future::Future](https://doc.rust-lang.org/std/future/trait.Future.html)
- [Tokio Docs - Async in Depth](https://tokio.rs/tokio/topics/async)

## Esercizio

**Domanda:** Cosa stampa questo codice e perché?

```rust
async fn saluta() {
    println!("Ciao!");
}

fn main() {
    let future = saluta();
    println!("Future creata");
    // Nota: non stiamo eseguendo .await né usando un runtime!
}
```

**Traccia di soluzione:**

Il codice stampa solo "Future creata". La funzione `saluta()` è async, quindi quando la chiamiamo senza `.await`, creiamo solo una Future senza eseguirla. Per farla eseguire servirebbe:

```rust
// Dentro un async main con runtime Tokio:
tokio::runtime::Runtime::new().unwrap().block_on(async {
    saluta().await;  // Ora "Ciao!" viene stampato
});
```

Questo dimostra la natura **lazy** delle Future in Rust: la creazione e l'esecuzione sono due passi separati, a differenza di linguaggi come JavaScript dove le Promise iniziano immediatamente.
