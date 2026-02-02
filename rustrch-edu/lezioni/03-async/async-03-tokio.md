## Teoria

Il runtime Tokio è il cuore dell'ecosistema async di Rust, fornendo l'infrastruttura necessaria per eseguire futures in modo efficiente. Tokio non è solo una libreria, ma un intero stack che include scheduler, timer, e primitive di I/O asincrona. Quando chiami `await` su un futuro, stai essenzialmente cedendo il controllo al runtime Tokio, che può eseguire altri futures mentre aspetti.

Tokio offre diversi modi per eseguire codice async: `tokio::spawn` per task indipendenti, `tokio::join!` per aspettare molteplici futures in parallelo, e `tokio::select!` per scegliere il primo futuro che completa. La concorrenza diventa "gratuita" - non devi più pensare a thread o locking, ma solo a orchestrare futures.

Un aspetto cruciale è l'integrazione con l'I/O: Tokio fornisce wrapper asincroni per file, network, e timer. Questo significa che operazioni normalmente bloccanti come leggere da un socket diventano non-blocking, permettendo al server di scalare enormemente.

## Esempio

Per un server web semplice con Tokio:

```rust
use tokio::net::TcpListener;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let listener = TcpListener::bind("127.0.0.1:8080").await?;
    
    loop {
        let (socket, _) = listener.accept().await?;
        tokio::spawn(async move {
            handle_connection(socket).await;
        });
    }
}
```

Questo server può gestire migliaia di connessioni contemporaneamente senza bloccarsi.

## Pseudocodice

```rust
// Avviare il runtime Tokio
#[tokio::main] // macro che configura il runtime
async fn main() {
    println!("Runtime avviato");
    
    // Eseguire un task semplice
    let result = simple_task().await;
    println!("Risultato: {}", result);
}

// Definire un task asincrono
async fn simple_task() -> String {
    // Simulare lavoro asincrono
    tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
    "task completato".to_string()
}

// Usare spawn per task concorrenti
async fn concurrent_tasks() {
    // Lanciare due task indipendenti
    let handle1 = tokio::spawn(async {
        println!("Task 1 iniziato");
        tokio::time::sleep(tokio::time::Duration::from_secs(2)).await;
        "task 1 finito"
    });
    
    let handle2 = tokio::spawn(async {
        println!("Task 2 iniziato");
        tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
        "task 2 finito"
    });
    
    // Aspettare che entrambi finiscano
    let (res1, res2) = tokio::join!(handle1, handle2);
    println!("Risultati: {:?} e {:?}", res1, res2);
}

// Gestire I/O asincrona
async fn async_io_example() {
    // Leggere da un file in modo asincrono
    let contents = tokio::fs::read_to_string("file.txt").await?;
    println!("Contenuto: {}", contents);
    
    // Scrivere su network
    let mut stream = tokio::net::TcpStream::connect("127.0.0.1:8080").await?;
    stream.write_all(b"ciao").await?;
}
```

## Risorse

- [Tokio Documentation](https://docs.rs/tokio/latest/tokio/)
- [Async I/O in Rust](https://tokio.rs/tokio/tutorial/io)
- [Tokio Runtime Guide](https://tokio.rs/tokio/tutorial/shared-state)

## Esercizio

Crea un programma Tokio che:

1. Avvii un server TCP su porta 8080
2. Accetti connessioni multiple usando tokio::spawn
3. Per ogni connessione, legga dati dal client e risponda con l'echo
4. Gestisca la chiusura delle connessioni in modo pulito