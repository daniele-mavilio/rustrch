# Borrowing: riferimenti mutabili e regole del borrow checker

## Teoria

Abbiamo visto che i riferimenti immutabili (`&T`) permettono di leggere un dato senza prenderne la proprietà, e che possiamo averne quanti ne vogliamo contemporaneamente. Ma cosa succede quando una funzione ha bisogno di **modificare** un dato? Entra in gioco il riferimento mutabile (`&mut T`).

Un riferimento mutabile permette di leggere e scrivere il dato a cui punta. Si crea con `&mut variabile`, e la variabile originale deve essere stata dichiarata come mutabile con `let mut`. A differenza dei riferimenti immutabili, i riferimenti mutabili hanno una restrizione fondamentale: **può esistere un solo riferimento mutabile a un dato alla volta, e non può coesistere con riferimenti immutabili**.

Questa regola può sembrare restrittiva, ma è ciò che elimina i data race a tempo di compilazione. Un data race si verifica quando due parti del codice accedono allo stesso dato contemporaneamente e almeno una lo modifica. In C++ o Java, i data race sono bug insidiosi che si manifestano solo sotto carico, in modo non deterministico. In Rust, sono impossibili: il compilatore rifiuta qualsiasi codice che potrebbe causarli.

Le regole del borrow checker si riassumono così: in qualsiasi momento, per un dato valore puoi avere **o** un riferimento mutabile, **oppure** un numero qualsiasi di riferimenti immutabili, ma **mai** entrambi. Inoltre, ogni riferimento deve essere valido (non puntare a dati deallocati).

Nel nostro motore di ricerca, questa regola si applica concretamente. Immagina di avere un indice invertito (la struttura dati centrale del motore) che deve essere sia consultato durante le ricerche sia aggiornato quando arrivano nuovi documenti. Non puoi avere contemporaneamente un riferimento mutabile (per aggiornare) e riferimenti immutabili (per cercare). Devi strutturare il codice in modo che lettura e scrittura siano separate nel tempo. Questo porta naturalmente a un design più sicuro e più facile da ragionare.

Il borrow checker analizza il flusso del codice e determina dove inizia e finisce ciascun prestito. Un riferimento termina all'ultimo punto in cui viene utilizzato (Non-Lexical Lifetimes, NLL), non necessariamente alla fine del blocco. Questo rende il sistema più flessibile di quanto sembri a prima vista.

## Esempio

Consideriamo la costruzione dell'indice invertito del nostro motore di ricerca. Abbiamo una struttura `Indice` che contiene una mappa da termini a liste di documenti. Quando indicizziamo un nuovo documento, dobbiamo modificare la struttura: serve un riferimento mutabile. Quando cerchiamo un termine, dobbiamo solo leggerla: basta un riferimento immutabile.

Il pattern corretto è: prima completiamo tutte le operazioni di scrittura (indicizzazione), poi passiamo a quelle di lettura (ricerca). Se provassimo a cercare nell'indice mentre lo stiamo ancora aggiornando, il compilatore rifiuterebbe il codice. Questo ci protegge da uno scenario reale e pericoloso: leggere risultati parziali da un indice in fase di aggiornamento.

In pratica, spesso usiamo strutture dati come `RwLock` (Read-Write Lock) che permettono accesso concorrente in lettura ma esclusivo in scrittura, rispettando a livello di runtime le stesse regole che il borrow checker impone a livello di compilazione.

## Pseudocodice

```rust
// Riferimenti mutabili nel motore di ricerca (NON compilabile)

// fn aggiungi_documento(indice: &mut Indice, doc: &Documento) {
//     // indice è un riferimento mutabile: possiamo modificarlo
//     // per ogni termine in tokenizza(&doc.testo) {
//     //     indice.mappa.inserisci(termine, doc.id)
//     // }
// }
//
// fn cerca(indice: &Indice, query: &Stringa) -> Lista<Risultato> {
//     // indice è un riferimento immutabile: solo lettura
//     // let termini = tokenizza(query)
//     // let risultati = indice.mappa.cerca(termini)
//     // return risultati
// }
//
// fn main() {
//     // let mut indice = Indice::nuovo()
//     // let doc1 = Documento::nuovo("Rust è fantastico")
//     // let doc2 = Documento::nuovo("Rust per motori di ricerca")
//
//     // Fase di scrittura: riferimento mutabile
//     // aggiungi_documento(&mut indice, &doc1)
//     // aggiungi_documento(&mut indice, &doc2)
//
//     // Fase di lettura: riferimento immutabile
//     // let risultati = cerca(&indice, &"Rust".a_stringa())
//
//     // ERRORE: non si può avere &mut e & contemporaneamente
//     // let rif_lettura = &indice
//     // aggiungi_documento(&mut indice, &doc1)  // ERRORE!
//     // usa(rif_lettura)
// }
```

## Risorse

- [The Rust Book - Mutable References](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html#mutable-references)
- [Rust by Example - Mutability](https://doc.rust-lang.org/rust-by-example/scope/borrow/mut.html)
- [Non-Lexical Lifetimes (RFC)](https://doc.rust-lang.org/edition-guide/rust-2018/ownership-and-lifetimes/non-lexical-lifetimes.html)

## Esercizio

**Domanda**: Hai un `Vec<Documento>` mutabile chiamato `archivio`. Vuoi (1) aggiungere un nuovo documento all'archivio e (2) stampare il contenuto del primo documento. In quale ordine devi fare queste operazioni per evitare conflitti con il borrow checker? Scrivi lo pseudocodice e spiega perché funziona.

**Traccia di soluzione**: Devi prima ottenere il riferimento immutabile al primo documento e usarlo (stamparlo), poi aggiungere il nuovo documento con `&mut`. Oppure viceversa: prima aggiungi, poi leggi. L'importante è non avere `&archivio[0]` (immutabile) e `&mut archivio` (mutabile) attivi contemporaneamente. Con NLL, se usi il riferimento immutabile prima di quello mutabile, il compilatore vede che il prestito immutabile è terminato e accetta il codice.
