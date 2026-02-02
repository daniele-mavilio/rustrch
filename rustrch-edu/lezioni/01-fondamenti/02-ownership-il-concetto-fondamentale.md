# Ownership: il concetto fondamentale

## Teoria

L'ownership è il cuore di Rust, il meccanismo che lo distingue da qualsiasi altro linguaggio di programmazione. Se capisci l'ownership, hai capito Rust. Se vieni da Python o JavaScript, questo concetto sarà inizialmente estraneo, perché quei linguaggi nascondono completamente la gestione della memoria dietro un garbage collector.

In Rust, ogni valore ha esattamente un **proprietario** (owner). Quando il proprietario esce dallo scope (l'ambito di visibilità in cui è definito), il valore viene automaticamente deallocato. Non serve chiamare `free()` come in C, né aspettare che un garbage collector si attivi come in Python. La memoria viene liberata in modo deterministico, nel punto esatto in cui il proprietario cessa di esistere.

Le tre regole dell'ownership sono semplici da enunciare ma profonde nelle conseguenze: primo, ogni valore in Rust ha una variabile che è il suo proprietario; secondo, ci può essere un solo proprietario alla volta; terzo, quando il proprietario esce dallo scope, il valore viene eliminato (si dice che viene "droppato").

Perché questo è importante per un motore di ricerca? Quando il nostro crawler scarica una pagina web, il contenuto HTML viene allocato in memoria. Con l'ownership, sappiamo esattamente quando quella memoria verrà liberata: quando la variabile che contiene l'HTML esce dallo scope. Non c'è rischio di memory leak, non c'è rischio che qualcun altro acceda a memoria già liberata. In un sistema che elabora migliaia di pagine, questa garanzia è fondamentale per la stabilità.

Il compilatore Rust verifica le regole dell'ownership a tempo di compilazione. Se scrivi codice che viola queste regole, il programma non compila. Questo può sembrare frustrante all'inizio, ma significa che un'intera categoria di bug semplicemente non può esistere nel tuo programma. Il borrow checker, il componente del compilatore che verifica queste regole, diventerà il tuo migliore alleato.

## Esempio

Immagina di avere una variabile `contenuto_pagina` che contiene il testo HTML scaricato da un sito web. In Python, potresti passare questa stringa a più funzioni senza pensarci: Python tiene un contatore di riferimenti e libera la memoria quando nessuno la usa più.

In Rust, quando passi `contenuto_pagina` a una funzione, il valore si **muove**: la funzione diventa il nuovo proprietario, e la variabile originale non è più utilizzabile. Questo è il "move semantics" che vedremo nella prossima sezione. Se provi a usare la variabile dopo averla passata, il compilatore ti avvisa con un errore chiaro.

Questo comportamento ti costringe a pensare esplicitamente al flusso dei dati nel tuo programma. Chi possiede cosa? Chi è responsabile della deallocazione? Domande che in Python non ti poni mai, ma che in un sistema complesso come un motore di ricerca fanno la differenza tra un software stabile e uno che crasha sotto carico.

## Pseudocodice

```rust
// Esempio concettuale di ownership (NON compilabile)

// fn scarica_pagina(url: Stringa) -> Stringa {
//     // La funzione crea un nuovo valore: il contenuto HTML
//     // let html = http_get(url)  // html è il proprietario del contenuto
//     // return html  // il proprietario viene trasferito al chiamante
// }
//
// fn elabora() {
//     // contenuto diventa proprietario del valore restituito
//     // let contenuto = scarica_pagina("https://esempio.com")
//
//     // Passiamo contenuto a indicizza: il valore si MUOVE
//     // indicizza(contenuto)  // contenuto trasferito a indicizza
//
//     // ERRORE: contenuto non è più utilizzabile qui!
//     // println(contenuto)  // il compilatore blocca questa riga
//
//     // Soluzione: usare borrowing (prossime lezioni)
//     // oppure clonare il valore prima di passarlo
// }
//
// fn indicizza(testo: Stringa) {
//     // testo è il proprietario del valore
//     // ... elaborazione ...
// }  // <- testo esce dallo scope, la memoria viene liberata qui
```

## Risorse

- [The Rust Book - Understanding Ownership](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
- [Rust by Example - Ownership and Moves](https://doc.rust-lang.org/rust-by-example/scope/move.html)
- [Rust Reference - Memory Model](https://doc.rust-lang.org/reference/memory-model.html)

## Esercizio

**Domanda**: Dato il seguente scenario, identifica dove avviene il trasferimento di ownership e dove il compilatore segnalerebbe un errore. Abbiamo una variabile `documento` che contiene il testo di una pagina web. La passiamo alla funzione `calcola_lunghezza()`, poi proviamo a passarla a `salva_nel_database()`. Cosa succede e come lo risolveresti?

**Traccia di soluzione**: Dopo la chiamata a `calcola_lunghezza(documento)`, il valore si è mosso dentro la funzione. La variabile `documento` non è più valida, quindi `salva_nel_database(documento)` causerebbe un errore di compilazione. Due soluzioni possibili: (1) far restituire il valore da `calcola_lunghezza` e riassegnarlo, oppure (2) usare un riferimento (`&documento`) per prestare il valore senza trasferirlo. La seconda soluzione (borrowing) è quella idiomatica in Rust.
