# Struct: Definizione e Implementazione

## Teoria

Le struct (strutture) in Rust sono uno strumento fondamentale per organizzare i dati in modo logico e tipizzato. Una struct è un tipo composto che raggruppa più valori, possibilmente di tipi diversi, sotto un unico nome. A differenza delle tuple, dove gli elementi sono accessibili solo per posizione, le struct usano nomi espliciti per ogni campo, rendendo il codice più leggibile e auto-documentante.

In Rust esistono tre tipi di struct: le struct con campi nominati (il tipo più comune), le tuple struct (simili a tuple ma con un nome di tipo) e le unit struct (senza campi, usate principalmente per implementare trait). Questa sezione si concentra sulle struct con campi nominati, che sono quelle più utilizzate nella programmazione quotidiana.

Quando definisci una struct, stai creando un nuovo tipo personalizzato che puoi usare ovunque nel tuo programma. I campi di una struct possono essere di qualsiasi tipo, inclusi altri struct, array, slice, o tipi generici. Questo permette di modellare dati complessi in modo gerarchico e organizzato. Le struct in Rust sono simili a classi in altri linguaggi, ma senza l'ereditarietà - Rust preferisce la composizione tramite struct annidate.

## Esempio

Immagina di costruire un sistema per gestire libri in una biblioteca. Ogni libro ha un titolo, un autore, un numero di pagine e un anno di pubblicazione. Invece di usare quattro variabili separate, puoi creare una struct `Libro` che raggruppa queste informazioni:

```rust
struct Libro {
    titolo: String,
    autore: String,
    pagine: u32,
    anno: u16,
}
```

Ora puoi creare istanze di `Libro` e accedere ai campi usando la dot notation: `libro.titolo`, `libro.autore`, ecc. Questo rende il codice molto più chiaro rispetto a gestire quattro variabili separate. Inoltre, puoi passare un intero `Libro` a una funzione invece di passare quattro parametri separati, migliorando la leggibilità e riducendo la probabilità di errori.

## Pseudocodice

```rust
// Definizione di una struct con campi nominati
struct Utente {
    username: String,
    email: String,
    attivo: bool,
    contatore_accessi: u64,
}

// Creazione di istanze
fn creazione_struct() {
    // Istanza mutable
    let mut utente1 = Utente {
        username: String::from("mario_rossi"),
        email: String::from("mario@example.com"),
        attivo: true,
        contatore_accessi: 1,
    };
    
    // Modifica di campi (richiede mut)
    utente1.email = String::from("mario.nuovo@example.com");
    utente1.contatore_accessi += 1;
}

// Field init shorthand: quando variabile ha stesso nome del campo
fn creazione_con_shorthand() {
    let username = String::from("luigi_verdi");
    let email = String::from("luigi@example.com");
    
    // Non serve ripetere username: username
    let utente = Utente {
        username,  // Equivalente a username: username
        email,     // Equivalente a email: email
        attivo: true,
        contatore_accessi: 0,
    };
}

// Struct update syntax: creare nuova istanza basata su esistente
fn update_syntax() {
    let utente1 = Utente {
        username: String::from("mario"),
        email: String::from("mario@example.com"),
        attivo: true,
        contatore_accessi: 5,
    };
    
    // Crea utente2 cambiando solo email, copiando il resto da utente1
    // ATTENZIONE: utente1 non può più essere usato se campi String vengono spostati
    let utente2 = Utente {
        email: String::from("altro@example.com"),
        ..utente1  // Copia i campi rimanenti da utente1
    };
    
    // utente1.username non è più valido (spostato in utente2)
    // utente1.email non è più valido (spostato in utente2)
    // utente1.attivo e utente1.contatore_accessi sono ancora validi (tipi Copy)
}

// Tuple struct: struct senza nomi di campi, solo tipi
struct Colore(i32, i32, i32);  // RGB
struct Punto(f64, f64, f64);   // Coordinate 3D

fn tuple_struct() {
    let nero = Colore(0, 0, 0);
    let origine = Punto(0.0, 0.0, 0.0);
    
    // Accesso per indice come tuple
    let r = nero.0;
    let x = origine.0;
}

// Unit struct: struct senza campi
struct SempreUguale;

fn unit_struct() {
    let _soggetto = SempreUguale;
    // Usata principalmente per implementare trait senza stato
}

// Struct con campi pubblici (in un modulo)
mod biblioteca {
    pub struct Libro {
        pub titolo: String,    // Pubblico: accessibile dall'esterno
        autore: String,         // Privato: accessibile solo nel modulo
        pub pagine: u32,
    }
    
    impl Libro {
        pub fn nuovo(titolo: &str, autore: &str) -> Libro {
            Libro {
                titolo: titolo.to_string(),
                autore: autore.to_string(),
                pagine: 0,
            }
        }
        
        pub fn autore(&self) -> &str {
            &self.autore  // Getter per campo privato
        }
    }
}

// Esempio pratico
struct DocumentoWeb {
    url: String,
    titolo: String,
    contenuto: String,
    dimensione_bytes: usize,
}

fn analizza_documento(doc: &DocumentoWeb) {
    println!("Analizzando: {}", doc.titolo);
    println!("URL: {}", doc.url);
    println!("Dimensione: {} bytes", doc.dimensione_bytes);
    println!("Lunghezza contenuto: {} caratteri", doc.contenuto.len());
}
```

## Risorse

- [Structs - The Rust Book](https://doc.rust-lang.org/book/ch05-00-structs.html)
- [Struct Definition - Rust by Example](https://doc.rust-lang.org/rust-by-example/custom_types/structs.html)
- [Tuple Structs and Unit Structs](https://doc.rust-lang.org/book/ch05-01-defining-structs.html#tuple-structs-without-named-fields-to-create-different-types)

## Esercizio

Crea una struct `Punto2D` che rappresenta un punto nel piano cartesiano con coordinate x e y (entrambe f64). Poi scrivi una funzione `distanza_dall_origine` che calcola la distanza euclidea del punto dall'origine (0, 0).

**Traccia di soluzione:**
1. Definisci la struct con campi x e y di tipo f64
2. Crea un'istanza di esempio con coordinate (3.0, 4.0)
3. Implementa la formula della distanza: sqrt(x² + y²)
4. Usa il metodo `sqrt()` disponibile su f64
5. La distanza dovrebbe essere 5.0 per il punto (3.0, 4.0)
