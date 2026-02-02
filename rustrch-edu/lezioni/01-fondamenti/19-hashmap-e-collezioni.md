# HashMap e Collezioni

## Teoria

Le HashMap sono strutture dati che memorizzano coppie chiave-valore, permettendo accesso efficiente O(1) ai valori attraverso le chiavi. Sono l'implementazione Rust delle tabelle hash (simili a `dict` in Python o `HashMap` in Java) e fanno parte del modulo `std::collections`.

A differenza dei vettori dove l'accesso è per indice numerico, nelle HashMap le chiavi possono essere di qualsiasi tipo che implementa i trait `Eq` e `Hash`. Questo include stringhe, numeri, e tipi personalizzati. I valori possono essere di qualsiasi tipo. Quando inserisci una chiave che esiste già, il vecchio valore viene sovrascritto.

Rust offre diverse collezioni oltre ai vettori e alle HashMap: `VecDeque` (double-ended queue), `LinkedList`, `BTreeMap` (mappa ordinata), `BTreeSet`, `HashSet`, e altre. La scelta dipende dalle esigenze specifiche: accesso sequenziale vs casuale, necessità di ordinamento, requisiti di prestazioni.

## Esempio

Nel nostro motore di ricerca, le HashMap sono essenziali per molte operazioni. Per esempio, quando costruiamo un indice invertito (inverted index), associamo ogni parola alla lista di documenti che la contengono:

```rust
// Chiave: parola, Valore: vettore di documenti
let mut indice: HashMap<String, Vec<u64>> = HashMap::new();

// Aggiungiamo una parola trovata in un documento
indice.entry("rust".to_string())
      .or_insert_with(Vec::new)
      .push(doc_id);
```

Questo pattern `entry().or_insert()` è molto comune quando si accumulano dati in una mappa: se la chiave esiste, ottieni il valore esistente; altrimenti, crea un nuovo valore di default.

## Pseudocodice

```rust
use std::collections::HashMap;

// Creazione di HashMap
fn creazione_hashmap() {
    // Vuota
    let mut vuota: HashMap<String, i32> = HashMap::new();
    
    // Da vettore di tuple
    let tuple = vec![("uno", 1), ("due", 2), ("tre", 3)];
    let da_tuple: HashMap<_, _> = tuple.into_iter().collect();
    
    // Con capacità iniziale
    let con_capacita = HashMap::with_capacity(100);
}

// Inserimento e accesso
fn inserimento_accesso() {
    let mut punteggi = HashMap::new();
    
    // Inserire
    punteggi.insert("Mario", 100);
    punteggi.insert("Luigi", 150);
    
    // Accedere (restituisce Option<&V>)
    match punteggi.get("Mario") {
        Some(&punteggio) => println!("Mario ha {} punti", punteggio),
        None => println!("Mario non trovato"),
    }
    
    // Modificare se esiste
    if let Some(punteggio) = punteggi.get_mut("Mario") {
        *punteggio += 50;  // Aggiunge 50 punti
    }
}

// Pattern entry (molto comune)
fn pattern_entry() {
    let mut conteggio_parole = HashMap::new();
    let testo = "ciao ciao mondo ciao";
    
    for parola in testo.split_whitespace() {
        // Se la chiave esiste, incrementa; altrimenti inserisci 1
        let conteggio = conteggio_parole.entry(parola).or_insert(0);
        *conteggio += 1;
    }
    
    // Risultato: {"ciao": 3, "mondo": 1}
    
    // Variante con or_insert_with per costi di creazione elevati
    let mut gruppi: HashMap<String, Vec<i32>> = HashMap::new();
    gruppi.entry("pari".to_string())
          .or_insert_with(|| Vec::with_capacity(100))
          .push(2);
}

// Verificare esistenza e rimuovere
fn verifica_rimozione() {
    let mut mappa = HashMap::new();
    mappa.insert("chiave", "valore");
    
    // Contiene chiave?
    if mappa.contains_key("chiave") {
        println!("Chiave trovata!");
    }
    
    // Rimuovere e restituire valore
    if let Some(valore) = mappa.remove("chiave") {
        println!("Rimosso: {}", valore);
    }
}

// Iterazione
fn iterazione_hashmap() {
    let mut mappa = HashMap::new();
    mappa.insert("a", 1);
    mappa.insert("b", 2);
    mappa.insert("c", 3);
    
    // Iterare su chiavi e valori
    for (chiave, valore) in &mappa {
        println!("{}: {}", chiave, valore);
    }
    
    // Solo chiavi
    for chiave in mappa.keys() {
        println!("Chiave: {}", chiave);
    }
    
    // Solo valori
    for valore in mappa.values() {
        println!("Valore: {}", valore);
    }
    
    // Valori mutabili
    for valore in mappa.values_mut() {
        *valore *= 2;
    }
}

// HashSet: insieme di valori unici
use std::collections::HashSet;

fn uso_hashset() {
    let mut unici = HashSet::new();
    
    // Inserire (ignora duplicati)
    unici.insert(1);
    unici.insert(2);
    unici.insert(1);  // Ignorato, 1 è già presente
    
    // Contiene?
    if unici.contains(&1) {
        println!("1 è presente");
    }
    
    // Rimozione
    unici.remove(&1);
    
    // Operazioni insiemistiche
    let set1: HashSet<_> = [1, 2, 3].iter().cloned().collect();
    let set2: HashSet<_> = [2, 3, 4].iter().cloned().collect();
    
    // Intersezione
    let intersezione: HashSet<_> = set1.intersection(&set2).collect();
    
    // Unione
    let unione: HashSet<_> = set1.union(&set2).collect();
    
    // Differenza
    let differenza: HashSet<_> = set1.difference(&set2).collect();
}

// Esempio pratico: Conteggio frequenza parole
fn conta_frequenza_parole(testo: &str) -> HashMap<String, u32> {
    let mut frequenza = HashMap::new();
    
    for parola in testo.to_lowercase().split_whitespace() {
        // Rimuovi punteggiatura semplice
        let parola_pulita: String = parola.chars()
            .filter(|c| c.is_alphanumeric())
            .collect();
        
        if !parola_pulita.is_empty() {
            *frequenza.entry(parola_pulita).or_insert(0) += 1;
        }
    }
    
    frequenza
}

// Esempio: Inverted index semplice
struct IndiceInvertito {
    // Parola -> lista di documenti
    indice: HashMap<String, Vec<u64>>,
}

impl IndiceInvertito {
    fn new() -> Self {
        IndiceInvertito {
            indice: HashMap::new(),
        }
    }
    
    fn aggiungi_documento(&mut self, doc_id: u64, parole: &[String]) {
        for parola in parole {
            self.indice
                .entry(parola.clone())
                .or_insert_with(Vec::new)
                .push(doc_id);
        }
    }
    
    fn cerca(&self, parola: &str) -> Option<&Vec<u64>> {
        self.indice.get(parola)
    }
}
```

## Risorse

- [Hash Maps - The Rust Book](https://doc.rust-lang.org/book/ch08-03-hash-maps.html)
- [HashMap Documentation](https://doc.rust-lang.org/std/collections/struct.HashMap.html)
- [Collections - Rust by Example](https://doc.rust-lang.org/rust-by-example/std/collections.html)

## Esercizio

Implementa una funzione `inverte_mappa` che:
1. Accetta una `HashMap<String, i32>`
2. Restituisce una `HashMap<i32, Vec<String>>` dove le chiavi sono i valori originali e i valori sono vettori delle chiavi originali

Esempio: `{"a": 1, "b": 2, "c": 1}` → `{1: ["a", "c"], 2: ["b"]}`

**Traccia di soluzione:**
1. Crea una nuova HashMap<i32, Vec<String>>
2. Itera sulla mappa input con `for (chiave, valore) in input`
3. Usa entry().or_insert_with(Vec::new) per ottenere il vettore
4. Aggiungi la chiave al vettore
5. Restituisci la nuova mappa
6. Nota: i32 deve implementare Eq e Hash per essere chiave (lo fa già)
