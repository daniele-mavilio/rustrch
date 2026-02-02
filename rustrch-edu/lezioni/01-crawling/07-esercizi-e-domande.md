## Teoria

Gli esercizi e le domande di comprensione sono strumenti fondamentali per consolidare le conoscenze acquisite durante lo studio di un nuovo argomento. Attraverso gli esercizi pratici, è possibile applicare i concetti teorici appresi e verificare la propria comprensione degli argomenti trattati. Le domande di comprensione, invece, permettono di valutare la propria capacità di ricordare e spiegare i concetti chiave.

In questa sezione, presenteremo una serie di domande di comprensione e esercizi pratici relativi al processo di crawling e alla programmazione asincrona in Rust. Questi esercizi sono progettati per aiutare a consolidare le conoscenze acquisite e per prepararsi alle sfide pratiche che si incontreranno nello sviluppo di un motore di ricerca.

Gli esercizi pratici includono la scrittura di pseudocodice per funzioni che esplorano directory, leggono metadati e gestiscono errori. Questi esercizi sono progettati per essere completati utilizzando le conoscenze acquisite nelle sezioni precedenti e per applicare i concetti teorici in contesti pratici.

## Esempio

Supponiamo di voler scrivere una funzione che esplora una directory e stampa il nome di tutti i file contenuti al suo interno, inclusi quelli nelle sottodirectory. Per completare questo esercizio, è necessario applicare i concetti di ricorsione e gestione dei percorsi appresi nelle sezioni precedenti.

Ad esempio, possiamo definire una funzione `esplora_e_stampa` che prende un percorso di directory come input e stampa il nome di tutti i file contenuti al suo interno. Questa funzione utilizzerà la ricorsione per esplorare le sottodirectory e stamperà il nome di ogni file trovato.

## Pseudocodice

```rust
// Funzione per esplorare una directory e stampare i nomi dei file
fn esplora_e_stampa(percorso: &str) {
    // Leggi il contenuto della directory
    let contenuto_directory = leggi_directory(percorso);
    
    // Itera su ogni elemento della directory
    for elemento in contenuto_directory {
        // Se l'elemento è un file, stampa il suo nome
        if elemento.e_un_file() {
            println!("{}", elemento.nome);
        }
        // Se l'elemento è una directory, esplora ricorsivamente
        else if elemento.e_una_directory() {
            esplora_e_stampa(elemento.percorso);
        }
    }
}

// Funzione per leggere i metadati di un file e stamparli
fn leggi_e_stampa_metadati(percorso: &str) {
    // Leggi i metadati del file
    let metadati = fs::metadata(percorso);
    
    // Stampa i metadati del file
    println!("Nome: {}", percorso);
    println!("Dimensione: {} byte", metadati.len());
    println!("Data di modifica: {:?}", metadati.modified());
    println!("Permessi: {:?}", metadati.permissions());
}
```

## Risorse

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

## Esercizio

1. **Domanda di comprensione**: Qual è lo scopo principale del processo di crawling in un motore di ricerca?
2. **Domanda di comprensione**: Perché è importante utilizzare la programmazione asincrona per le operazioni di I/O?
3. **Domanda di comprensione**: Quali sono le principali funzioni definite nello pseudocodice del crawler?
4. **Domanda di comprensione**: Come viene gestita la ricorsione nello pseudocodice del crawler?
5. **Domanda di comprensione**: Quali informazioni vengono lette dalla funzione `leggi_metadati`?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione che esplora una directory e stampa il nome di tutti i file contenuti al suo interno, inclusi quelli nelle sottodirectory.
- Scrivi uno pseudocodice per una funzione che legge i metadati di un file e li stampa a video.