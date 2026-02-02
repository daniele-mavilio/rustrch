# Vettori: Vec<T> e Operazioni Comuni

## Teoria

I vettori (`Vec<T>`) sono la struttura dati più comune in Rust per memorizzare sequenze di elementi dello stesso tipo in modo dinamico. A differenza degli array, i vettori possono crescere o restringersi a runtime, allocando memoria sull'heap secondo necessità. Sono l'equivalente Rust di `ArrayList` in Java o `list` in Python, ma con le garanzie di sicurezza della memoria di Rust.

Un `Vec<T>` memorizza gli elementi in memoria contigua, il che permette accesso per indice O(1) e buona località di cache. Quando lo spazio allocato non è sufficiente, il vettore rialloca con una capacità maggiore (tipicamente raddoppiando), copiando gli elementi esistenti nella nuova area di memoria. Questa operazione è costosa ma ammortizzata su molte operazioni.

I vettori possono possedere i loro elementi (se T implementa Drop, gli elementi vengono deallocati quando il vettore esce dallo scope), oppure possono contenere riferimenti. Questa flessibilità permette di usare vettori in molti scenari diversi, dalla semplice collezione di dati a strutture dati complesse.

## Esempio

Immagina di costruire un indice per un motore di ricerca. Ogni documento ha un ID e devi mantenere una lista di tutti gli ID dei documenti indicizzati. Non sai a priori quanti documenti ci saranno, quindi un array di dimensione fissa non è adatto:

```rust
let mut document_ids: Vec<u64> = Vec::new();

// Aggiungi documenti man mano che li trovi
document_ids.push(1001);
document_ids.push(1002);
// ...

// Accesso veloce per indice
println!("Primo documento: {}", document_ids[0]);
```

I vettori sono anche essenziali quando lavori con iteratori e collezioni. La maggior parte delle operazioni di trasformazione dati in Rust produce o consuma vettori.

## Pseudocodice

```rust
// Creazione di vettori
fn creazione_vettori() {
    // Vettore vuoto
    let mut vuoto: Vec<i32> = Vec::new();
    
    // Vettore con valori iniziali (macro vec!)
    let numeri = vec![1, 2, 3, 4, 5];
    
    // Vettore con valore ripetuto
    let zeri = vec![0; 100];  // 100 zeri
    
    // Da array a vettore
    let da_array = [1, 2, 3].to_vec();
}

// Operazioni base: aggiungere e rimuovere
fn operazioni_base() {
    let mut v = Vec::new();
    
    // Aggiungere in fondo
    v.push(1);
    v.push(2);
    v.push(3);
    
    // Rimuovere l'ultimo elemento
    let ultimo = v.pop();  // Some(3)
    
    // Inserire in una posizione specifica
    v.insert(1, 99);  // [1, 99, 2]
    
    // Rimuovere da una posizione specifica
    let rimosso = v.remove(1);  // 99, v è ora [1, 2]
}

// Accesso agli elementi
fn accesso_elementi() {
    let v = vec![10, 20, 30, 40, 50];
    
    // Accesso per indice (panic se fuori range)
    let primo = v[0];  // 10
    // let errore = v[100];  // PANIC!
    
    // Accesso sicuro con get (restituisce Option)
    match v.get(100) {
        Some(valore) => println!("Trovato: {}", valore),
        None => println!("Indice fuori range"),
    }
    
    // get restituisce Option<&T>
    if let Some(&valore) = v.get(2) {
        println!("Elemento 2: {}", valore);
    }
}

// Iterazione
fn iterazione_vettori() {
    let v = vec![1, 2, 3, 4, 5];
    
    // Iterazione immutabile
    for elemento in &v {
        println!("{}", elemento);
    }
    
    // Iterazione mutabile
    let mut v_mut = vec![1, 2, 3];
    for elemento in &mut v_mut {
        *elemento *= 2;  // Raddoppia ogni elemento
    }
    // v_mut è ora [2, 4, 6]
    
    // Iterazione con consumo del vettore
    let v2 = vec![1, 2, 3];
    for elemento in v2 {
        println!("{}", elemento);
    }
    // v2 non è più utilizzabile qui
}

// Proprietà del vettore
fn proprieta_vettore() {
    let mut v = Vec::with_capacity(10);
    
    // lunghezza (numero di elementi)
    println!("Len: {}", v.len());  // 0
    
    // capacità (spazio allocato)
    println!("Cap: {}", v.capacity());  // 10
    
    v.push(1);
    v.push(2);
    
    // is_empty()
    if !v.is_empty() {
        println!("Vettore non vuoto");
    }
    
    // Troncare alla lunghezza specificata
    v.truncate(1);  // Mantiene solo il primo elemento
}

// Ricerca in vettori
fn ricerca_vettori() {
    let v = vec![10, 20, 30, 40, 50];
    
    // Contiene un elemento?
    if v.contains(&30) {
        println!("Contiene 30");
    }
    
    // Trovare posizione di un elemento
    match v.iter().position(|&x| x == 30) {
        Some(indice) => println!("30 è in posizione {}", indice),
        None => println!("30 non trovato"),
    }
    
    // Trovare primo elemento che soddisfa una condizione
    match v.iter().find(|&&x| x > 25) {
        Some(&valore) => println!("Primo > 25: {}", valore),  // 30
        None => println!("Nessun elemento > 25"),
    }
}

// Ordinamento
fn ordinamento() {
    let mut v = vec![3, 1, 4, 1, 5, 9, 2, 6];
    
    // Ordinamento crescente
    v.sort();
    // v è ora [1, 1, 2, 3, 4, 5, 6, 9]
    
    // Ordinamento decrescente
    v.sort_by(|a, b| b.cmp(a));
    // v è ora [9, 6, 5, 4, 3, 2, 1, 1]
    
    // Ordinamento stabile
    let mut parole = vec!["banana", "mela", "albicocca"];
    parole.sort_by_key(|s| s.len());
}

// Slicing
fn slicing_vettori() {
    let v = vec![1, 2, 3, 4, 5];
    
    // Ottenere una slice
    let slice: &[i32] = &v[1..4];  // [2, 3, 4]
    
    // Slice mutabile
    let mut v_mut = vec![1, 2, 3, 4, 5];
    let slice_mut: &mut [i32] = &mut v_mut[1..4];
    slice_mut[0] = 99;  // v_mut è ora [1, 99, 3, 4, 5]
}

// Esempio pratico: Indice di ricerca semplice
struct Documento {
    id: u64,
    titolo: String,
    contenuto: String,
}

fn cerca_documenti(documenti: &[Documento], query: &str) -> Vec<&Documento> {
    let mut risultati = Vec::new();
    
    for doc in documenti {
        if doc.titolo.contains(query) || doc.contenuto.contains(query) {
            risultati.push(doc);
        }
    }
    
    risultati
}
```

## Risorse

- [Vectors - The Rust Book](https://doc.rust-lang.org/book/ch08-01-vectors.html)
- [Vec Documentation](https://doc.rust-lang.org/std/vec/struct.Vec.html)
- [Vectors - Rust by Example](https://doc.rust-lang.org/rust-by-example/std/vec.html)

## Esercizio

Implementa una funzione `filtra_e_dimezza` che:
1. Accetta un vettore di i32
2. Mantiene solo i numeri pari (> 0)
3. Divide ogni numero per 2
4. Restituisce il nuovo vettore

**Traccia di soluzione:**
1. Crea un nuovo vettore per i risultati
2. Itera sul vettore input con `for numero in input`
3. Controlla se il numero è pari: `numero % 2 == 0`
4. Se pari, fai push di `numero / 2` nel vettore risultato
5. Restituisci il vettore risultato
6. Testa con [1, 2, 3, 4, 5, 6] → dovrebbe restituire [1, 2, 3]
