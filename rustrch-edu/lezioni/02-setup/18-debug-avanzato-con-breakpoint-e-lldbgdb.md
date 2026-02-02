# Debug Avanzato con Breakpoint e LLDB/GDB

## Teoria

Per debugging complesso che richiede ispezione dettagliata dello stato del programma, esecuzione passo-passo, e analisi di crash, i debugger nativi come LLDB (su macOS/Linux) o GDB (su Linux) sono strumenti essenziali. Questi debugger permettono di fermare l'esecuzione in punti specifici (breakpoint), esaminare variabili, modificare il flusso di esecuzione, e analizzare stack trace.

In Rust, il debugging con LLDB/GDB richiede che il codice sia compilato con simboli di debug (`debug = true` nel profilo dev, che è il default). Rust genera informazioni di debug compatibili con i debugger standard, permettendo di vedere variabili Rust, stack trace, e strutture dati. Tuttavia, a causa delle ottimizzazioni del compilatore e del sistema di ownership, alcune variabili potrebbero apparire ottimizzate via o con nomi mangled.

VS Code con l'estensione CodeLLDB fornisce un'interfaccia grafica comoda per il debugging, ma conoscere i comandi base di LLDB/GDB è utile per situazioni dove un IDE non è disponibile o per debugging remoto. I comandi fondamentali sono: `break` (imposta breakpoint), `run` (esegui), `next` (passo avanti), `step` (entra nella funzione), `continue` (riprendi), `print` (stampa variabile), e `backtrace` (mostra stack).

## Esempio

Sessione LLDB semplice:

```bash
$ lldb target/debug/mio-progetto
(lldb) breakpoint set --name main
(lldb) run
(lldb) next
(lldb) print variabile
(lldb) continue
```

Con VS Code, puoi impostare breakpoint cliccando sul margine sinistro e premere F5 per avviare il debug.

## Pseudocodice

```bash
// COMPILAZIONE CON DEBUG INFO

// Il profilo dev ha già debug = true (default)
$ cargo build

// Per release con debug info (per debuggare codice ottimizzato)
[profile.release]
debug = true
opt-level = 3

// DEBUGGING CON LLDB

// Avvia LLDB con il tuo programma
$ lldb target/debug/mio-progetto

// Comandi base LLDB:
// (lldb) breakpoint set --name nome_funzione
// (lldb) breakpoint set --file main.rs --line 10
// (lldb) run
// (lldb) next          # Passa alla riga successiva
// (lldb) step          # Entra nella funzione
// (lldb) finish        # Esci dalla funzione corrente
// (lldb) continue      # Continua esecuzione
// (lldb) print variabile
// (lldb) frame variable
// (lldb) backtrace     # Stack trace
// (lldb) quit

// Esempio sessione LLDB
$ lldb target/debug/mio-progetto
(lldb) b main.rs:15           # Breakpoint a linea 15
(lldb) r                      # Run
Process 12345 stopped
* thread #1, name = 'main', stop reason = breakpoint 1.1
    frame #0: mio-progetto`main at main.rs:15
   12      let x = 5;
   13      let y = 10;
   14      let risultato = somma(x, y);
-> 15      println!("{}", risultato);
   16  }

(lldb) p x                    # Print x
(int) $0 = 5
(lldb) p risultato            # Print risultato
(int) $1 = 15
(lldb) n                      # Next
(lldb) c                      # Continue
(lldb) q                      # Quit

// DEBUGGING CON GDB

// Avvia GDB
$ gdb target/debug/mio-progetto

// Comandi GDB:
// (gdb) break main.rs:15
// (gdb) run
// (gdb) next
// (gdb) print variabile
// (gdb) continue
// (gdb) quit

// Esempio GDB
$ gdb target/debug/mio-progetto
(gdb) break main
(gdb) run
(gdb) next
(gdb) print x
$1 = 5
(gdb) backtrace
#0  main () at src/main.rs:10
(gdb) quit

// DEBUGGING IN VS CODE

// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug executable",
      "cargo": {
        "args": ["build"],
        "filter": {
          "name": "mio-progetto",
          "kind": "bin"
        }
      },
      "args": [],
      "cwd": "${workspaceFolder}"
    },
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug unit tests",
      "cargo": {
        "args": ["test", "--no-run"],
        "filter": {
          "name": "mio-progetto",
          "kind": "lib"
        }
      },
      "args": [],
      "cwd": "${workspaceFolder}"
    },
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug example",
      "cargo": {
        "args": ["build", "--example=example_name"],
        "filter": {
          "name": "example_name",
          "kind": "example"
        }
      },
      "args": [],
      "cwd": "${workspaceFolder}"
    }
  ]
}

// DEBUGGING FEATURES IN RUST

// 1. Panic con backtrace
$ RUST_BACKTRACE=1 cargo run
$ RUST_BACKTRACE=full cargo run

// 2. Breakpoint condizionali in LLDB
(lldb) breakpoint set --name calcola --condition 'x > 10'

// 3. Watchpoint (breakpoint su variabile)
(lldb) watchpoint set variable contatore
(lldb) watchpoint set expression -- (int*)0x12345678

// 4. Esaminare strutture Rust
(lldb) frame variable
(lldb) p *my_struct

// 5. Stack trace
(lldb) thread backtrace all

// CORE DUMP ANALYSIS

// Genera core dump su panic/crash
$ ulimit -c unlimited
$ cargo run
# (quando crasha)
$ lldb target/debug/mio-progetto -c core

// REMOTE DEBUGGING

// Su server remoto:
$ lldb-server platform --listen "*:1234" --server

// Su client locale:
$ lldb
(lldb) platform select remote-linux
(lldb) platform connect connect://server:1234
(lldb) file target/debug/mio-progetto
(lldb) run

// TIPS PER DEBUG RUST

// 1. Usa assert! per invarianti
fn funzione_critica(x: i32) {
    assert!(x >= 0, "x deve essere positivo, era: {}", x);
    // ...
}

// 2. Stampa stack trace su panic
std::env::set_var("RUST_BACKTRACE", "1");

// 3. Usa expect per messaggi utili
let file = std::fs::read_to_string("config.txt")
    .expect("Impossibile leggere config.txt");

// 4. Debugging async (più complesso)
// Compila con debug = true
// Usa strumenti specifici per async se necessario

// 5. Valgrind per memory leaks (Linux)
$ valgrind --leak-check=full ./target/debug/mio-progetto

// 6. Sanitizers per bug detection
// AddressSanitizer
$ RUSTFLAGS="-Z sanitizer=address" cargo run

// 7. Miri per verificare unsafe code
$ cargo install miri
$ rustup component add miri
$ cargo miri run

// COMANDI UTILI LLDB

// Breakpoint:
(lldb) b main.rs:10
(lldb) b nome_funzione
(lldb) breakpoint list
(lldb) breakpoint delete 1

// Esecuzione:
(lldb) run
(lldb) run arg1 arg2
(lldb) continue
(lldb) next
(lldb) step
(lldb) finish

// Ispezione:
(lldb) print variabile
(lldb) frame variable
(lldb) expr variabile * 2
(lldb) memory read &variabile

// Stack:
(lldb) backtrace
(lldb) frame select 2
(lldb) up
(lldb) down

// Thread:
(lldb) thread list
(lldb) thread select 2

// COMANDI UTILI GDB

// Simili a LLDB ma sintassi diversa:
(gdb) break main.rs:10
(gdb) run
(gdb) continue
(gdb) next
(gdb) step
(gdb) print variabile
(gdb) backtrace
(gdb) info locals
(gdb) info args
```

## Risorse

- [Debugging in VS Code](https://code.visualstudio.com/docs/languages/rust#_debugging)
- [LLDB Tutorial](https://lldb.llvm.org/use/tutorial.html)
- [GDB Documentation](https://www.gnu.org/software/gdb/documentation/)

## Esercizio

Pratica il debugging con LLDB:

1. Crea un progetto con un bug:
```rust
fn main() {
    let numeri = vec![1, 2, 3, 4, 5];
    let risultato = calcola_media(&numeri);
    println!("Media: {}", risultato);
}

fn calcola_media(numeri: &[i32]) -> f64 {
    let somma: i32 = numeri.iter().sum();
    somma as f64 / numeri.len()  // Bug: divisione intera!
}
```

2. Compila con `cargo build`
3. Avvia LLDB: `lldb target/debug/nome-progetto`
4. Imposta breakpoint su `calcola_media`
5. Esegui con `run`
6. Ispeziona `somma` e `numeri.len()`
7. Trova il bug (divisione tra interi invece che float)
8. Correggi e verifica

**Traccia di soluzione:**
```rust
// Bug:
somma as f64 / numeri.len()
// Divisione intera! numeri.len() è usize

// Fix:
somma as f64 / numeri.len() as f64
```
