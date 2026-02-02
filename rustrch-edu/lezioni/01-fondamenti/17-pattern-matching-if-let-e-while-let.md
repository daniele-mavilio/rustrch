# Pattern Matching: if let e while let

## Teoria

Mentre `match` è potente ed esaustivo, a volte è eccessivo quando ci interessa solo uno specifico pattern e vogliamo ignorare tutti gli altri. Per questi casi, Rust fornisce `if let` e `while let`, che offrono una sintassi più concisa quando il controllo esaustivo non è necessario.

`if let` combina `if` e `let` in un'unica espressione che controlla se un pattern matcha e, in caso affermativo, esegue un blocco di codice con le variabili legate dal pattern. È zucchero sintattico per un `match` con un solo caso interessante e un wildcard che non fa nulla. Questo rende il codice più leggibile quando ci interessa solo un caso specifico.

`while let` funziona in modo simile ma all'interno di un loop. Continua a eseguire il blocco fintanto che il pattern matcha. È particolarmente utile quando si consumano iteratori che potrebbero terminare (`Option`), o quando si leggono dati da una sorgente che potrebbe esaurirsi. Invece di scrivere un loop infinito con un match interno, `while let` offre una sintassi più pulita.

## Esempio

Immagina di voler fare qualcosa solo se un `Option` contiene un valore:

```rust
// Con match (verboso)
match valore {
    Some(v) => println!("Trovato: {}", v),
    None => (),  // Non facciamo nulla
}

// Con if let (conciso)
if let Some(v) = valore {
    println!("Trovato: {}", v);
}
```

Entrambi fanno la stessa cosa, ma il secondo è più pulito. Lo stesso vale per `while let` quando consumiamo un iteratore:

```rust
// Con while let
while let Some(valore) = iteratore.next() {
    println!("{}", valore);
}
// Si ferma automaticamente quando next() restituisce None
```

## Pseudocodice

```rust
// if let: quando ci interessa solo un pattern specifico
fn esempio_if_let() {
    let valore: Option<i32> = Some(5);
    
    // Con match (verboso)
    match valore {
        Some(n) => println!("Numero: {}", n),
        None => (),  // Non facciamo nulla
    }
    
    // Con if let (più conciso)
    if let Some(n) = valore {
        println!("Numero: {}", n);
    }
    // Se valore è None, il blocco viene saltato
}

// if let con else
fn if_let_con_else() {
    let colore: Option<&str> = None;
    
    if let Some(c) = colore {
        println!("Colore scelto: {}", c);
    } else {
        println!("Nessun colore scelto");
    }
    
    // Equivalente a:
    // match colore {
    //     Some(c) => println!("Colore scelto: {}", c),
    //     None => println!("Nessun colore scelto"),
    // }
}

// if let con enum
enum Messaggio {
    Testo(String),
    Numero(i32),
    Vuoto,
}

fn gestisci_messaggio(msg: Messaggio) {
    // Solo se è un messaggio di testo
    if let Messaggio::Testo(contenuto) = msg {
        println!("Messaggio di testo: {}", contenuto);
    }
    // Se msg è Numero o Vuoto, non succede nulla
}

// while let: loop con pattern matching
fn esempio_while_let() {
    let mut stack = Vec::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    
    // Pop elementi finché ce ne sono
    while let Some(valore) = stack.pop() {
        println!("Estratto: {}", valore);
    }
    // Stampa: 3, 2, 1
}

// while let con iteratori
fn iteratore_while_let() {
    let numeri = vec![1, 2, 3, 4, 5];
    let mut iter = numeri.iter();
    
    while let Some(&n) = iter.next() {
        println!("Numero: {}", n);
    }
    // Si ferma automaticamente quando l'iteratore è esaurito
}

// while let con tuple destructuring
fn while_let_tuple() {
    let mut coordinate = vec![(0, 0), (1, 1), (2, 2)];
    let mut iter = coordinate.drain(..);
    
    while let Some((x, y)) = iter.next() {
        println!("Punto ({}, {})", x, y);
    }
}

// Confronto: match vs if let
fn confronto() {
    let risultato: Result<i32, &str> = Ok(42);
    
    // Scenario 1: ci interessa solo il caso Ok
    // Meglio if let
    if let Ok(numero) = risultato {
        println!("Successo: {}", numero);
    }
    
    // Scenario 2: ci interessano entrambi i casi
    // Meglio match
    match risultato {
        Ok(n) => println!("Successo: {}", n),
        Err(e) => println!("Errore: {}", e),
    }
    
    // Scenario 3: ci interessano molti casi specifici
    // Meglio match
    match risultato {
        Ok(0) => println!("Zero"),
        Ok(n) if n > 0 => println!("Positivo"),
        Ok(n) => println!("Negativo"),
        Err("not found") => println!("Non trovato"),
        Err(_) => println!("Altro errore"),
    }
}

// Esempio pratico: Lettura da fonte dati
struct Dato {
    id: u32,
    valore: String,
}

fn processa_fonte_dati(fonte: &mut impl Iterator<Item = Dato>) {
    // Processa dati finché ce ne sono
    while let Some(dato) = fonte.next() {
        if dato.id > 100 {
            println!("Dato importante #{}: {}", dato.id, dato.valore);
        }
    }
    println!("Fonte dati esaurita");
}

// Esempio: Lettura file riga per riga
fn leggi_file_per_righe(contenuto: &str) {
    let mut linee = contenuto.lines();
    let mut numero_riga = 1;
    
    while let Some(linea) = linee.next() {
        if !linea.trim().is_empty() {
            println!("{}: {}", numero_riga, linea);
        }
        numero_riga += 1;
    }
}

// Combinazione if let + else if let
fn combinazione() {
    let valore: Option<Option<i32>> = Some(Some(5));
    
    if let Some(Some(n)) = valore {
        println!("Numero annidato: {}", n);
    } else if let Some(None) = valore {
        println!("Inner None");
    } else {
        println!("Outer None");
    }
}

// Esempio: Configurazione opzionale
struct Config {
    host: Option<String>,
    porta: Option<u16>,
}

fn configura_server(config: Config) {
    // Usa valore configurato o default
    let host = if let Some(h) = config.host {
        h
    } else {
        String::from("localhost")
    };
    
    let porta = if let Some(p) = config.porta {
        p
    } else {
        8080
    };
    
    println!("Server configurato su {}:{}", host, porta);
}
```

## Risorse

- [if let - The Rust Book](https://doc.rust-lang.org/book/ch06-03-if-let.html)
- [while let - Rust by Example](https://doc.rust-lang.org/rust-by-example/flow_control/while_let.html)
- [Concise Control Flow](https://doc.rust-lang.org/book/ch06-03-if-let.html)

## Esercizio

Scrivi una funzione `conta_valori_positivi` che:
1. Accetta un vettore di `Option<i32>`
2. Usa `while let` per iterare attraverso il vettore (consumandolo)
3. Conta quanti `Option` contengono un valore positivo (> 0)
4. Restituisce il conteggio

**Traccia di soluzione:**
1. Usa `while let Some(opzione) = vettore.pop()` per estrarre elementi
2. Dentro, usa `if let Some(valore) = opzione` per controllare se c'è un valore
3. Se il valore è > 0, incrementa il contatore
4. Restituisci il conteggio finale
5. Prova con un vettore misto: Some(5), None, Some(-3), Some(10), None
