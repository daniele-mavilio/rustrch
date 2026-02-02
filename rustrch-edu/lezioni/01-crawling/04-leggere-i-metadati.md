## Teoria

I metadati dei file sono informazioni che descrivono le caratteristiche di un file, come il nome, la dimensione, la data di creazione, la data di modifica e i permessi di accesso. Queste informazioni sono essenziali per un motore di ricerca, poiché permettono di filtrare e ordinare i risultati in base a criteri specifici. Ad esempio, un utente potrebbe voler cercare solo i file modificati negli ultimi sette giorni o i file con una dimensione superiore a un certo limite.

In Rust, i metadati dei file possono essere letti utilizzando il modulo `std::fs` della libreria standard. Questo modulo fornisce funzioni per leggere i metadati di un file, come `metadata` e `symlink_metadata`. La funzione `metadata` restituisce una struttura `Metadata` che contiene informazioni dettagliate sul file, come la dimensione, la data di modifica e i permessi di accesso.

La lettura dei metadati è un'operazione relativamente veloce, poiché non richiede la lettura del contenuto del file. Tuttavia, è importante gestire correttamente gli errori che possono verificarsi durante la lettura dei metadati, come l'accesso a file inesistenti o la mancanza di permessi di lettura.

## Esempio

Supponiamo di voler leggere i metadati del file `/home/utente/documenti/relazione.txt`. Utilizzando la funzione `metadata` del modulo `std::fs`, possiamo ottenere informazioni dettagliate sul file, come la sua dimensione, la data di modifica e i permessi di accesso.

Ad esempio, possiamo utilizzare il seguente codice per leggere i metadati del file:

```rust
use std::fs;

fn main() {
    let percorso = "/home/utente/documenti/relazione.txt";
    let metadati = fs::metadata(percorso).unwrap();
    
    println!("Dimensione: {} byte", metadati.len());
    println!("Data di modifica: {:?}", metadati.modified().unwrap());
    println!("Permessi: {:?}", metadati.permissions());
}
```

Questo codice legge i metadati del file e stampa la dimensione, la data di modifica e i permessi di accesso. La funzione `unwrap` viene utilizzata per gestire gli errori in modo semplice, ma in un'applicazione reale è consigliabile utilizzare una gestione degli errori più robusta.

## Pseudocodice

```rust
// Funzione per leggere i metadati di un file
fn leggi_metadati(percorso: &str) -> Result<Metadati, Errore> {
    // Leggi i metadati del file
    let metadati = fs::metadata(percorso)?;
    
    // Crea una struttura Metadati con le informazioni lette
    let metadati_file = Metadati {
        nome: percorso.to_string(),
        dimensione: metadati.len(),
        data_modifica: metadati.modified()?.into(),
        permessi: metadati.permissions(),
    };
    
    // Restituisci i metadati
    Ok(metadati_file)
}

// Funzione per stampare i metadati di un file
fn stampa_metadati(percorso: &str) {
    // Leggi i metadati del file
    match leggi_metadati(percorso) {
        Ok(metadati) => {
            println!("Nome: {}", metadati.nome);
            println!("Dimensione: {} byte", metadati.dimensione);
            println!("Data di modifica: {:?}", metadati.data_modifica);
            println!("Permessi: {:?}", metadati.permessi);
        }
        Err(e) => {
            println!("Errore nella lettura dei metadati: {}", e);
        }
    }
}

// Funzione principale
fn main() {
    let percorso = "/home/utente/documenti/relazione.txt";
    stampa_metadati(percorso);
}
```

## Risorse

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

## Esercizio

1. **Domanda di comprensione**: Quali informazioni possono essere ottenute dai metadati di un file?
2. **Domanda di comprensione**: Perché è importante leggere i metadati dei file in un motore di ricerca?
3. **Domanda di comprensione**: Quali funzioni del modulo `std::fs` possono essere utilizzate per leggere i metadati di un file?
4. **Domanda di comprensione**: Qual è la differenza tra `metadata` e `symlink_metadata`?
5. **Domanda di comprensione**: Perché è importante gestire gli errori durante la lettura dei metadati?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione che legge i metadati di un file e restituisce una struttura con le informazioni lette.
- Scrivi uno pseudocodice per una funzione che legge i metadati di tutti i file in una directory e stampa le informazioni lette.