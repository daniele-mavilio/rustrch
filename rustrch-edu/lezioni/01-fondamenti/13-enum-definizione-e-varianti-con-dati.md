# Enum: Definizione e Varianti con Dati

## Teoria

Gli enum in Rust sono molto più potenti dei semplici enumerazioni trovate in altri linguaggi. Mentre in C o Java un enum è essenzialmente un insieme di costanti numeriche, in Rust un enum può avere varianti che contengono dati associati. Questa caratteristica, combinata con il pattern matching, rende gli enum uno strumento espressivo per modellare dati che possono essere di diversi tipi o stati.

Un enum definisce un tipo che può avere diversi valori possibili, chiamati varianti. La sintassi base è `enum Nome { Variante1, Variante2, ... }`. La potenza di Rust emerge quando le varianti possono contenere dati: `enum Messaggio { Testo(String), Numero(i32), Coordinate { x: i32, y: i32 } }`. Qui abbiamo tre varianti, ciascuna con dati diversi: una contiene una String, una un i32, e l'ultima usa sintassi simile a una struct con campi nominati.

Questo approccio è chiamato "algebraic data type" e permette di modellare concetti complessi in modo type-safe. Invece di usare campi opzionali o valori speciali per rappresentare diversi stati, ogni variante rappresenta esplicitamente uno stato valido con i suoi dati specifici. Questo elimina intere classi di bug che si verificano in altri linguaggi quando si mischiano dati di stati diversi.

## Esempio

Immagina di modellare diversi tipi di messaggi in un'applicazione di chat. Potresti avere messaggi di testo, messaggi con allegati, messaggi di sistema, o messaggi di posizione geografica. Invece di creare una struct con tutti i campi opzionali (che permetterebbe stati invalidi come un messaggio che ha sia testo che coordinate), puoi usare un enum:

```rust
enum Messaggio {
    Testo { contenuto: String, mittente: String },
    Immagine { path: String, descrizione: String },
    Posizione { lat: f64, lon: f64 },
    Sistema { codice: u32, testo: String },
}
```

Ora ogni messaggio ha esattamente i dati necessari per il suo tipo. Il compilatore garantisce che non puoi accidentalmente accedere a `lat` su un messaggio di testo. Questo è molto più sicuro di avere una struct con tutti i campi opzionali dove la logica di validazione è responsabilità del programmatore.

## Pseudocodice

```rust
// Enum semplice senza dati (come in altri linguaggi)
enum Colore {
    Rosso,
    Verde,
    Blu,
}

// Enum con varianti che contengono dati
enum Messaggio {
    // Variante senza dati
    Quit,
    
    // Variante con dati come tuple struct
    Move(i32, i32),  // x, y
    Write(String),   // testo
    
    // Variante con dati come struct (campi nominati)
    ChangeColor {
        r: u8,
        g: u8,
        b: u8,
    },
}

// Creazione di istanze di enum
fn creazione_enum() {
    // Enum semplice
    let colore_primario = Colore::Rosso;
    
    // Enum con dati tuple
    let msg1 = Messaggio::Move(10, 20);
    let msg2 = Messaggio::Write(String::from("Ciao"));
    
    // Enum con dati struct
    let msg3 = Messaggio::ChangeColor {
        r: 255,
        g: 0,
        b: 0,
    };
    
    // Enum senza dati
    let msg4 = Messaggio::Quit;
}

// Esempio pratico: Gestione di eventi di input
enum EventoInput {
    // Pressione tasto
    TastoPremuto { codice: u32, shift: bool },
    
    // Movimento mouse
    MouseMosso { x: i32, y: i32 },
    
    // Click mouse
    MouseCliccato { x: i32, y: i32, pulsante: PulsanteMouse },
    
    // Scroll
    Scroll { delta_x: i32, delta_y: i32 },
}

enum PulsanteMouse {
    Sinistro,
    Destro,
    Centrale,
}

// Esempio: Risultato di parsing
enum RisultatoParsing<T> {
    Successo(T),
    Errore { riga: usize, messaggio: String },
}

// Implementare metodi su enum
impl Messaggio {
    // Metodo che elabora il messaggio
    fn elabora(&self) {
        match self {
            Messaggio::Quit => {
                println!("Richiesta di uscita");
            }
            Messaggio::Move(x, y) => {
                println!("Spostamento a ({}, {})", x, y);
            }
            Messaggio::Write(testo) => {
                println!("Scrittura: {}", testo);
            }
            Messaggio::ChangeColor { r, g, b } => {
                println!("Cambio colore a RGB({}, {}, {})", r, g, b);
            }
        }
    }
    
    // Metodo per controllare tipo
    fn is_quit(&self) -> bool {
        matches!(self, Messaggio::Quit)
    }
}

// Esempio: Stato di connessione
enum StatoConnessione {
    Disconnesso,
    ConnessioneInCorso { server: String, tentativo: u32 },
    Connesso { id_sessione: String, dal: std::time::Instant },
    Errore { codice: u32, descrizione: String },
}

impl StatoConnessione {
    fn descrizione(&self) -> String {
        match self {
            StatoConnessione::Disconnesso => 
                String::from("Non connesso"),
            StatoConnessione::ConnessioneInCorso { server, tentativo } => 
                format!("Connessione a {} (tentativo {})", server, tentativo),
            StatoConnessione::Connesso { id_sessione, .. } => 
                format!("Connesso (sessione: {})", id_sessione),
            StatoConnessione::Errore { codice, descrizione } => 
                format!("Errore {}: {}", codice, descrizione),
        }
    }
}

// Esempio pratico: Formati di documento
enum FormatoDocumento {
    TestoPlain,
    Markdown { versione: String },
    Html { doctype: String, strict: bool },
    Json { indentato: bool },
    Binario { schema_version: u32 },
}

impl FormatoDocumento {
    fn estensione(&self) -> &'static str {
        match self {
            FormatoDocumento::TestoPlain => "txt",
            FormatoDocumento::Markdown { .. } => "md",
            FormatoDocumento::Html { .. } => "html",
            FormatoDocumento::Json { .. } => "json",
            FormatoDocumento::Binario { .. } => "bin",
        }
    }
}
```

## Risorse

- [Enums - The Rust Book](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html)
- [Enum Variants with Data - Rust by Example](https://doc.rust-lang.org/rust-by-example/custom_types/enum.html)
- [Option and Result Enums](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html)

## Esercizio

Crea un enum `ComandoEditor` che modella diversi comandi di un editor di testo:
1. `Inserisci { testo: String, posizione: usize }` - inserisce testo a una posizione
2. `Cancella { inizio: usize, fine: usize }` - cancella un range
3. `Cerca { query: String }` - cerca una stringa
4. `Sostituisci { da: String, a: String }` - sostituisce testo
5. `Annulla` - comando per annullare

Poi scrivi una funzione `descrivi_comando` che accetta un `&ComandoEditor` e restituisce una descrizione testuale del comando.

**Traccia di soluzione:**
1. Definisci l'enum con le varianti appropriate
2. Usa `match` nella funzione descrivi_comando
3. Estrai i campi dalle varianti struct nelle arms del match
4. Restituisci String o &str con la descrizione
