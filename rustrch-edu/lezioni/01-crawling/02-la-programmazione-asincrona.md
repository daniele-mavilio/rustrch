## Teoria

La programmazione asincrona è un paradigma di programmazione che permette di eseguire operazioni in modo non bloccante. Questo significa che, mentre un'operazione è in attesa di completamento (ad esempio, la lettura di un file o una richiesta di rete), il programma può continuare a eseguire altre operazioni invece di rimanere in attesa. Questo approccio è particolarmente utile per le operazioni di input/output (I/O), che spesso richiedono tempi di attesa significativi rispetto alla velocità di elaborazione della CPU.

In Rust, la programmazione asincrona è supportata attraverso le keyword `async` e `await`. La keyword `async` viene utilizzata per definire una funzione asincrona, mentre `await` viene utilizzata per attendere il completamento di un'operazione asincrona. Questo modello permette di scrivere codice asincrono in modo simile al codice sincrono, rendendo il codice più leggibile e manutenibile.

Uno dei principali vantaggi della programmazione asincrona è la capacità di gestire un gran numero di operazioni I/O in modo efficiente. Ad esempio, in un motore di ricerca che deve esplorare migliaia di file, l'utilizzo di operazioni asincrone permette di leggere più file contemporaneamente, riducendo significativamente il tempo totale necessario per completare l'operazione.

## Esempio

Immagina di dover leggere il contenuto di dieci file di testo. In un approccio sincrono, il programma leggerebbe un file alla volta, attendendo il completamento della lettura di ogni file prima di passare al successivo. Questo approccio può essere inefficienti, soprattutto se i file sono di grandi dimensioni o si trovano su un disco lento.

In un approccio asincrono, invece, il programma può avviare la lettura di tutti i file contemporaneamente. Mentre un file viene letto, il programma può eseguire altre operazioni, come elaborare i dati già letti o avviare la lettura di altri file. Questo approccio permette di ridurre significativamente il tempo totale necessario per leggere tutti i file.

Ad esempio, supponiamo di avere tre file: `file1.txt`, `file2.txt` e `file3.txt`. In un approccio sincrono, il programma leggerebbe `file1.txt`, attenderebbe il completamento della lettura, poi leggerebbe `file2.txt`, attenderebbe il completamento della lettura, e infine leggerebbe `file3.txt`. In un approccio asincrono, il programma avvierebbe la lettura di tutti e tre i file contemporaneamente e attenderebbe il completamento di tutte le operazioni di lettura.

## Pseudocodice

```rust
// Definizione di una funzione asincrona per leggere un file
async fn leggi_file(percorso: &str) -> String {
    // Simula la lettura asincrona di un file
    let contenuto = leggi_contenuto_file(percorso).await;
    contenuto
}

// Funzione asincrona per leggere più file contemporaneamente
async fn leggi_multipli_file(percorsi: Vec<&str>) -> Vec<String> {
    // Crea un vettore di future per la lettura di ogni file
    let future_letture: Vec<_> = percorsi
        .into_iter()
        .map(|percorso| leggi_file(percorso))
        .collect();
    
    // Esegui tutte le future contemporaneamente
    let contenuti = join_all(future_letture).await;
    contenuti
}

// Funzione principale asincrona
#[tokio::main]
async fn main() {
    // Lista dei percorsi dei file da leggere
    let percorsi = vec!["file1.txt", "file2.txt", "file3.txt"];
    
    // Leggi tutti i file contemporaneamente
    let contenuti = leggi_multipli_file(percorsi).await;
    
    // Stampa il contenuto di ogni file
    for (i, contenuto) in contenuti.into_iter().enumerate() {
        println!("Contenuto del file {}: {}", i + 1, contenuto);
    }
}
```

## Risorse

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

## Esercizio

1. **Domanda di comprensione**: Qual è la differenza principale tra programmazione sincrona e asincrona?
2. **Domanda di comprensione**: Perché la programmazione asincrona è particolarmente utile per le operazioni di I/O?
3. **Domanda di comprensione**: Quali sono le keyword utilizzate in Rust per la programmazione asincrona?
4. **Domanda di comprensione**: Qual è il vantaggio principale dell'utilizzo della programmazione asincrona in un motore di ricerca?
5. **Domanda di comprensione**: Come viene gestito il completamento di un'operazione asincrona in Rust?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione asincrona che legge il contenuto di un file e restituisce il numero di righe.
- Scrivi uno pseudocodice per una funzione asincrona che legge il contenuto di più file e restituisce il numero totale di righe.