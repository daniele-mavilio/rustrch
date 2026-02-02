# Pattern Matching con match

## Teoria

Il pattern matching è una delle caratteristiche più potenti di Rust, permettendo di confrontare valori contro pattern e eseguire codice diverso a seconda del match. L'espressione `match` è esaustiva, il che significa che deve coprire tutti i casi possibili. Questo garantisce che non ci siano casi "dimenticati" che potrebbero causare comportamenti imprevisti.

Un `match` funziona valutando un'espressione e confrontandola con una serie di "arms" (bracci). Ogni arm ha un pattern e un blocco di codice. Quando un pattern matcha il valore, il corrispondente codice viene eseguito. I pattern possono essere letterali, nomi di variabili, wildcard, e possono includere condizioni aggiuntive (guardie).

La potenza del pattern matching emerge quando si lavora con enum, tuple e struct. Puoi destrutturare valori complessi nei loro componenti direttamente nel pattern, accedendo ai campi in modo elegante. Questo meccanismo è fondamentale per lavorare con `Option` e `Result`, permettendo di gestire i diversi casi in modo type-safe e leggibile.

## Esempio

Immagina di gestire comandi utente in un'applicazione. Invece di una serie di `if-else` che controllano stringhe, puoi usare un enum con `match`:

```rust
enum Comando {
    Saluta { nome: String },
    Esci,
    Aiuto,
}

match comando {
    Comando::Saluta { nome } => println!("Ciao, {}!", nome),
    Comando::Esci => println!("Arrivederci!"),
    Comando::Aiuto => println!("Comandi disponibili: ..."),
}
```

Questo è molto più chiaro di `if comando == "saluta"` perché il compilatore verifica che tutti i casi siano gestiti. Se aggiungi una nuova variante al enum, il compilatore ti avviserà che il match non è esaustivo.

## Pseudocodice

```rust
// Match base su valori
fn match_valori(x: i32) {
    match x {
        1 => println!("Uno"),
        2 => println!("Due"),
        3 => println!("Tre"),
        _ => println!("Altro"),  // Wildcard: matcha tutto il resto
    }
}

// Match su enum
enum Messaggio {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn elabora_messaggio(msg: Messaggio) {
    match msg {
        // Pattern semplice
        Messaggio::Quit => {
            println!("Uscita richiesta");
        }
        
        // Destructuring di struct-like variant
        Messaggio::Move { x, y } => {
            println!("Spostamento a ({}, {})", x, y);
        }
        
        // Destructuring di tuple-like variant
        Messaggio::Write(testo) => {
            println!("Scrittura: {}", testo);
        }
        
        // Destructuring completo
        Messaggio::ChangeColor(r, g, b) => {
            println!("Cambio colore: RGB({}, {}, {})", r, g, b);
        }
    }
}

// Match con guardie
fn match_con_guardie(numero: Option<i32>) {
    match numero {
        Some(n) if n < 0 => println!("Negativo: {}", n),
        Some(n) if n > 0 => println!("Positivo: {}", n),
        Some(0) => println!("Zero"),
        None => println!("Nessun numero"),
        _ => println!("Altro"),  // Necessario per esaustività
    }
}

// Match su tuple
fn coordinata_quadrante(punto: (i32, i32)) -> &'static str {
    match punto {
        (0, 0) => "Origine",
        (x, 0) => &format!("Asse X in {}", x),  // Qualsiasi y=0, x diverso da 0
        (0, y) => &format!("Asse Y in {}", y),  // Qualsiasi x=0, y diverso da 0
        (x, y) if x > 0 && y > 0 => "Primo quadrante",
        (x, y) if x < 0 && y > 0 => "Secondo quadrante",
        (x, y) if x < 0 && y < 0 => "Terzo quadrante",
        (x, y) if x > 0 && y < 0 => "Quarto quadrante",
        _ => "Impossibile",  // Dovrebbe essere coperto dai casi precedenti
    }
}

// Match con @ binding
fn match_con_binding(x: i32) {
    match x {
        n @ 1..=10 => println!("Numero tra 1 e 10: {}", n),
        n @ 11..=20 => println!("Numero tra 11 e 20: {}", n),
        n => println!("Altro numero: {}", n),
    }
}

// Destructuring di struct
struct Punto {
    x: i32,
    y: i32,
}

fn analizza_punto(p: Punto) {
    match p {
        Punto { x: 0, y: 0 } => println!("Nell'origine"),
        Punto { x: 0, y } => println!("Sull'asse Y in {}", y),
        Punto { x, y: 0 } => println!("Sull'asse X in {}", x),
        Punto { x, y } => println!("In ({}, {})", x, y),
    }
}

// Match esaustivo su Option
fn somma_options(a: Option<i32>, b: Option<i32>) -> Option<i32> {
    match (a, b) {
        (Some(x), Some(y)) => Some(x + y),
        (Some(x), None) => Some(x),
        (None, Some(y)) => Some(y),
        (None, None) => None,
    }
}

// Ignorare valori con _
fn ignora_valori(tupla: (i32, i32, i32)) {
    match tupla {
        (primo, _, terzo) => {
            println!("Primo: {}, Terzo: {}", primo, terzo);
            // Il secondo valore è ignorato
        }
    }
}

// Match su riferimenti
fn match_riferimenti(x: &Option<i32>) {
    match x {
        Some(valore) => println!("Ha valore: {}", valore),
        None => println!("Nessun valore"),
    }
}

// Esempio pratico: Parsing di comandi
enum Comando {
    Naviga(String),
    Cerca { query: String, pagina: u32 },
    Download { url: String, destinazione: Option<String> },
    Aiuto,
    Versione,
}

fn esegui_comando(cmd: Comando) {
    match cmd {
        Comando::Naviga(url) => {
            println!("Navigazione verso: {}", url);
        }
        
        Comando::Cerca { query, pagina } => {
            println!("Ricerca '{}' (pagina {})", query, pagina);
        }
        
        Comando::Download { url, destinazione: Some(dest) } => {
            println!("Download di {} in {}", url, dest);
        }
        
        Comando::Download { url, destinazione: None } => {
            println!("Download di {} nella cartella default", url);
        }
        
        Comando::Aiuto => {
            println!("Mostra aiuto...");
        }
        
        Comando::Versione => {
            println!("Versione 1.0.0");
        }
    }
}
```

## Risorse

- [Match Flow Control - The Rust Book](https://doc.rust-lang.org/book/ch06-02-match.html)
- [Pattern Matching - Rust by Example](https://doc.rust-lang.org/rust-by-example/flow_control/match.html)
- [Patterns - Rust Reference](https://doc.rust-lang.org/reference/patterns.html)

## Esercizio

Crea un enum `StatoHTTP` che rappresenta diversi codici di stato HTTP:
- `OK` (200)
- `NotFound` (404)
- `ServerError` con codice u16
- `Redirect` con nuova URL (String)

Scrivi una funzione `descrivi_stato` che usa `match` per restituire una descrizione appropriata per ogni stato.

**Traccia di soluzione:**
1. Definisci l'enum con le varianti appropriate
2. Implementa descrivi_stato con un match esaustivo
3. Per ServerError, includi il codice nella descrizione
4. Per Redirect, includi la nuova URL
5. Testa con diversi stati
