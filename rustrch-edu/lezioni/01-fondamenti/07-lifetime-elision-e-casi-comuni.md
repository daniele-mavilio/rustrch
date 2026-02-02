# Lifetime: Elision e Casi Comuni

## Teoria

Rust è noto per il suo sistema di gestione della memoria sicuro senza garbage collector, e i lifetime sono il meccanismo chiave che rende possibile questa sicurezza. Tuttavia, annotare esplicitamente i lifetime in ogni funzione può diventare verboso e ripetitivo. Per semplificare la vita del programmatore, Rust include una funzionalità chiamata **lifetime elision** (elisione dei lifetime), che permette al compilatore di inferire automaticamente i lifetime in molti casi comuni.

L'elisione dei lifetime si basa su tre regole intuitive che il compilatore applica automaticamente quando i lifetime non sono esplicitamente specificati. Queste regole riguardano principalmente i riferimenti in input (parametri della funzione) e i riferimenti in output (valore di ritorno). Quando il compilatore può determinare in modo non ambiguo quali lifetime dovrebbero essere usati, non richiede annotazioni esplicite, rendendo il codice più pulito e leggibile senza sacrificare la sicurezza.

È importante notare che l'elisione non è una "scorciatoia" che aggira il sistema dei lifetime, ma piuttosto un ausilio che riduce la verbosità quando il contesto è sufficientemente chiaro. Se il compilatore non riesce a inferire i lifetime in modo univoco, richiederà comunque annotazioni esplicite. Questo approccio bilancia ergonomia e sicurezza, permettendo di scrivere codice conciso mantenendo le garanzie di memoria di Rust.

## Esempio

Consideriamo una funzione che restituisce il primo elemento di una slice. Senza l'elisione, dovremmo scrivere: `fn primo<'a>(elementi: &'a [i32]) -> &'a i32`. Con l'elisione, possiamo semplicemente scrivere `fn primo(elementi: &[i32]) -> &i32`, e il compilatore inferirà automaticamente che il riferimento di ritorno ha lo stesso lifetime del parametro di input. Questo rende il codice molto più leggibile, specialmente quando si hanno molte funzioni con riferimenti.

Un altro caso comune è quando si hanno multipli parametri con riferimenti. Se abbiamo `fn lunghezza(s: &str) -> usize`, non ci sono riferimenti nel valore di ritorno, quindi non serve alcun lifetime. Se invece abbiamo `fn seleziona(s1: &str, s2: &str) -> &str`, il compilatore applicherà la terza regola di elisione, collegando il lifetime di ritorno al primo parametro. Questo comportamento predefinito copre la maggior parte dei casi reali, come i metodi su struct o funzioni helper.

## Pseudocodice

```rust
// Regola 1: Ogni parametro con riferimento ottiene un lifetime unico
// fn esempio<'a, 'b>(x: &'a i32, y: &'b i32)
fn funzione_due_parametri(x: &i32, y: &i32) {
    // Il compilatore aggiunge automaticamente 'a e 'b
    // Non serve annotare quando il corpo non restituisce riferimenti
}

// Regola 2: Se c'è un solo parametro con riferimento, 
// il valore di ritorno ottiene lo stesso lifetime
fn primo_elemento(lista: &[i32]) -> &i32 {
    // Il compilatore inferisce: fn primo<'a>(lista: &'a [i32]) -> &'a i32
    // Il riferimento restituito è valido quanto la slice in input
    return &lista[0];
}

// Regola 3: Con multipli parametri, il lifetime di ritorno 
// è legato al primo parametro (self per i metodi)
fn seleziona_stringa(prima: &str, seconda: &str) -> &str {
    // Inferito come: fn seleziona<'a, 'b>(prima: &'a str, seconda: &'b str) -> &'a str
    // Il risultato è valido quanto 'prima', non 'seconda'
    if prima.len() > seconda.len() {
        return prima;
    } else {
        return seconda; // ATTENZIONE: questo viola l'elisione!
    }
}

// Esempio corretto con metodo su struct
struct Documento {
    contenuto: String,
}

impl Documento {
    // &self ottiene un lifetime, il valore di ritorno condivide quel lifetime
    fn estrai_parola(&self, indice: usize) -> &str {
        // Il compilatore capisce che il &str restituito 
        // è valido finché esiste il Documento (&self)
        let parole: Vec<&str> = self.contenuto.split_whitespace().collect();
        return parole.get(indice).unwrap_or(&"");
    }
}

// Quando l'elisione NON funziona: parametri multipli con ritorno ambiguo
fn trova_piu_lungo<'a>(prima: &'a str, seconda: &'a str) -> &'a str {
    // Qui serve annotazione esplicita perché il risultato 
    // potrebbe provenire da 'prima' O da 'seconda'
    // Il lifetime 'a deve coprire entrambi gli input
    if prima.len() >= seconda.len() {
        return prima;
    } else {
        return seconda;
    }
}
```

## Risorse

- [Lifetime Elision - The Rust Book](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html#lifetime-elision)
- [Lifetime Elision Rules - Rust Reference](https://doc.rust-lang.org/reference/lifetime-elision.html)
- [Understanding Lifetime Elision](https://doc.rust-lang.org/rust-by-example/scope/lifetime/elision.html)

## Esercizio

Scrivi una funzione `estrai_dominio` che accetta un URL come stringa e restituisce il dominio. L'URL è nel formato "https://www.esempio.com/percorso". La funzione dovrebbe restituire solo "www.esempio.com" senza allocare nuova memoria (usando slice della stringa originale).

**Traccia di soluzione:**
1. Trova la posizione di "://" con il metodo `find`
2. Estrai la parte dopo "://" usando slicing
3. Trova il primo '/' nella parte rimanente
4. Restituisci la slice fino a quel '/'
5. Non serve annotare i lifetime esplicitamente - l'elisione funzionerà automaticamente
