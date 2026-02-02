# Borrowing: riferimenti immutabili

## Teoria

Nella sezione precedente abbiamo visto che passare un valore a una funzione ne trasferisce la proprietà (move). Ma spesso una funzione ha solo bisogno di **leggere** un dato, non di possederlo. Sarebbe scomodo dover trasferire e restituire la proprietà ogni volta. Rust risolve questo problema con il **borrowing**: la possibilità di creare riferimenti a un valore senza prenderne la proprietà.

Un riferimento immutabile si crea con l'operatore `&`. Quando scrivi `&variabile`, stai creando un "prestito" del valore: la funzione che riceve il riferimento può leggere il dato, ma non può modificarlo né diventarne proprietaria. Il proprietario originale mantiene la proprietà e potrà continuare a usare il valore dopo che il prestito è terminato.

La regola fondamentale del borrowing immutabile è: **puoi avere quanti riferimenti immutabili vuoi contemporaneamente**. Questo ha senso intuitivamente: se nessuno modifica il dato, non c'è pericolo nel leggerlo da più punti del codice. È come un libro in biblioteca che può essere consultato da più persone, purché nessuno ci scriva sopra.

Per il nostro motore di ricerca, il borrowing è fondamentale. Immagina la funzione che calcola il punteggio BM25 di un documento: ha bisogno di leggere il testo del documento e la query dell'utente, ma non ha bisogno di possedere nessuno dei due. Passando riferimenti immutabili, evitiamo copie inutili e manteniamo la proprietà dei dati dove serve.

Il borrow checker del compilatore verifica staticamente che tutti i riferimenti siano validi. Un riferimento non può mai sopravvivere al dato a cui punta (questo concetto è legato ai lifetime, che vedremo più avanti). Se il compilatore non riesce a provare che il riferimento è sicuro, rifiuta il codice. Nessun dangling pointer, nessun use-after-free, garantito a tempo di compilazione.

I riferimenti in Rust sono sempre validi. A differenza dei puntatori in C che possono puntare a memoria deallocata, un riferimento Rust è garantito puntare a dati vivi. Questa garanzia è ciò che rende Rust "memory safe" senza garbage collector.

## Esempio

Consideriamo il nostro motore di ricerca. Abbiamo una funzione `conta_occorrenze` che conta quante volte un termine appare nel testo di un documento. Questa funzione non ha bisogno di possedere né il testo né il termine: deve solo leggerli.

Senza borrowing, dovremmo muovere il testo nella funzione e poi farcelo restituire, un pattern scomodo e innaturale. Con il borrowing, passiamo semplicemente `&testo` e `&termine`. La funzione legge i dati, calcola il risultato, e i dati originali restano disponibili per altre operazioni.

Questo pattern si ripete ovunque nel motore di ricerca: la funzione di tokenizzazione legge il testo (`&String`), la funzione di ranking legge i documenti (`&Documento`), la funzione di rendering legge i risultati (`&Vec<Risultato>`). Il borrowing immutabile è il modo predefinito di passare dati in Rust quando non serve modificarli.

## Pseudocodice

```rust
// Borrowing immutabile nel motore di ricerca (NON compilabile)

// fn conta_occorrenze(testo: &Stringa, termine: &Stringa) -> Intero {
//     // testo e termine sono riferimenti: possiamo leggerli
//     // ma non possiamo modificarli né prenderne la proprietà
//     // let contatore = 0
//     // per ogni parola in testo.dividi_per_spazi() {
//     //     se parola == termine {
//     //         contatore += 1
//     //     }
//     // }
//     // return contatore
// }
//
// fn main() {
//     // let documento = Stringa::da("rust è veloce e rust è sicuro")
//     // let termine = Stringa::da("rust")
//
//     // Passiamo riferimenti: la proprietà resta a main()
//     // let occorrenze = conta_occorrenze(&documento, &termine)
//
//     // documento e termine sono ancora utilizzabili qui!
//     // stampa("Il documento contiene", occorrenze, "occorrenze")
//     // stampa("Testo originale:", documento)  // OK!
//
//     // Possiamo creare più riferimenti contemporaneamente
//     // let rif1 = &documento
//     // let rif2 = &documento
//     // let rif3 = &documento  // tutto valido: sono tutti immutabili
// }
```

## Risorse

- [The Rust Book - Riferimenti e Borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
- [Rust by Example - Borrowing](https://doc.rust-lang.org/rust-by-example/scope/borrow.html)
- [Rust Reference - Reference Types](https://doc.rust-lang.org/reference/types/pointer.html#references--and-mut-)

## Esercizio

**Domanda**: Scrivi lo pseudocodice per una funzione `calcola_bm25` che riceve un riferimento a un documento e un riferimento a una query, e restituisce un punteggio numerico. Dopo aver chiamato la funzione, verifica che il documento e la query siano ancora utilizzabili. Quanti riferimenti immutabili puoi creare contemporaneamente allo stesso documento?

**Traccia di soluzione**: La funzione avrà firma `calcola_bm25(doc: &Documento, query: &Stringa) -> f64`. Dopo la chiamata, sia `doc` che `query` restano validi perché abbiamo passato solo riferimenti. Puoi creare un numero illimitato di riferimenti immutabili allo stesso documento, purché non esista nessun riferimento mutabile attivo. Questo è il principio "molti lettori, nessun scrittore" del borrow checker.
