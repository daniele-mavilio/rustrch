# Closures e Funzioni di Ordine Superiore

## Teoria

Le closures in Rust sono funzioni anonime che possono catturare variabili dall'ambiente circostante. Sono simili alle lambda in Python o alle arrow functions in JavaScript, ma con un sistema di tipo sofisticato che tiene traccia di cosa catturano e come. Il compilatore inferisce automaticamente il modo in cui una closure cattura le variabili: per riferimento immutabile (`&T`), riferimento mutabile (`&mut T`), o per ownership (`T`).

Le closures sono fondamentali per la programmazione funzionale in Rust e sono usate estensivamente con gli iteratori. I trait `Fn`, `FnMut`, e `FnOnce` descrivono le diverse capacità di una closure: `Fn` può essere chiamata multiple volte catturando per riferimento, `FnMut` può mutare lo stato catturato, e `FnOnce` consuma le variabili catturate e può essere chiamata solo una volta. Il compilatore implementa automaticamente i trait appropriati per ogni closure.

Le funzioni di ordine superiore sono funzioni che accettano altre funzioni o closures come parametri o le restituiscono come risultato. Questo pattern è onnipresente in Rust, specialmente con gli iteratori (map, filter, fold) e nella gestione asincrona. Permette di scrivere codice molto flessibile e riutilizzabile.

## Esempio

```rust
let moltiplicatore = 3;

// Closure che cattura moltiplicatore dal contesto
let triplica = |x| x * moltiplicatore;

let risultato = triplica(5);  // 15
```

La closure `triplica` cattura `moltiplicatore` per riferimento immutabile. Se avessimo mutato `moltiplicatore` dopo la creazione della closure, il compilatore avrebbe dovuto catturarlo in modo diverso.

## Pseudocodice

```rust
// Closure semplice
fn closure_base() {
    let addizione = |a, b| a + b;
    let risultato = addizione(5, 3);  // 8
    
    // Closure con tipo esplicito
    let sottrazione = |a: i32, b: i32| -> i32 { a - b };
}

// Cattura variabili dall'ambiente
fn cattura_variabili() {
    let fattore = 10;
    
    // Cattura fattore per riferimento immutabile (Fn)
    let moltiplica = |x| x * fattore;
    println!("{}", moltiplica(5));  // 50
    println!("{}", moltiplica(3));  // 30 (può essere chiamata multiple volte)
    
    // fattore è ancora disponibile qui
    println!("Fattore: {}", fattore);
}

// Cattura mutabile (FnMut)
fn cattura_mutabile() {
    let mut contatore = 0;
    
    // Cattura contatore per riferimento mutabile
    let mut incrementa = || {
        contatore += 1;
        contatore
    };
    
    println!("{}", incrementa());  // 1
    println!("{}", incrementa());  // 2
    println!("{}", incrementa());  // 3
    
    // contatore non è più disponibile qui (prestato mutabilmente)
    // println!("{}", contatore);  // ERRORE!
}

// Cattura per ownership (FnOnce)
fn cattura_ownership() {
    let saluto = String::from("Ciao");
    
    // Cattura saluto per ownership
    let crea_messaggio = |nome: &str| {
        format!("{}, {}!", saluto, nome)  // saluto viene spostato qui
    };
    
    let msg1 = crea_messaggio("Mario");  // OK
    // let msg2 = crea_messaggio("Luigi");  // ERRORE! già consumata
    
    // saluto non è più disponibile
    // println!("{}", saluto);  // ERRORE!
}

// Closure come parametri di funzione (ordine superiore)
fn applique_a_tutti<T>(vettore: Vec<T>, f: impl Fn(T) -> T) -> Vec<T> {
    vettore.into_iter().map(f).collect()
}

fn filtra<T>(vettore: Vec<T>, predicato: impl Fn(&T) -> bool) -> Vec<T> {
    vettore.into_iter().filter(predicato).collect()
}

// Esempi di utilizzo
fn esempi_utilizzo() {
    let numeri = vec![1, 2, 3, 4, 5];
    
    // Raddoppia tutti
    let raddoppiati = applique_a_tutti(numeri.clone(), |x| x * 2);
    // [2, 4, 6, 8, 10]
    
    // Filtra pari
    let pari = filtra(numeri, |&x| x % 2 == 0);
    // [2, 4]
}

// Closure che restituisce closure
fn crea_moltiplicatore(fattore: i32) -> impl Fn(i32) -> i32 {
    move |x| x * fattore  // 'move' forza cattura per ownership
}

fn uso_factory() {
    let triplica = crea_moltiplicatore(3);
    let quadruplica = crea_moltiplicatore(4);
    
    println!("{}", triplica(5));      // 15
    println!("{}", quadruplica(5));   // 20
}

// Move closure
fn move_closure() {
    let dati = vec![1, 2, 3];
    
    // Senza move: cattura per riferimento
    let riferimento = || println!("{:?}", dati);
    riferimento();
    println!("Ancora disponibile: {:?}", dati);  // OK
    
    // Con move: cattura per ownership
    let ownership = move || println!("{:?}", dati);
    ownership();
    // println!("{:?}", dati);  // ERRORE! dati è stato spostato
}

// Esempio pratico: Callback e eventi
struct Pulsante {
    etichetta: String,
    callback: Box<dyn Fn()>,
}

impl Pulsante {
    fn new(etichetta: &str, callback: impl Fn() + 'static) -> Self {
        Pulsante {
            etichetta: etichetta.to_string(),
            callback: Box::new(callback),
        }
    }
    
    fn clic(&self) {
        (self.callback)();
    }
}

fn esempio_pulsante() {
    let contatore = std::cell::RefCell::new(0);
    
    let pulsante = Pulsante::new("Clicca", {
        let contatore = contatore.clone();
        move || {
            *contatore.borrow_mut() += 1;
            println!("Cliccato {} volte", contatore.borrow());
        }
    });
    
    pulsante.clic();
    pulsante.clic();
}

// Esempio: Ordinamento custom
fn ordina_custom() {
    let mut persone = vec![
        ("Mario", 30),
        ("Luigi", 25),
        ("Peach", 28),
    ];
    
    // Ordina per età
    persone.sort_by(|a, b| a.1.cmp(&b.1));
    
    // Ordina per lunghezza nome
    persone.sort_by(|a, b| a.0.len().cmp(&b.0.len()));
}

// Esempio: Lazy evaluation
fn lazy_evaluation() {
    let calcolo_costoso = |n: u32| -> u32 {
        println!("Calcolando per {}...", n);
        n * n * n
    };
    
    let valori: Vec<u32> = (1..=5)
        .filter(|&n| n > 2)
        .map(calcolo_costoso)
        .take(2)
        .collect();
    
    // Stampa solo per 3 e 4, poi si ferma
}

// Closure con stato (simulazione)
fn closure_stato() {
    let mut stato = 0;
    
    let mut aggiorna = |valore: i32| {
        stato += valore;
        stato
    };
    
    println!("{}", aggiorna(5));   // 5
    println!("{}", aggiorna(3));   // 8
    println!("{}", aggiorna(10));  // 18
}
```

## Risorse

- [Closures - The Rust Book](https://doc.rust-lang.org/book/ch13-01-closures.html)
- [Closures - Rust by Example](https://doc.rust-lang.org/rust-by-example/fn/closures.html)
- [Fn, FnMut, FnOnce](https://doc.rust-lang.org/std/ops/trait.Fn.html)

## Esercizio

Scrivi una funzione `crea_contatore` che:
1. Accetta un valore iniziale (i32)
2. Restituisce una closure che, quando chiamata:
   - Incrementa il contatore interno di 1
   - Restituisce il nuovo valore

La closure deve poter essere chiamata multiple volte.

**Traccia di soluzione:**
1. Usa `move` per catturare il valore iniziale per ownership
2. Usa RefCell o simile per mutabilità interna, oppure restituisci FnMut
3. Per FnMut: `fn crea_contatore(iniziale: i32) -> impl FnMut() -> i32`
4. La closure incrementa e restituisce il valore
5. Test chiamando la closure multiple volte

**Variante avanzata:** Crea `crea_contatore_step` che accetta anche lo step di incremento.
