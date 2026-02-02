# Installare Rust con rustup

## Teoria

`rustup` è il tool di installazione e gestione delle versioni di Rust. A differenza di molti altri linguaggi dove l'installazione è manuale e gestire versioni multiple è complicato, `rustup` semplifica tutto il processo permettendo di installare, aggiornare e passare tra diverse versioni di Rust (stable, beta, nightly) con semplici comandi.

Il metodo ufficiale per installare Rust è attraverso il comando curl/sh che scarica ed esegue `rustup-init`. Questo approccio funziona su Linux, macOS e Windows (via WSL o direttamente con un installer). L'installazione configura automaticamente la variabile d'ambiente PATH e installa la toolchain stable predefinita, che include il compilatore `rustc`, il gestore pacchetti `cargo`, e altri strumenti essenziali.

Una volta installato, `rustup` permette di gestire multiple "toolchain": versioni parallele di Rust che possono essere usate per diversi progetti. Questo è particolarmente utile quando si lavora su progetti che richiedono versioni specifiche di Rust, o quando si vogliono testare le funzionalità in arrivo usando il canale nightly. Il comando `rustup default` imposta la toolchain di default, mentre `rustup override` permette di specificare una toolchain diversa per una directory specifica.

## Esempio

Per installare Rust su Linux o macOS:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Questo comando scarica lo script di installazione da rustup.rs e lo esegue. Lo script chiederà conferma e poi installerà la toolchain stable predefinita. Dopo l'installazione, è necessario ricaricare il file di configurazione della shell (`.bashrc`, `.zshrc`, ecc.) o aprire un nuovo terminale per rendere disponibile il comando `cargo`.

Una volta installato, puoi verificare l'installazione con:

```bash
rustc --version
cargo --version
```

## Pseudocodice

```bash
// Installazione di Rust su Linux/macOS
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

// Segui le istruzioni interattive:
// 1) Proceed with installation (default)
// 2) Customize installation
// 3) Cancel installation

// Ricarica la configurazione della shell
$ source $HOME/.cargo/env

// Oppure aggiungi manualmente al tuo .bashrc/.zshrc:
// export PATH="$HOME/.cargo/bin:$PATH"

// Verifica installazione
$ rustc --version
// rustc 1.75.0 (82e1608df 2023-12-21)

$ cargo --version
// cargo 1.75.0

// Installazione su Windows (PowerShell come Administrator)
// Scarica e esegui rustup-init.exe da https://rustup.rs/
// Oppure con winget:
$ winget install Rustlang.Rustup

// Gestione delle toolchain
$ rustup show
// Mostra la toolchain attiva e le componenti installate

$ rustup update
// Aggiorna tutte le toolchain alla versione più recente

$ rustup default stable
// Imposta la toolchain stable come default

$ rustup default nightly
// Passa alla toolchain nightly (ultime funzionalità sperimentali)

$ rustup install 1.70.0
// Installa una versione specifica

// Override per progetto specifico
$ cd mio-progetto-legacy
$ rustup override set 1.65.0
// Ora in questa directory si usa Rust 1.65.0

$ rustup override unset
// Rimuovi l'override

// Componenti aggiuntivi
$ rustup component add rustfmt
// Aggiunge il formattatore di codice

$ rustup component add clippy
// Aggiunge il linter

// Visualizzare documentazione locale
$ rustup doc
// Apre la documentazione offline nel browser

$ rustup doc --std
// Documentazione della standard library

// Disinstallazione
$ rustup self uninstall
// Rimuove completamente Rust e rustup
```

## Risorse

- [Installazione Rust](https://www.rust-lang.org/tools/install)
- [Rustup Book](https://rust-lang.github.io/rustup/)
- [Rustup Repository](https://github.com/rust-lang/rustup)

## Esercizio

Installa Rust sul tuo sistema e verifica che funzioni correttamente:

1. Esegui il comando di installazione per il tuo sistema operativo
2. Ricarica la shell o apri un nuovo terminale
3. Verifica le versioni di `rustc` e `cargo`
4. Crea un semplice file `test.rs` con:
   ```rust
   fn main() {
       println!("Rust funziona!");
   }
   ```
5. Compila ed esegui con `rustc test.rs && ./test`

**Traccia di soluzione:**
```bash
# Installazione
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Segui l'installazione guidata, poi:
source $HOME/.cargo/env

# Verifica
rustc --version
cargo --version

# Crea e compila test
echo 'fn main() { println!("Rust funziona!"); }' > test.rs
rustc test.rs
./test  # Su Windows: ./test.exe
```
