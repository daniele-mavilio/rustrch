# Moduli e Visibilità: Organizzare il Codice

## Teoria

Man mano che i programmi crescono, diventa essenziale organizzare il codice in unità logiche. I moduli in Rust permettono di raggruppare funzioni, struct, trait, e altri item in namespace separati, controllando quali di essi sono accessibili dall'esterno. Questo meccanismo aiuta a mantenere il codice organizzato, riduce le collisioni di nomi, e permette di nascondere i dettagli di implementazione attraverso l'incapsulamento.

In Rust, la visibilità di default è privata: tutti gli item sono accessibili solo all'interno del modulo dove sono definiti. Per renderli pubblici, si usa la keyword `pub`. La visibilità può essere controllata granularmente: `pub` rende visibile ovunque, `pub(crate)` lo rende visibile solo all'interno del crate, `pub(super)` al modulo genitore, e `pub(in path)` a un modulo specifico.

La struttura dei moduli può essere definita inline con la keyword `mod` seguita da un blocco, oppure in file separati. Quando dichiari `mod nome;`, Rust cerca il contenuto del modulo in `nome.rs` (nella stessa directory) o in `nome/mod.rs` (in una sottodirectory). Questa flessibilità permette di scegliere l'organizzazione più adatta alle dimensioni del progetto.

## Esempio

Immagina un motore di ricerca con diversi componenti: crawling, indicizzazione, ricerca, e persistenza. Senza moduli, tutto sarebbe nel global namespace, causando confusione e collisioni di nomi:

```rust
// motore_ricerca.rs
mod crawler {
    pub fn fetch_url(url: &str) -> Result<String, Error> { ... }
}

mod indicizzatore {
    pub fn aggiungi_documento(doc: Documento) { ... }
}

mod ricerca {
    pub fn cerca(query: &str) -> Vec<Risultato> { ... }
}
```

Ora ogni componente ha il proprio namespace e possiamo chiamare `crawler::fetch_url()` o `ricerca::cerca()` senza ambiguità.

## Pseudocodice

```rust
// File: lib.rs (o main.rs)
// Dichiarazione di un modulo inline
mod utilities {
    // Visibilità private (default)
    fn helper_privato() {
        println!("Solo dentro utilities");
    }
    
    // Visibilità pubblica
    pub fn helper_pubblico() {
        println!("Accessibile dall'esterno");
        helper_privato();  // OK: stesso modulo
    }
    
    // Struct con campi privati e pubblici
    pub struct Configurazione {
        pub host: String,     // Campo pubblico
        porta: u16,           // Campo privato
    }
    
    impl Configurazione {
        pub fn nuovo(host: &str, porta: u16) -> Self {
            Configurazione {
                host: host.to_string(),
                porta,
            }
        }
        
        pub fn porta(&self) -> u16 {
            self.porta  // Getter per campo privato
        }
    }
}

// Uso del modulo
fn uso_modulo() {
    // utilities::helper_privato();  // ERRORE: privato
    utilities::helper_pubblico();   // OK: pubblico
    
    let config = utilities::Configurazione::nuovo("localhost", 8080);
    println!("Host: {}", config.host);    // OK: campo pubblico
    // println!("Porta: {}", config.porta);  // ERRORE: campo privato
    println!("Porta: {}", config.porta()); // OK: metodo pubblico
}

// Moduli annidati
mod motore_ricerca {
    // Modulo pubblico
    pub mod crawler {
        pub fn fetch(url: &str) -> String {
            format!("Contenuto di {}", url)
        }
    }
    
    // Modulo privato
    mod indice {
        pub fn aggiungi(doc: &str) {
            println!("Indicizzato: {}", doc);
        }
    }
    
    // Pubblica funzione che usa il modulo privato
    pub fn indicizza(doc: &str) {
        indice::aggiungi(doc);
    }
}

// Uso moduli annidati
fn uso_annidati() {
    let contenuto = motore_ricerca::crawler::fetch("https://example.com");
    motore_ricerca::indicizza(&contenuto);
    // motore_ricerca::indice::aggiungi(...);  // ERRORE: modulo privato
}

// Visibilità relativa
mod genitore {
    pub fn funzione_genitore() {}
    
    mod figlio {
        // Visibile solo nel modulo genitore
        pub(super) fn funzione_super() {
            // Può chiamare funzione_genitore()
        }
        
        // Visibile solo in questo crate
        pub(crate) fn funzione_crate() {}
    }
}

// Ri-esportazione con pub use
mod interno {
    pub struct Struttura {}
    pub fn funzione() {}
}

// Ri-esporta per semplificare l'API pubblica
pub use interno::Struttura;
pub use interno::funzione;

// Ora gli utenti possono usare:
// use crate::Struttura;  // invece di crate::interno::Struttura

// Organizzazione con file separati
// In lib.rs:
// mod database;  // Carica da database.rs o database/mod.rs

// In database.rs:
// pub struct Connessione { ... }
// pub fn connetti() -> Connessione { ... }

// Esempio pratico: Organizzazione motore di ricerca
// File: motore/crawler.rs
mod crawler {
    use std::collections::HashSet;
    
    pub struct Crawler {
        url_visitati: HashSet<String>,
    }
    
    impl Crawler {
        pub fn nuovo() -> Self {
            Crawler {
                url_visitati: HashSet::new(),
            }
        }
        
        pub fn crawl(&mut self, url: &str) -> Option<String> {
            if self.url_visitati.contains(url) {
                return None;
            }
            self.url_visitati.insert(url.to_string());
            
            // Simulazione fetch
            Some(format!("Contenuto di {}", url))
        }
        
        // Metodo privato
        fn parse_html(&self, html: &str) -> Vec<String> {
            // Estrae link dal HTML
            vec![]
        }
    }
}

// File: motore/indice.rs
mod indice {
    use std::collections::HashMap;
    
    pub struct IndiceInvertito {
        mappa: HashMap<String, Vec<u64>>,
    }
    
    impl IndiceInvertito {
        pub fn nuovo() -> Self {
            IndiceInvertito {
                mappa: HashMap::new(),
            }
        }
        
        pub fn aggiungi(&mut self, parola: String, doc_id: u64) {
            self.mappa
                .entry(parola)
                .or_insert_with(Vec::new)
                .push(doc_id);
        }
        
        pub fn cerca(&self, parola: &str) -> Option<&Vec<u64>> {
            self.mappa.get(parola)
        }
    }
}

// File: motore/mod.rs (definisce il modulo motore)
mod motore_completo {
    // Pubblica i sottomoduli
    pub mod crawler;
    pub mod indice;
    
    // Ri-esporta i tipi principali
    pub use crawler::Crawler;
    pub use indice::IndiceInvertito;
    
    // Funzione di convenienza
    pub fn crea_motore() -> (Crawler, IndiceInvertito) {
        (Crawler::nuovo(), IndiceInvertito::nuovo())
    }
}

// Uso esterno
// use motore_completo::{Crawler, IndiceInvertito, crea_motore};
```

## Risorse

- [Modules - The Rust Book](https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html)
- [Modules and Visibility](https://doc.rust-lang.org/rust-by-example/mod.html)
- [Visibility and Privacy](https://doc.rust-lang.org/reference/visibility-and-privacy.html)

## Esercizio

Crea una struttura di moduli per una libreria di calcolo statistico:

1. Modulo principale `statistica` con:
   - Sottomodulo `media` (pubblico) con funzioni per media, mediana, moda
   - Sottomodulo `varianza` (pubblico) con funzioni per varianza e deviazione standard
   - Sottomodulo `utils` (privato) con funzioni helper condivise

2. Ogni funzione nel modulo `media` deve usare una funzione helper da `utils`

3. Esporta solo `media::calcola_media` e `varianza::calcola_varianza` direttamente dal modulo `statistica`

**Traccia di soluzione:**
1. Crea un file `statistica.rs` o directory `statistica/`
2. In `statistica/mod.rs` o all'inizio del file, definisci i sottomoduli
3. In `statistica/utils.rs`, crea funzioni helper private (senza pub)
4. In `statistica/media.rs`, usa `use super::utils::nome_helper`
5. Ri-esporta con `pub use media::calcola_media;` nel modulo principale
