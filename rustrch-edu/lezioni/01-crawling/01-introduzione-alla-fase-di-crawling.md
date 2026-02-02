## Teoria

Il crawling è il processo attraverso il quale un motore di ricerca esplora e raccoglie informazioni da una fonte di dati. Nel contesto di un motore di ricerca per file system, il crawling consiste nell'esplorare le directory e i file presenti su un disco per raccogliere informazioni utili che verranno successivamente indicizzate e rese ricercabili. Questo processo è fondamentale perché permette al motore di ricerca di conoscere l'esistenza e le caratteristiche dei file che dovrà gestire.

Immagina di voler creare un motore di ricerca che permetta di trovare rapidamente documenti all'interno della tua cartella personale. Senza un processo di crawling, il motore di ricerca non saprebbe nemmeno quali file esistono, figuriamoci dove si trovano o cosa contengono. Il crawling è quindi il primo passo essenziale per costruire un motore di ricerca efficace.

Durante il crawling, il motore di ricerca raccoglie metadati sui file, come il nome, la dimensione, la data di modifica e i permessi. Questi metadati sono informazioni preziose che verranno utilizzate nelle fasi successive del processo di ricerca. Ad esempio, la data di modifica può essere utilizzata per ordinare i risultati di ricerca in base alla loro rilevanza temporale, mentre la dimensione del file può essere utile per filtrare i risultati in base a criteri specifici.

## Esempio

Supponiamo di voler creare un motore di ricerca per la cartella `/home/documenti`. Il processo di crawling inizierà dalla radice di questa cartella e esplorerà ricorsivamente tutte le sottodirectory e i file contenuti al suo interno. Per ogni file trovato, il crawler raccoglierà informazioni come il nome del file, la sua dimensione, la data di ultima modifica e i permessi di accesso.

Ad esempio, se all'interno della cartella `/home/documenti` è presente una sottocartella chiamata `lavoro` con all'interno un file chiamato `relazione.txt`, il crawler registrerà queste informazioni:

- Nome del file: `relazione.txt`
- Percorso completo: `/home/documenti/lavoro/relazione.txt`
- Dimensione: 1024 byte
- Data di modifica: 2023-10-15 14:30:00
- Permessi: rw-r--r--

Queste informazioni verranno poi salvate in un database o in una struttura dati apposita, che verrà utilizzata nelle fasi successive di indicizzazione e ricerca.

## Pseudocodice

```rust
// Definizione di una funzione per esplorare una directory
fn esplora_directory(percorso: &str) {
    // Leggi il contenuto della directory
    let contenuto_directory = leggi_directory(percorso);
    
    // Itera su ogni elemento della directory
    for elemento in contenuto_directory {
        // Se l'elemento è un file, salva i suoi metadati
        if elemento.e_un_file() {
            let metadati = leggi_metadati(elemento.percorso);
            salva_metadati(metadati);
        }
        // Se l'elemento è una directory, esplora ricorsivamente
        else if elemento.e_una_directory() {
            esplora_directory(elemento.percorso);
        }
    }
}

// Funzione per leggere i metadati di un file
fn leggi_metadati(percorso: &str) -> Metadati {
    // Restituisci una struttura con i metadati del file
    Metadati {
        nome: "relazione.txt",
        percorso: "/home/documenti/lavoro/relazione.txt",
        dimensione: 1024,
        data_modifica: "2023-10-15 14:30:00",
        permessi: "rw-r--r--"
    }
}

// Funzione per salvare i metadati in un database
fn salva_metadati(metadati: Metadati) {
    // Salva i metadati nel database
}
```

## Risorse

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

## Esercizio

1. **Domanda di comprensione**: Perché il crawling è una fase essenziale per la costruzione di un motore di ricerca?
2. **Domanda di comprensione**: Quali informazioni vengono raccolte durante il processo di crawling?
3. **Domanda di comprensione**: Cosa significa esplorare una directory in modo ricorsivo?
4. **Domanda di comprensione**: Qual è la differenza tra un percorso assoluto e un percorso relativo?
5. **Domanda di comprensione**: Perché è importante raccogliere i metadati dei file durante il crawling?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione che esplora una directory e stampa il nome di tutti i file contenuti al suo interno, inclusi quelli nelle sottodirectory.
- Scrivi uno pseudocodice per una funzione che raccoglie i metadati di un file e li salva in una struttura dati.