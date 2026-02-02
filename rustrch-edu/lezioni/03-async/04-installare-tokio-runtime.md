# Installare Tokio Runtime

## Teoria

Hai mai provato a usare l'elettricità senza una presa di corrente? È esattamente quello che succede quando scrivi codice `async` in Rust senza un runtime. Le keyword `async` e `await` da sole non fanno nulla: servono solo a marcare le funzioni come "potenzialmente asincrone". Per farle davvero girare, serve un **runtime asincrono**, un componente che gestisce l'esecuzione delle operazioni concorrenti, decide quale task eseguire e quando.

**Tokio** è il runtime asincrono più popolare e maturo dell'ecosistema Rust. È come il motore di un'auto: non vedi la tua macchina muoversi senza di esso. Tokio fornisce un event loop che controlla continuamente quali task sono pronti per essere eseguiti, gestisce le operazioni di I/O (rete, file system) in modo non bloccante e offre strumenti per creare task paralleli, canali di comunicazione e timer. Senza Tokio (o un runtime alternativo come async-std), il tuo codice async semplicemente non verrebbe mai eseguito.

## Esempio

Immagina di voler costruire un web crawler per il tuo motore di ricerca. Hai scritto funzioni `async` per scaricare pagine web, ma quando provi a compilarle, il compilatore si lamenta che non c'è un runtime per eseguirle. Questo è il momento in cui entra in gioco Tokio.

L'installazione richiede due passaggi fondamentali. Primo, aggiungi la dipendenza nel tuo `Cargo.toml`. Tokio offre diverse feature che puoi abilitare a seconda delle necessità: `rt-multi-thread` per il runtime multi-thread (ideale per applicazioni I/O-bound), `macros` per le macro utili come `#[tokio::main]`, e `rt` per il runtime di base. Secondo, annoti la funzione `main` con `#[tokio::main]`, che trasforma automaticamente il tuo punto di ingresso in una funzione asincrona gestita da Tokio.

## Pseudocodice

```rust
// File: Cargo.toml
// Aggiungi questa dipendenza nella sezione [dependencies]
// tokio = { version = "1.0", features = ["full"] }
// opzione "full" include tutto, ma pesa di più

// Alternativa più leggera - abilita solo quello che ti serve:
// tokio = { version = "1.0", features = ["rt-multi-thread", "macros"] }

// File: src/main.rs

// Questa macro trasforma main in una funzione asincrona
// Tokio crea automaticamente il runtime e lo esegue
#[tokio::main]
async fn main() {
    // Ora puoi usare .await dentro main!
    println!("Avvio del crawler...");
    
    // Chiamata a funzione async - .await la esegue
    let risultato = scarica_pagina("https://esempio.com").await;
    
    // Stampa il risultato
    match risultato {
        Ok(contenuto) => println!("Scaricati {} bytes", contenuto.len()),
        Err(e) => println!("Errore: {}", e),
    }
}

// Funzione async che simula un download HTTP
// Il tipo di ritorno è Result perché può fallire
async fn scarica_pagina(url: &str) -> Result<String, String> {
    // In un caso reale, useresti reqwest o simili
    // Qui simuliamo un'operazione async con un delay
    
    // tokio::time::sleep crea un timer asincrono
    // .await sospende questa funzione senza bloccare il thread
    tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
    
    // Restituisce dati fittizi
    Ok(format!("Contenuto di {}", url))
}

// Senza #[tokio::main], dovresti scrivere manualmente:
// fn main() {
//     // Crea il runtime manualmente
//     let rt = tokio::runtime::Runtime::new().unwrap();
//     
//     // Blocca e esegue la funzione async
//     rt.block_on(async {
//         // qui il codice async
//     });
// }
```

## Risorse

- [Tokio - Getting Started](https://tokio.rs/tokio/tutorial)
- [Tokio Documentation - Runtime](https://docs.rs/tokio/latest/tokio/runtime/)
- [Async Book - Select a Runtime](https://rust-lang.github.io/async-book/08_executors/00_intro.html)
- [Crates.io - Tokio](https://crates.io/crates/tokio)
- [Tokio Features Explained](https://docs.rs/tokio/latest/tokio/#feature-flags)

## Esercizio

**Problema**: Crea un nuovo progetto Cargo chiamato `tokio-demo` e configuralo per usare Tokio. Scrivi una funzione `main` asincrona che stampi "Runtime attivo!" dopo aver atteso 500 millisecondi.

**Traccia di soluzione**:

1. Esegui `cargo new tokio-demo` per creare il progetto
2. Modifica `Cargo.toml` aggiungendo: `tokio = { version = "1", features = ["rt-multi-thread", "macros", "time"] }`
3. In `src/main.rs`, aggiungi `#[tokio::main]` sopra la funzione `main`
4. Cambia `main` in `async fn main()`
5. Usa `tokio::time::sleep(Duration::from_millis(500)).await` per l'attesa
6. Infine, stampa il messaggio con `println!`

**Verifica**: Se compili con `cargo run` e vedi il messaggio dopo mezzo secondo, hai configurato correttamente Tokio!
