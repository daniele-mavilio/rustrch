# Stringhe in Rust: String vs &str

## Teoria

La gestione delle stringhe in Rust è uno degli aspetti che distingue il linguaggio da altri come Python o JavaScript. A differenza di questi linguaggi dove esiste un unico tipo "stringa", Rust offre due tipi principali: `String` e `&str`. Comprendere la differenza tra questi due tipi è fondamentale per scrivere codice Rust efficiente e corretto dal punto di vista della memoria.

`String` è un tipo growable, mutabile e posseduto (owned). È allocato sull'heap e può espandersi o restringersi durante l'esecuzione del programma. Quando crei una `String` con `String::from("ciao")` o `"ciao".to_string()`, stai allocando memoria sull'heap per contenere quei caratteri. La `String` ha la ownership di quella memoria e, quando esce dallo scope, la memoria viene automaticamente deallocata. Questo tipo è ideale quando hai bisogno di modificare il contenuto o quando la stringa deve persistire oltre lo scope corrente.

`&str` (string slice) è un riferimento immutabile a una sequenza di caratteri UTF-8 validi. Può riferirsi a una porzione di una `String` allocata sull'heap, oppure a dati memorizzati nel segmento read-only del programma (come le stringhe letterali `"ciao"`). Un `&str` non possiede i dati, ma solo "punta" a essi. È leggero e efficiente perché non richiede allocazione di memoria, ma ha il limite di essere immutabile e di dipendere dalla durata dei dati a cui fa riferimento.

## Esempio

Immagina di avere un documento di testo e di voler estrarre parole chiave. La stringa originale del documento potrebbe essere una `String` perché viene letta da un file e la sua lunghezza è sconosciuta a compile time. Quando estrai una parola chiave specifica, puoi ottenere un `&str` che riferisce solo quella porzione del documento, senza copiare i dati. Questo è estremamente efficiente in termini di memoria, specialmente quando si elaborano grandi quantità di testo.

Nella pratica, le funzioni che accettano stringhe come parametri dovrebbero preferire `&str` piuttosto che `&String`. Questo perché `&str` è più flessibile: accetta sia riferimenti a `String` (grazie alla coercizione automatica) sia stringhe letterali. Se una funzione accetta `&String`, non può essere chiamata con una stringa letterale `"ciao"` senza prima convertirla, rendendo l'API meno ergonomica. Seguendo il principio di accettare il tipo più generale possibile, `&str` è quasi sempre la scelta corretta per i parametri di funzione.

## Pseudocodice

```rust
// Creazione di String e &str
fn creazione_stringhe() {
    // Stringa letterale: &'static str (vive per tutto il programma)
    let literal: &str = "Ciao, mondo!";
    
    // String: allocata sull'heap, modificabile
    let mut stringa = String::from("Ciao");
    
    // Conversione &str -> String
    let da_str = "Ciao".to_string();
    let da_str2 = String::from("Ciao");
    
    // Conversione String -> &str (coercione automatica)
    let riferimento: &str = &stringa;
}

// Operazioni su String (mutabili)
fn manipolazione_stringhe() {
    let mut saluto = String::from("Ciao");
    
    // Aggiungere testo
    saluto.push_str(", mondo");  // Aggiunge &str
    saluto.push('!');            // Aggiunge un singolo char
    
    // Concatenazione
    let nome = String::from("Rust");
    let messaggio = saluto + " da " + &nome;  // Nota: saluto viene consumato
    
    // Formattazione (non consuma gli operandi)
    let messaggio2 = format!("{} da {}", saluto, nome);
}

// String slicing: ottenere &str da String
fn string_slicing() {
    let testo = String::from("Ciao, mondo!");
    
    // Estrarre una porzione (in byte, non caratteri!)
    let prima_parola = &testo[0..5];  // "Ciao," (byte 0-4)
    let seconda_parola = &testo[7..12];  // "mondo" (byte 7-11)
    
    // ATTENZIONE: slicing sui confini dei caratteri UTF-8 causa panic!
    // let errore = &testo[0..2];  // "C" è 1 byte, ma alcuni caratteri sono multi-byte
}

// Iterazione sui caratteri
fn iterazione_caratteri() {
    let testo = "Ciao";
    
    // Per caratteri Unicode
    for carattere in testo.chars() {
        // carattere è di tipo char (4 byte Unicode)
        println!("{}", carattere);
    }
    
    // Per byte
    for byte in testo.bytes() {
        // byte è di tipo u8
        println!("{}", byte);
    }
}

// Conversioni tra tipi
fn conversioni() {
    let stringa = String::from("123");
    
    // String -> &str (automatico)
    let slice: &str = &stringa;
    
    // String -> numero
    let numero: i32 = stringa.parse().unwrap();
    
    // Numero -> String
    let da_numero = 42.to_string();
    
    // &str -> String (esplicito)
    let nuova_stringa = slice.to_owned();
    let altra_stringa = String::from(slice);
}

// Best practice: accettare &str nei parametri
fn buona_pratica(input: &str) -> usize {
    // Funziona con: "ciao" (literal), &stringa (da String), &slice[0..5]
    input.len()
}

fn cattiva_pratica(input: &String) -> usize {
    // Funziona solo con &stringa, non con "ciao"
    input.len()
}
```

## Risorse

- [Strings - The Rust Book](https://doc.rust-lang.org/book/ch08-02-strings.html)
- [String vs &str - Rust by Example](https://doc.rust-lang.org/rust-by-example/std/str.html)
- [String Type - Rust Documentation](https://doc.rust-lang.org/std/string/struct.String.html)

## Esercizio

Scrivi una funzione `trova_email` che accetta un testo e restituisce la prima email trovata (come `&str`) senza allocare nuova memoria. Un'email è definita come sequenza di caratteri che contiene esattamente una '@' e almeno un punto dopo la '@'.

Esempio: "Contattami a mario@example.com per info" → restituisce "mario@example.com"

**Traccia di soluzione:**
1. Trova la posizione di '@' con `find()`
2. Trova lo spazio prima dell'email (o inizio stringa)
3. Trova lo spazio dopo l'email (o fine stringa)
4. Restituisci la slice appropriata
5. Usa &str come parametro e tipo di ritorno
