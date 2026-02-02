## Teoria

Lo pseudocodice è uno strumento fondamentale per la progettazione di algoritmi e programmi. Si tratta di una rappresentazione semplificata del codice che utilizza un linguaggio naturale e strutture di controllo simili a quelle dei linguaggi di programmazione, ma senza la sintassi specifica di un linguaggio particolare. Lo pseudocodice è utile per comunicare idee algoritmiche in modo chiaro e conciso, senza dover affrontare i dettagli implementativi specifici di un linguaggio di programmazione.

Nel contesto della progettazione di un crawler per un motore di ricerca, lo pseudocodice ci permette di definire le principali funzionalità del crawler in modo astratto, concentrandoci sulla logica di base senza doverci preoccupare dei dettagli di implementazione in Rust. Questo approccio è particolarmente utile per pianificare e discutere la struttura del crawler con altri sviluppatori o stakeholder.

Il crawler che stiamo progettando dovrà esplorare ricorsivamente le directory di un file system, leggere i metadati dei file e salvare queste informazioni in una struttura dati o in un database. Lo pseudocodice ci aiuterà a definire le principali funzioni del crawler e a comprendere come queste funzioni interagiranno tra loro per raggiungere l'obiettivo desiderato.

## Esempio

Supponiamo di voler progettare un crawler che esplori la directory `/home/documenti` e raccolga i metadati di tutti i file contenuti al suo interno, inclusi quelli nelle sottodirectory. Il crawler dovrà leggere i metadati di ogni file, come il nome, la dimensione, la data di modifica e i permessi di accesso, e salvare queste informazioni in un database.

Per raggiungere questo obiettivo, possiamo definire le seguenti funzioni principali:

1. **esplora_directory**: Una funzione che esplora ricorsivamente una directory e i suoi contenuti.
2. **leggi_metadati**: Una funzione che legge i metadati di un file.
3. **salva_metadati**: Una funzione che salva i metadati di un file in un database.

Queste funzioni interagiranno tra loro per esplorare il file system, leggere i metadati dei file e salvarli nel database.

## Pseudocodice

```rust
// Funzione principale per esplorare una directory
fn esplora_directory(percorso: &str) {
    // Leggi il contenuto della directory
    let contenuto_directory = leggi_directory(percorso);
    
    // Itera su ogni elemento della directory
    for elemento in contenuto_directory {
        // Se l'elemento è un file, leggi e salva i suoi metadati
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
    // Leggi i metadati del file
    let metadati = fs::metadata(percorso);
    
    // Restituisci una struttura con i metadati del file
    Metadati {
        nome: percorso.to_string(),
        dimensione: metadati.len(),
        data_modifica: metadati.modified().into(),
        permessi: metadati.permissions(),
    }
}

// Funzione per salvare i metadati in un database
fn salva_metadati(metadati: Metadati) {
    // Salva i metadati nel database
    database.insert(metadati);
}

// Funzione principale
fn main() {
    // Percorso della directory da esplorare
    let percorso_directory = "/home/documenti";
    
    // Esplora la directory
    esplora_directory(percorso_directory);
}
```

## Risorse

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

## Esercizio

1. **Domanda di comprensione**: Qual è lo scopo principale dello pseudocodice nella progettazione di algoritmi?
2. **Domanda di comprensione**: Quali sono le principali funzioni definite nello pseudocodice del crawler?
3. **Domanda di comprensione**: Perché è utile utilizzare lo pseudocodice per progettare un crawler?
4. **Domanda di comprensione**: Qual è la differenza tra una funzione sincrona e una funzione asincrona nello pseudocodice?
5. **Domanda di comprensione**: Come viene gestita la ricorsione nello pseudocodice del crawler?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione che esplora una directory e stampa il nome di tutti i file contenuti al suo interno, inclusi quelli nelle sottodirectory.
- Scrivi uno pseudocodice per una funzione che legge i metadati di un file e li stampa a video.