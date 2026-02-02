# Lifetime: concetti base e annotazioni

## Teoria
I lifetime in Rust rappresentano una delle caratteristiche più innovative e cruciali del linguaggio per garantire la sicurezza della memoria. Quando parliamo di lifetime, ci riferiamo alla durata durante la quale un riferimento è valido. Immaginate di avere un libro che prendete in prestito dalla biblioteca:andolo può essere utilizzato solo fino alla data di restituzione indicata dal bibliotecario. Allo stesso modo, Rust usa i lifetime per assicurare che nessun riferimento punti a dati che sono già stati deallocati o andati fuori scope.

I lifetime risolvono il problema dei "dangling pointers", cioè riferimenti a memoria che non è più valida, una delle cause principali di bug di sicurezza nei linguaggi come C++. Il compilatore di Rust analizza automaticamente i lifetime durante la fase di type checking, evitando che il programmatore debba gestirli manualmente come in C++ con RAII o smart pointers. Cosa succede quando creiamo un riferimento temporaneo? Rust richiede che la durata di quel riferimento sia esplicitamente annotata se il compilatore non riesce a dedurla automaticamente. Le annotazioni di lifetime, rappresentate da apost rofi preceduti da una lettera (come 'a, 'b), permettono al programmatore di specificare relazioni tra le durate degli input e dell'output delle funzioni.

Il concetto fondamentale è che ogni riferimento ha un lifetime, e il borrow checker verifica che nessun riferimento sopravviva più a lungo dei dati a cui punta. Quando scrivete funzioni che ricevono riferimenti, spesso dovrete annotare i lifetime per chiarire queste relazioni. Ad esempio, la funzione più semplice `fn hello(s: &str) -> &str` non necessita di annotazioni esplicite perché Rust applica l'elision (deduzione automatica), ma in casi più complessi come struct con riferimenti multipli, le annotazioni diventano necessarie per evitare conflitti. Imparare i lifetime richiede tempo perché cambia il modo di pensare alla programmazione: non più "puntatori ovunque" ma "durata controllata dei riferimenti" che garantisce zero cost overhead.

## Esempio
Immaginiamo di costruire una struttura che rappresenta un profilo utente con nome ed email. In un approccio senza lifetime, potremmo commettere l'errore di creare riferimenti che diventano invalidi. Prendiamo il caso di una funzione che restituisce il nome più lungo tra due profili. Senza annotazioni di lifetime, il codice non compilerebbe perché Rust non sa quanto durano i riferimenti restituiti.

Nella pratica quotidiana, i lifetime emergono quando creiamo struct che contengono riferimenti. Ad esempio, una `NewsArticle` con un campo `author` che è un riferimento a una stringa esistente altrove. Quando istanziamo la struct, dobbiamo garantire che la stringa autore esista almeno quanto la struct stessa. Ecco un caso classico: state costruendo un parser che estrae sottostringhe da un testo originale e le organizza in una struttura di dati. Se omettete le annotazioni, il compilatore vi dirà chiaramente che "the reference may outlive the referent", indicando esattamente il problema della durata. 

I lifetime aiutano a scrivere codice più robusto perché costringono a pensare alla responsabilità della memoria. Nel nostro motore di ricerca, ad esempio, quando crawlamo pagine web e memorizziamo riferimenti ai titoli, dobbiamo assicurarci che il contenuto della pagina non venga distrutto prima che finiamo di elaborare quei titoli.

## Pseudocodice
```rust
// Definizione di una struct con lifetime annotato
// struct Contenitore<'a> {
//     riferimento: &'a str,  // il riferimento dura quanto 'a
// }

// Funzione che richiede annotazione esplicita
// fn coppa<'a>(s1: &'a str, s2: &'a str) -> &'a str {
//     if s1.len() > s2.len() {
//         s1  // restituisce quello che dura più a lungo
//     } else {
//         s2
//     }
// }

// Uso pratico:
// let stringa1 = "ciao";
// let risultato = {
//     let stringa2 = "mamma";  // stringa2 scade qui
//     coppa(&stringa1, &stringa2)  // errore: stringa2 troppo corta
// };  // risultato non necessario perché stringa2 è scaduta

// Corretto:
// let stringa1 = String::from("lungo");
// let stringa2 = String::from("corto");
// let vincitore = coppa(stringa1.as_str(), stringa2.as_str());
// println!("Vincente: {}", vincitore);  // stringa1 dura abbastanza
```

## Risorse
- [Validating References with Lifetimes - The Rust Programming Language](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html)
- [Lifetime annotations - Rust by Example](https://doc.rust-lang.org/rust-by-example/scope/lifetime.html)
- [Understanding lifetime in Rust - Standard Library Reference](https://doc.rust-lang.org/std/lifetime/index.html)
- [Advanced Lifetimes - The Rustonomicon](https://doc.rust-lang.org/nomicon/lifetimes.html)

## Esercizio
Come gestiresti l'errore in una funzione che cerca la parola più lunga in un dizionario? Crea una funzione `ricerca_parola_lunga` che prende come input un hashmap di parole e le relative frequenze, e dovrebbe restituire la parola più lunga come riferimento. Identifica dove servirebbero annotazioni di lifetime e perché il codice senza di esse non compilerebbe. Traccia una soluzione completa annotando correttamente le durate, considerando che l'hashmap potrebbe essere ricostruita o modificata durante l'esecuzione del programma. Quale strategia seguiresti se volessi evitare di copiare stringhe?