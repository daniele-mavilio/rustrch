# Struct: Metodi e Funzioni Associate

## Teoria

Oltre a raggruppare dati, le struct in Rust possono avere comportamenti attraverso i metodi. A differenza di linguaggi come Java o Python dove i metodi sono definiti all'interno della classe, in Rust i metodi vengono definiti in blocchi separati chiamati `impl` (implementation). Questa separazione tra dati e comportamento è una caratteristica distintiva di Rust che offre maggiore flessibilità e chiarezza.

Esistono due tipi di funzioni associate a una struct: i **metodi** e le **funzioni associate**. I metodi sono funzioni che operano su un'istanza della struct e accettano `self`, `&self` o `&mut self` come primo parametro. Questo parametro speciale rappresenta l'istanza su cui viene invocato il metodo. Le funzioni associate (spesso chiamate metodi statici in altri linguaggi) non operano su un'istanza specifica e non hanno il parametro `self` - sono associate al tipo stesso, non a un'istanza.

La dot notation (`istanza.metodo()`) è zucchero sintattico per chiamare metodi. In realtà, `libro.titolo()` è equivalente a `Libro::titolo(&libro)`. Il compilatore automaticamente aggiunge il riferimento, il riferimento mutabile, o sposta il valore a seconda della firma del metodo. Questo meccanismo è fondamentale per il sistema di ownership di Rust: i metodi che prendono `&self` possono solo leggere, quelli che prendono `&mut self` possono modificare, e quelli che prendono `self` consumano l'istanza.

## Esempio

Consideriamo una struct `Rettangolo` che rappresenta un rettangolo con larghezza e altezza. Vorremmo poter calcolare l'area e il perimetro di un rettangolo specifico, e anche creare rettangoli con proprietà speciali come quadrati.

```rust
impl Rettangolo {
    fn area(&self) -> u32 {
        self.larghezza * self.altezza
    }
    
    fn quadrato(dimensione: u32) -> Rettangolo {
        Rettangolo {
            larghezza: dimensione,
            altezza: dimensione,
        }
    }
}
```

Il metodo `area` accetta `&self` (riferimento immutabile) perché solo legge i dati. La funzione associata `quadrato` non ha `self` e si chiama usando la sintassi `Rettangolo::quadrato(5)`, simile a come si chiamano i metodi statici in altri linguaggi.

## Pseudocodice

```rust
struct Rettangolo {
    larghezza: u32,
    altezza: u32,
}

// Blocco impl per definire metodi e funzioni associate
impl Rettangolo {
    // Metodo che accetta riferimento immutabile a self
    // Può solo leggere i campi, non modificarli
    fn area(&self) -> u32 {
        self.larghezza * self.altezza
    }
    
    // Metodo che accetta riferimento mutabile a self
    // Può modificare i campi della struct
    fn scala(&mut self, fattore: u32) {
        self.larghezza *= fattore;
        self.altezza *= fattore;
    }
    
    // Metodo che prende ownership di self (consuma l'istanza)
    // Dopo questa chiamata, l'istanza non è più utilizzabile
    fn decomponi(self) -> (u32, u32) {
        (self.larghezza, self.altezza)
    }
    
    // Funzione associata (no self) - costruttore
    fn nuovo(larghezza: u32, altezza: u32) -> Rettangolo {
        Rettangolo {
            larghezza,
            altezza,
        }
    }
    
    // Funzione associata - factory per quadrati
    fn quadrato(dimensione: u32) -> Rettangolo {
        Rettangolo {
            larghezza: dimensione,
            altezza: dimensione,
        }
    }
    
    // Metodo che confronta con un altro rettangolo
    fn puo_contenere(&self, altro: &Rettangolo) -> bool {
        self.larghezza > altro.larghezza && self.altezza > altro.altezza
    }
}

fn uso_rettangolo() {
    // Usare funzione associata come costruttore
    let mut rect = Rettangolo::nuovo(30, 50);
    
    // Chiamare metodo con dot notation (automaticamente prende &self)
    println!("Area: {}", rect.area());  // 1500
    
    // Chiamare metodo che richiede mutabilità
    rect.scala(2);
    println!("Nuova area: {}", rect.area());  // 6000
    
    // Factory per quadrati
    let quadrato = Rettangolo::quadrato(10);
    println!("Area quadrato: {}", quadrato.area());  // 100
    
    // Confronto tra rettangoli
    let grande = Rettangolo::nuovo(100, 100);
    let piccolo = Rettangolo::nuovo(50, 50);
    println!("Grande contiene piccolo? {}", grande.puo_contenere(&piccolo));
}

// Metodi getter (convenzione Rust)
struct Utente {
    username: String,
    email: String,
    eta: u8,
}

impl Utente {
    // Costruttore
    pub fn nuovo(username: &str, email: &str) -> Utente {
        Utente {
            username: username.to_string(),
            email: email.to_string(),
            eta: 0,
        }
    }
    
    // Getter per campo privato (restituisce riferimento per evitare clone)
    pub fn username(&self) -> &str {
        &self.username
    }
    
    // Getter con calcolo
    pub fn maggiorenne(&self) -> bool {
        self.eta >= 18
    }
    
    // Setter
    pub fn set_eta(&mut self, eta: u8) {
        self.eta = eta;
    }
}

// Più blocchi impl sono permessi (spesso usati per organizzazione)
impl Rettangolo {
    fn perimetro(&self) -> u32 {
        2 * (self.larghezza + self.altezza)
    }
}
```

## Risorse

- [Method Syntax - The Rust Book](https://doc.rust-lang.org/book/ch05-03-method-syntax.html)
- [Methods - Rust by Example](https://doc.rust-lang.org/rust-by-example/fn/methods.html)
- [Associated Functions and Methods](https://doc.rust-lang.org/book/ch05-03-method-syntax.html#associated-functions)

## Esercizio

Crea una struct `Cerchio` con un campo `raggio` di tipo f64. Implementa i seguenti metodi:
1. `nuovo(raggio: f64) -> Cerchio` - costruttore
2. `area(&self) -> f64` - calcola l'area
3. `circonferenza(&self) -> f64` - calcola la circonferenza
4. `scala(&mut self, fattore: f64)` - moltiplica il raggio per il fattore

**Traccia di soluzione:**
1. Usa std::f64::consts::PI per il valore di π
2. Area = π × raggio²
3. Circonferenza = 2 × π × raggio
4. Testa con un cerchio di raggio 5.0, scala di 2, verifica nuova area
