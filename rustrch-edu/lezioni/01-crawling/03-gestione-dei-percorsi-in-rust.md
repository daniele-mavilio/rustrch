## Teoria

La gestione dei percorsi è un aspetto fondamentale nella programmazione, soprattutto quando si lavora con il file system. In Rust, i percorsi sono gestiti attraverso i tipi `Path` e `PathBuf`, che forniscono un modo sicuro e efficiente per manipolare i percorsi dei file e delle directory. Questi tipi sono parte del modulo `std::path` della libreria standard di Rust e offrono una serie di metodi utili per lavorare con i percorsi in modo cross-platform.

Il tipo `Path` rappresenta un percorso immutabile, mentre `PathBuf` è la versione mutabile di `Path`. Entrambi i tipi sono progettati per gestire percorsi in modo sicuro, evitando problemi comuni come gli errori di parsing o le vulnerabilità di sicurezza. Inoltre, questi tipi sono in grado di gestire percorsi sia assoluti che relativi, fornendo metodi per convertire tra i due formati.

La normalizzazione dei percorsi è un altro aspetto importante della gestione dei percorsi. La normalizzazione consiste nel convertire un percorso in una forma standard, rimuovendo ridondanze come i riferimenti a directory correnti (`.`) o genitori (`..`). Questo processo è utile per garantire che i percorsi siano confrontabili in modo affidabile e per evitare problemi di sicurezza.

## Esempio

Supponiamo di voler esplorare la directory `/home/utente/documenti` e di voler costruire un percorso per accedere al file `relazione.txt` al suo interno. Utilizzando i tipi `Path` e `PathBuf`, possiamo costruire il percorso in modo sicuro e efficiente.

Ad esempio, possiamo creare un nuovo percorso utilizzando `PathBuf` e aggiungere componenti al percorso utilizzando il metodo `push`. Questo ci permette di costruire percorsi in modo incrementale, aggiungendo directory e file man mano che li esploriamo.

Inoltre, possiamo normalizzare il percorso per garantire che sia in una forma standard. Ad esempio, se il percorso contiene riferimenti a directory correnti o genitori, possiamo utilizzare il metodo `canonicalize` per convertire il percorso in una forma assoluta e normalizzata.

## Pseudocodice

```rust
// Creazione di un nuovo percorso utilizzando PathBuf
let mut percorso = PathBuf::new();
percorso.push("/home");
percorso.push("utente");
percorso.push("documenti");
percorso.push("relazione.txt");

// Stampa del percorso
println!("Percorso: {}", percorso.display());

// Normalizzazione del percorso
let percorso_normalizzato = percorso.canonicalize().unwrap();
println!("Percorso normalizzato: {}", percorso_normalizzato.display());

// Verifica se il percorso è assoluto
let e_assoluto = percorso.is_absolute();
println!("Il percorso è assoluto: {}", e_assoluto);

// Verifica se il percorso è relativo
let e_relativo = percorso.is_relative();
println!("Il percorso è relativo: {}", e_relativo);

// Estrazione del nome del file dal percorso
if let Some(nome_file) = percorso.file_name() {
    println!("Nome del file: {}", nome_file.to_string_lossy());
}

// Estrazione della directory genitore dal percorso
if let Some(directory_genitore) = percorso.parent() {
    println!("Directory genitore: {}", directory_genitore.display());
}
```

## Risorse

- [Tokio Documentation](https://tokio.rs/tokio/tutorial)
- [Rust Async Book](https://rust-lang.github.io/async-book/)
- [std::path documentation](https://doc.rust-lang.org/std/path/)
- [Rust by Example - Filesystem](https://doc.rust-lang.org/rust-by-example/std_misc/fs.html)

## Esercizio

1. **Domanda di comprensione**: Qual è la differenza tra `Path` e `PathBuf` in Rust?
2. **Domanda di comprensione**: Perché è importante normalizzare i percorsi?
3. **Domanda di comprensione**: Quali sono i metodi principali per manipolare i percorsi in Rust?
4. **Domanda di comprensione**: Come si verifica se un percorso è assoluto o relativo?
5. **Domanda di comprensione**: Qual è il vantaggio dell'utilizzo di `Path` e `PathBuf` rispetto alle stringhe per gestire i percorsi?

**Esercizio pratico**:
- Scrivi uno pseudocodice per una funzione che prende un percorso relativo e lo converte in un percorso assoluto.
- Scrivi uno pseudocodice per una funzione che normalizza un percorso e stampa il risultato.