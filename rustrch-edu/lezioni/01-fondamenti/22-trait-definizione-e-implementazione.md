# Trait: Definizione e Implementazione

## Teoria

I trait in Rust sono il meccanismo principale per definire comportamenti condivisi tra diversi tipi. Sono simili alle interfacce in Java o ai typeclasses in Haskell, permettendo di definire un insieme di metodi che un tipo deve implementare per appartenere a quel trait. I trait sono alla base dell'astrazione in Rust e permettono di scrivere codice generico e riutilizzabile.

Un trait definisce una "interfaccia" specificando le firme dei metodi, ma senza implementarli (a meno che non siano metodi di default). I tipi che vogliono implementare il trait devono fornire le implementazioni concrete di tutti i metodi richiesti. Questo sistema permette polimorfismo ad-hoc: funzioni che accettano "qualunque tipo che implementa un certo trait".

I trait sono usati estensivamente nella standard library di Rust: `Display` per la formattazione come stringa, `Clone` per la duplicazione, `Copy` per la copia bit-wise, `Debug` per il debug, `PartialEq` e `Eq` per confronti di uguaglianza, `PartialOrd` e `Ord` per ordinamenti, e molti altri. Comprendere i trait è essenziale per usare efficacemente Rust.

## Esempio

Nel motore di ricerca, potremmo definire un trait `Documento` che tutti i tipi di documenti devono implementare:

```rust
trait Documento {
    fn id(&self) -> u64;
    fn titolo(&self) -> &str;
    fn contenuto(&self) -> &str;
    fn punteggio(&self, query: &str) -> f64;
}
```

Ora sia `PaginaWeb`, `DocumentoPDF`, che `ArticoloNews` possono implementare questo trait, e funzioni che lavorano con documenti possono accettare `&dyn Documento` o essere generiche su `T: Documento`.

## Pseudocodice

```rust
// Definizione di un trait
trait Descrivibile {
    // Metodo richiesto (deve essere implementato)
    fn descrizione(&self) -> String;
    
    // Metodo di default (può essere sovrascritto)
    fn descrizione_breve(&self) -> String {
        let desc = self.descrizione();
        if desc.len() > 50 {
            format!("{}...", &desc[..47])
        } else {
            desc
        }
    }
}

// Implementazione del trait per un tipo
struct Prodotto {
    nome: String,
    prezzo: f64,
}

impl Descrivibile for Prodotto {
    fn descrizione(&self) -> String {
        format!("{} - €{:.2}", self.nome, self.prezzo)
    }
    // descrizione_breve usa il default
}

struct Servizio {
    nome: String,
    durata_ore: u32,
}

impl Descrivibile for Servizio {
    fn descrizione(&self) -> String {
        format!("{} ({} ore)", self.nome, self.durata_ore)
    }
    
    // Sovrascriviamo il default
    fn descrizione_breve(&self) -> String {
        self.nome.clone()
    }
}

// Usare il trait
fn stampa_descrizione<T: Descrivibile>(item: &T) {
    println!("{}", item.descrizione());
    println!("Breve: {}", item.descrizione_breve());
}

// Implementazione per tipo primitivo
impl Descrivibile for i32 {
    fn descrizione(&self) -> String {
        format!("Il numero {}", self)
    }
}

// Trait con metodi associati (statici)
trait Convertibile {
    fn da_stringa(s: &str) -> Self;
    fn predefinito() -> Self;
}

impl Convertibile for i32 {
    fn da_stringa(s: &str) -> Self {
        s.parse().unwrap_or(0)
    }
    
    fn predefinito() -> Self {
        42
    }
}

// Trait con type associati
trait Iterabile {
    type Item;
    
    fn prossimo(&mut self) -> Option<Self::Item>;
    fn ha_prossimo(&self) -> bool;
}

// Implementazione parziale di trait
// Un tipo può implementare un trait solo se:
// - Il trait è locale (definito nello stesso crate), O
// - Il tipo è locale (definito nello stesso crate)
// Questa è la "regola di coerenza" (orphan rule)

// Trait bounds multipli
fn stampa_e_confronta<T>(a: &T, b: &T)
where
    T: Descrivibile + PartialEq,
{
    println!("A: {}", a.descrizione());
    println!("B: {}", b.descrizione());
    
    if a == b {
        println!("Sono uguali!");
    }
}

// Trait object (dispatch dinamico)
fn stampa_vari(items: &[&dyn Descrivibile]) {
    for item in items {
        println!("{}", item.descrizione());
    }
}

// Esempio pratico: Trait per documenti di ricerca
trait Ricercabile {
    fn contiene(&self, parola: &str) -> bool;
    fn estrai_frasi(&self) -> Vec<String>;
}

struct PaginaWeb {
    url: String,
    titolo: String,
    contenuto: String,
}

impl Ricercabile for PaginaWeb {
    fn contiene(&self, parola: &str) -> bool {
        self.contenuto.to_lowercase().contains(&parola.to_lowercase())
    }
    
    fn estrai_frasi(&self) -> Vec<String> {
        self.contenuto
            .split('.')
            .map(|s| s.trim().to_string())
            .filter(|s| !s.is_empty())
            .collect()
    }
}

// Funzione generica che usa il trait
fn conta_occorrenze<T: Ricercabile>(documenti: &[T], parola: &str) -> usize {
    documenti
        .iter()
        .filter(|doc| doc.contiene(parola))
        .count()
}

// Trait marker (senza metodi)
trait InviaSync: Send + Sync {}

// Trait auto-implementati
// Rust implementa automaticamente alcuni trait se i campi lo implementano
// Copy, Clone, Debug, Default, Eq, PartialEq, Ord, PartialOrd, Hash
#[derive(Debug, Clone, Copy, PartialEq)]
struct Punto {
    x: i32,
    y: i32,
}
```

## Risorse

- [Traits - The Rust Book](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [Traits - Rust by Example](https://doc.rust-lang.org/rust-by-example/trait.html)
- [Trait Objects](https://doc.rust-lang.org/book/ch17-02-trait-objects.html)

## Esercizio

Crea un trait `Valutabile` con i seguenti metodi:
1. `valuta(&self) -> f64` - restituisce un punteggio numerico
2. `e_accettabile(&self) -> bool` - metodo di default che restituisce true se valuta() >= 0.5

Poi implementa questo trait per:
1. `struct Esame { voto: u8, cfu: u8 }` - valuta() = voto * cfu / 30.0
2. `struct Recensione { stelle: u8 }` - valuta() = stelle / 5.0

Scrivi una funzione `filtra_accettabili` che accetta un vettore di elementi Valutabili e restituisce solo quelli accettabili.

**Traccia di soluzione:**
1. Definisci il trait Valutabile con i due metodi
2. Implementa per Esame calcolando il punteggio
3. Implementa per Recensione convertendo le stelle
4. Usa e_accettabile() default per entrambi
5. filtra_accettabili usa iter().filter().collect()
