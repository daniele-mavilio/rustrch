# Iteratori: map, filter, collect e Catene

## Teoria

La vera potenza degli iteratori in Rust emerge quando si combinano più operazioni in catene fluide e leggibili. I metodi `map`, `filter`, e `collect` sono i tre pilastri della trasformazione dati funzionale, permettendo di esprimere operazioni complesse in modo dichiarativo senza loop espliciti.

`map` trasforma ogni elemento applicando una funzione, `filter` seleziona solo gli elementi che soddisfano una condizione, e `collect` materializza il risultato in una collezione concreta. Quando concatenati, formano pipeline di processamento dati che sono lazy (non eseguono finché non necessario) e efficienti (senza collezioni intermedie).

L'ordine delle operazioni nella catena ha impatto sulle prestazioni. È generalmente più efficiente filtrare prima di mappare (per evitare trasformazioni su elementi che verranno scartati) e limitare (`take`) il prima possibile (per evitare lavoro inutile). Rust ottimizza queste catene a compile time, spesso producendo codice macchina equivalente a loop scritti manualmente.

## Esempio

Nel motore di ricerca, quando elaboriamo i risultati di una query:

```rust
let risultati: Vec<RisultatoRicerca> = documenti
    .iter()
    .map(|doc| calcola_punteggio(doc, &query))     // Trasforma in (doc, punteggio)
    .filter(|(_, punteggio)| *punteggio > 0.0)     // Filtra rilevanti
    .map(|(doc, punteggio)| RisultatoRicerca {      // Trasforma in struct
        titolo: doc.titolo.clone(),
        url: doc.url.clone(),
        punteggio,
    })
    .take(10)                                        // Limita risultati
    .collect();                                      // Materializza
```

Questa catena esprime chiaramente l'intento: calcola punteggi, filtra, trasforma, limita, raccogli. Senza iteratori, richiederebbe multiple allocazioni e loop annidati.

## Pseudocodice

```rust
// Combinare map, filter e collect
fn pipeline_base() {
    let numeri = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    // Quadrati dei numeri pari
    let quadrati_pari: Vec<i32> = numeri
        .iter()
        .filter(|&&n| n % 2 == 0)     // Seleziona pari
        .map(|&n| n * n)               // Calcola quadrato
        .collect();                    // Raccoglie in vettore
    // Risultato: [4, 16, 36, 64, 100]
    
    // Conteggio invece di collezione
    let conta_pari = numeri
        .iter()
        .filter(|&&n| n % 2 == 0)
        .count();                      // 5
    
    // Somma invece di collezione
    let somma_quadrati: i32 = numeri
        .iter()
        .map(|&n| n * n)
        .sum();                        // 385
}

// Catene complesse
fn catene_complesse() {
    let dati = vec![
        ("alice", 25),
        ("bob", 17),
        ("charlie", 30),
        ("diana", 16),
    ];
    
    // Nomi in maiuscolo di persone maggiorenni, ordinati
    let nomi_adulti: Vec<String> = dati
        .iter()
        .filter(|(_, eta)| *eta >= 18)     // Solo maggiorenni
        .map(|(nome, _)| nome.to_uppercase()) // Nome in maiuscolo
        .collect::<Vec<_>>()                 // Tipo esplicito opzionale
        .into_iter()
        .collect();                          // Collect finale
    // Risultato: ["ALICE", "CHARLIE"]
}

// Ordine delle operazioni e performance
fn ottimizzazione_ordine() {
    let dati = (1..=1_000_000).collect::<Vec<_>>();
    
    // MENO EFFICIENTE: mappa prima di filtrare
    let lento: Vec<i32> = dati
        .iter()
        .map(|&x| x * x)              // Moltiplicazione su TUTTI
        .filter(|&x| x > 500_000)     // Poi filtra
        .take(10)
        .collect();
    
    // PIÙ EFFICIENTE: filtra prima di mappare
    let veloce: Vec<i32> = dati
        .iter()
        .filter(|&&x| x > 707)        // Filtra prima (sqrt(500000) ≈ 707)
        .map(|&x| x * x)              // Mappa solo i sopravvissuti
        .take(10)
        .collect();
    
    // ANCORA MEGLIO: limita il prima possibile
    let ottimale: Vec<i32> = dati
        .iter()
        .filter(|&&x| x > 707)
        .map(|&x| x * x)
        .take(10)                     // Ferma subito dopo 10 elementi
        .collect();
}

// Collect in tipi diversi
fn collect_tipiversi() {
    let parole = vec!["ciao", "mondo", "ciao", "rust"];
    
    // In Vec
    let vettore: Vec<&str> = parole.iter().cloned().collect();
    
    // In HashSet (unici)
    let unici: HashSet<&str> = parole.iter().cloned().collect();
    // {"ciao", "mondo", "rust"}
    
    // In HashMap (conteggio)
    let frequenza: HashMap<&str, usize> = parole
        .iter()
        .fold(HashMap::new(), |mut acc, &parola| {
            *acc.entry(parola).or_insert(0) += 1;
            acc
        });
    // {"ciao": 2, "mondo": 1, "rust": 1}
    
    // In String (concatenazione)
    let frase: String = parole
        .iter()
        .cloned()
        .collect::<Vec<_>>()  // Prima collect in Vec
        .join(" ");           // Poi join
    // "ciao mondo ciao rust"
}

// Enumerate con catene
fn enumerate_catene() {
    let valori = vec![10, 20, 30, 40, 50];
    
    // Indice e valore filtrati
    let indici_pari: Vec<usize> = valori
        .iter()
        .enumerate()
        .filter(|(_, &val)| val > 25)
        .map(|(i, _)| i)
        .collect();
    // Indici dove valore > 25: [2, 3, 4]
}

// Flatten e flat_map
fn flatten_operatori() {
    let matrice = vec![
        vec![1, 2, 3],
        vec![4, 5, 6],
        vec![7, 8, 9],
    ];
    
    // Flatten: appiattisce vettori annidati
    let piatto: Vec<i32> = matrice
        .iter()
        .flatten()
        .cloned()
        .collect();
    // [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    // flat_map: map + flatten combinati
    let parole = vec!["ciao mondo", "come stai", "benissimo"];
    let tutte_parole: Vec<&str> = parole
        .iter()
        .flat_map(|frase| frase.split_whitespace())
        .collect();
    // ["ciao", "mondo", "come", "stai", "benissimo"]
}

// Partition: dividere in due collezioni
fn partition_esempio() {
    let numeri = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    let (pari, dispari): (Vec<i32>, Vec<i32>) = numeri
        .iter()
        .partition(|&&n| n % 2 == 0);
    
    // pari = [2, 4, 6, 8, 10]
    // dispari = [1, 3, 5, 7, 9]
}

// Esempio pratico: Estrazione parole chiave
fn estrai_parole_chiave(testo: &str) -> Vec<String> {
    testo
        .split_whitespace()
        .map(|parola| {
            parola.to_lowercase()
                .trim_matches(|c: char| !c.is_alphanumeric())
                .to_string()
        })
        .filter(|parola| !parola.is_empty() && parola.len() > 2)
        .collect::<HashSet<_>>()  // Rimuovi duplicati
        .into_iter()
        .collect()
}

// Esempio: Ranking documenti
struct Documento {
    id: u64,
    titolo: String,
    punteggio: f64,
}

fn top_documenti(documenti: &[Documento], n: usize) -> Vec<&Documento> {
    let mut risultati: Vec<&Documento> = documenti
        .iter()
        .filter(|doc| doc.punteggio > 0.0)
        .collect();
    
    // Ordina per punteggio decrescente
    risultati.sort_by(|a, b| b.punteggio.partial_cmp(&a.punteggio).unwrap());
    
    // Prendi top N
    risultati.into_iter().take(n).collect()
}
```

## Risorse

- [Iterator Adapters](https://doc.rust-lang.org/book/ch13-02-iterators.html#methods-that-produce-other-iterators)
- [Collect Method](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect)
- [Iterator Cheat Sheet](https://danielsokolowski.github.io/blog/2015/12/04/rust-iterator-cheat-sheet.html)

## Esercizio

Implementa una funzione `processa_documenti` che:
1. Accetta un vettore di stringhe (documenti)
2. Filtra i documenti con lunghezza > 100 caratteri
3. Estrae le prime 5 parole di ogni documento
4. Converte tutto in lowercase
5. Restituisce un HashMap<String, usize> con frequenza delle prime parole

**Traccia di soluzione:**
1. Usa iter() sui documenti
2. filter(|doc| doc.len() > 100)
3. filter_map per estrarre prima parola (split_whitespace().next())
4. map(|parola| parola.to_lowercase())
5. fold o collect in HashMap con conteggio
