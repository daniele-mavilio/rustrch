# Introduzione a Rust e perché usarlo per un motore di ricerca

## Teoria

Rust è un linguaggio di programmazione di sistema creato da Mozilla e rilasciato nella sua prima versione stabile nel 2015. Se provieni da Python o JavaScript, potresti chiederti: perché dovrei imparare un linguaggio così diverso? La risposta sta nelle garanzie uniche che Rust offre, particolarmente preziose quando si costruisce un motore di ricerca.

Un motore di ricerca deve gestire enormi quantità di dati: pagine web da scaricare, testi da indicizzare, vettori da confrontare. Tutto questo richiede velocità di esecuzione, efficienza nell'uso della memoria e affidabilità sotto carico. Python eccelle nella prototipazione rapida, ma quando si tratta di elaborare milioni di documenti, la differenza di prestazioni diventa significativa. Rust offre prestazioni paragonabili al C e al C++, ma con un sistema di tipi che previene interi classi di bug a tempo di compilazione.

Il concetto fondamentale di Rust è la **sicurezza della memoria senza garbage collector**. Mentre Python e JavaScript usano un garbage collector che periodicamente libera la memoria inutilizzata (causando pause imprevedibili), Rust garantisce la gestione corretta della memoria attraverso il suo sistema di ownership. Questo significa che il tuo motore di ricerca non avrà mai memory leak, use-after-free o data race, tutti problemi comuni nei software complessi scritti in C o C++.

Inoltre, Rust ha un ecosistema maturo per le operazioni che ci serviranno: programmazione asincrona con Tokio per il crawling web, SQLite per la persistenza dei dati, e librerie per il machine learning come ONNX Runtime. La comunità Rust è nota per la qualità della documentazione e degli strumenti di sviluppo, rendendo l'apprendimento più accessibile di quanto si potrebbe pensare.

## Esempio

Immagina di voler costruire un motore di ricerca locale che indicizza i siti web che visiti più spesso. Il flusso di lavoro è questo: un crawler scarica le pagine, un indicizzatore le analizza e le salva in un database, e un motore di ricerca permette di cercare tra i contenuti salvati.

In Python, il crawler potrebbe funzionare bene con poche pagine, ma rallentare drasticamente con migliaia di documenti. Il consumo di memoria crescerebbe in modo imprevedibile, e gestire la concorrenza con il GIL (Global Interpreter Lock) di Python sarebbe un limite reale. In Rust, possiamo scrivere un crawler asincrono che gestisce centinaia di connessioni simultanee con un consumo di memoria prevedibile e costante.

Il compilatore Rust ci aiuta attivamente durante lo sviluppo: se tentiamo di accedere a dati che sono già stati liberati, o di modificare una struttura dati da due thread contemporaneamente, il programma semplicemente non compila. Questo trasforma errori che in altri linguaggi scopriresti solo in produzione (spesso alle tre di notte) in errori di compilazione che risolvi alla scrivania.

## Pseudocodice

```rust
// Struttura concettuale del nostro motore di ricerca
// (NON compilabile - solo per illustrare l'architettura)

// fn main() {
//     // Fase 1: Crawling - scarica pagine dal web
//     // let crawler = crea_crawler(url_iniziali)
//     // let pagine = crawler.scarica_tutto()  // asincrono, parallelo
//
//     // Fase 2: Indicizzazione - analizza e salva
//     // let indice = crea_indice_invertito()
//     // per ogni pagina in pagine {
//     //     let tokens = tokenizza(pagina.testo)
//     //     indice.aggiungi(pagina.url, tokens)
//     // }
//
//     // Fase 3: Ricerca - trova risultati rilevanti
//     // let query = leggi_input_utente()
//     // let risultati = indice.cerca(query)  // usa BM25 per ranking
//     // mostra_risultati(risultati)
//
//     // Fase 4 (avanzata): Ricerca semantica con embedding ML
//     // let vettore_query = modello.genera_embedding(query)
//     // let risultati_semantici = vector_store.nearest_neighbors(vettore_query)
// }
```

## Risorse

- [The Rust Programming Language (Il Libro Ufficiale)](https://doc.rust-lang.org/book/)
- [Rust by Example - Impara con esempi pratici](https://doc.rust-lang.org/rust-by-example/)
- [Rust Playground - Prova codice Rust nel browser](https://play.rust-lang.org/)
- [Crates.io - Il registro dei pacchetti Rust](https://crates.io/)

## Esercizio

**Domanda**: Elenca tre vantaggi specifici di Rust rispetto a Python per la costruzione di un motore di ricerca. Per ciascun vantaggio, descrivi uno scenario concreto in cui la differenza sarebbe evidente.

**Traccia di soluzione**: Considera questi aspetti: (1) la gestione della memoria durante l'indicizzazione di milioni di documenti - Rust non ha garbage collector quindi nessuna pausa imprevedibile; (2) la concorrenza durante il crawling - Rust può gestire migliaia di connessioni asincrone senza il limite del GIL; (3) la sicurezza a tempo di compilazione - errori di accesso concorrente ai dati vengono catturati prima dell'esecuzione, evitando crash in produzione.
