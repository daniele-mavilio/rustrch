## Teoria

Immagina una squadra di lavoratori asincroni che devono condividere dati in tempo reale durante una costruzione digitale. Mentre gli await e le future gestiscono il flusso temporale dei singoli compiti, i canali rappresentano le linee di comunicazione tra attività concorrenti. In Rust, grazie alla libreria Tokio, disponiamo di canali efficienti e sicuri per la comunicazione tra task asincroni.

Un canale in Tokio è un tipo di dato che permette di inviare messaggi da un produttore a uno o più consumatori, garantendo che i dati vengano trasferiti correttamente attraverso i diversi task. Il cuore del meccanismo è basato su due concetti chiave: il sender e il receiver. Il sender viene clonato e distribuito ai produttori, mentre il receiver rimane unico per il consumatore principale.

Quando parliamo di sicurezza nell'invio di messaggi attraverso canali, ci riferiamo direttamente al sistema di ownership di Rust. Ogni messaggio inviato attraverso un canale deve implementare il trait Send, assicurando che possa essere trasferito in sicurezza tra thread diversi. Inoltre, il tipo dei messaggi deve essere 'static, garantendo che non contenga riferimenti con durata limitata che potrebbero diventare dangling.

I canali multipart (mpsc) permettono a molteplici sender di inviare messaggi a un singolo receiver, ideale per pattern producer-consumer dove diversi task alimentano una coda di lavoro condivisa. Questo approccio è particolarmente efficace per distribuire compiti computazionali o per raccogliere risultati da elaborazioni parallele.

La gestione degli errori nei canali è cruciale. Quando un receiver viene droppato, tutti i sender ricevono un errore, segnalando che la comunicazione è terminata. Viceversa, se tutti i sender vengono droppati, il receiver riceve automaticamente None, indicando che non ci saranno più messaggi. Questo meccanismo permette di gestire la chiusura elegante delle comunicazioni asincrone.

Nel nostro motore di ricerca, i canali risulteranno essenziali per coordinare le attività di crawling, indicizzazione e ricerca, assicurando che i dati fluiscono correttamente tra le diverse fasi del processo senza conflitti di concorrenza.

## Esempio

Un caso d'uso tipico coinvolge un web crawler che deve scaricare pagine web in parallelo. Invece di avere ogni task che salva direttamente nel database - rischiando conflitti - possiamo usare un canale per inondare un singolo task "writer" dei contenuti scaricati.

Immaginiamo un canale dove i task crawler inviano oggetti PageContent (contenenti URL, testo e timestamp), mentre un task database writer rimane in ascolto sui messaggi e li processa sequenzialmente. Questo pattern garantisce che l'accesso al database sia serializzato, eliminando i problemi di concorrenza tipici delle scritture simultanee.

I sender vengono clonati per ogni task crawler, che possono così inviare messaggi indipendentemente. Il receiver rimane gestito dal task writer, che itera su un loop asincrono per elaborare ogni messaggio ricevuto. Se un crawler trova una pagina problematica, può inviare un messaggio di errore centimetro il canale senza interrompere gli altri.

Questo approccio è vantaggioso anche per il bilanciamento del carico: se alcuni crawler sono più veloci, inviano più messaggi; il writer elabora tutto alla stessa velocità, creando una natural cache/bufferizzazione che livella i picchi di lavoro.

Inoltre, possiamo usare canali per coordinare la distribuzione di lavoro dai task superiori. Ad esempio, un task di pianificazione può suddividere un elenco di URL da visitare e distribuirli ai crawler attraverso un canale, assicurando che ogni worker abbia sempre qualcosa da fare senza contese.

## Pseudocodice

```rust
// Creazione del canale multipart (molti sender, un receiver)
let (tx, mut rx) = tokio::sync::mpsc::channel::<PageContent>(32);  // Buffer size 32

// Fork di task crawler che condividono lo stesso sender
for i in 0..num_crawlers {
    let tx_clone = tx.clone();  // Il sender si clona facilmente
    tokio::spawn(async move {
        // Simula crawling di pagine
        loop {
            let content = crawl_next_page().await?;
            tx_clone.send(content).await?;  // Invio asincrono del messaggio
        }
    });
}

// Task singolo che riceve e processa
tokio::spawn(async move {
    while let Some(page) = rx.recv().await {
        // Elaborazione sequenziale dei messaggi ricevuti
        save_to_database(page.url, page.content).await?;
    }
    // Quando tutti sender sono droppati, rx.recv() torna None
});

// Attesa che tutti i sender vengano droppati implicitamente alla fine degli scope

```

## Risorse

- https://docs.rs/tokio/1.0.0/tokio/sync/mpsc/index.html - Documentazione ufficiale dei canali mpsc in Tokio
- https://doc.rust-lang.org/book/ch16-02-message-passing.html - Spiegazione dei messaggi in Rust dalla Guida Ufficiale
- https://tokio.rs/tokio/tutorial/channels - Tutorial sui canali nella documentazione di Tokio
- https://doc.rust-lang.org/rust-by-example/std_misc/channels.html - Esempi di canali nel Rust by Example

## Esercizio

Implementa una semplice applicazione producer-consumer usando canali Tokio: crea un task produttore che genera numeri sequenziali e li invia a un canale, e un task consumatore che li riceve e ne calcola la somma. Gestisci la chiusura elegante quando il produttore ha finito.

Traccia di soluzione: usa mpsc::channel, clona il sender per il task produttore, tieni il receiver nel task consumatore. Nel produttore, invia numeri da 1 a 100 con intervallo, poi chiudi. Nel consumatore, accumula la somma e stampala alla fine.