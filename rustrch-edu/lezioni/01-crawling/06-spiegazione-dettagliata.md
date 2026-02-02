## Teoria

La spiegazione dettagliata dello pseudocodice del crawler è essenziale per comprendere appieno come funziona il processo di crawling e come le varie funzioni interagiscono tra loro. In questa sezione, esamineremo ogni riga dello pseudocodice per capire il ruolo di ogni funzione e come contribuisce al funzionamento complessivo del crawler.

Il crawler è progettato per esplorare ricorsivamente le directory di un file system, leggere i metadati dei file e salvare queste informazioni in un database. Questo processo è fondamentale per costruire un motore di ricerca efficace, poiché permette di raccogliere le informazioni necessarie per indicizzare e ricercare i file in modo efficiente.

Esaminando lo pseudocodice, possiamo identificare le principali funzioni del crawler e comprendere come queste funzioni lavorano insieme per raggiungere l'obiettivo desiderato. Ogni funzione ha un ruolo specifico e contribuisce al funzionamento complessivo del crawler.

## Esempio

Supponiamo di voler esplorare la directory `/home/documenti` e raccogliere i metadati di tutti i file contenuti al suo interno. Il crawler inizierà esplorando la directory radice e leggerà i metadati di ogni file trovato. Se il crawler incontra una sottodirectory, esplorerà ricorsivamente anche quella directory, leggendo i metadati di tutti i file al suo interno.

Ad esempio, se la directory `/home/documenti` contiene una sottodirectory chiamata `lavoro` con all'interno un file chiamato `relazione.txt`, il crawler esplorerà la directory `lavoro` e leggerà i metadati del file `relazione.txt`. Queste informazioni verranno poi salvate in un database per essere utilizzate nelle fasi successive di indicizzazione e ricerca.

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

1. **Domanda di comprensione**: Qual è il ruolo della funzione `esplora_directory` nello pseudocodice del crawler?
2. **Domanda di comprensione**: Come viene gestita la ricorsione nella funzione `esplora_directory`?
3. **Domanda di comprensione**: Quali informazioni vengono lette dalla funzione `leggi_metadati`?
4. **Domanda di comprensione**: Qual è lo scopo della funzione `salva_metadati`?
5. **Domanda di comprensione**: Come viene avviato il processo di crawling nella funzione `main`?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione che esplora una directory e stampa il nome di tutti i file contenuti al suo interno, inclusi quelli nelle sottodirectory.
- Scrivi uno pseudocodice per una funzione che legge i metadati di un file e li stampa a video.