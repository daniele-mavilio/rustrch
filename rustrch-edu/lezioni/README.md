# Corso: Costruire un Motore di Ricerca in Rust

**Totale:** 53 sezioni, 49,352 parole

---

## Indice dei Contenuti


## 01-fondamenti

- [Introduzione a Rust e perché usarlo per un motore di ricerca](01-fondamenti/01-introduzione-a-rust-e-perche-usarlo-per-un-motore-di-ricerca.md)
- [Ownership: il concetto fondamentale](01-fondamenti/02-ownership-il-concetto-fondamentale.md)
- [Ownership: move semantics e Copy trait](01-fondamenti/03-ownership-move-semantics-e-copy-trait.md)
- [Borrowing: riferimenti immutabili](01-fondamenti/04-borrowing-riferimenti-immutabili.md)
- [Borrowing: riferimenti mutabili e regole del borrow checker](01-fondamenti/05-borrowing-riferimenti-mutabili-e-regole-del-borrow-checker.md)
- [Lifetime: concetti base e annotazioni](01-fondamenti/06-lifetime-concetti-base-e-annotazioni.md)
- [Lifetime: Elision e Casi Comuni](01-fondamenti/07-lifetime-elision-e-casi-comuni.md)
- [Variabili, Tipi Primitivi e Type Inference](01-fondamenti/08-variabili-tipi-primitivi-e-type-inference.md)
- [Stringhe in Rust: String vs &str](01-fondamenti/09-stringhe-in-rust-string-vs-str.md)
- [Tuple, Array e Slice](01-fondamenti/10-tuple-array-e-slice.md)
- [Struct: Definizione e Implementazione](01-fondamenti/11-struct-definizione-e-implementazione.md)
- [Struct: Metodi e Funzioni Associate](01-fondamenti/12-struct-metodi-e-funzioni-associate.md)
- [Enum: Definizione e Varianti con Dati](01-fondamenti/13-enum-definizione-e-varianti-con-dati.md)
- [Enum: Option<T> e Gestione Valori Opzionali](01-fondamenti/14-enum-option-t-e-gestione-valori-opzionali.md)
- [Enum: Result<T, E> e Gestione Errori](01-fondamenti/15-enum-result-t-e-e-gestione-errori.md)
- [Pattern Matching con match](01-fondamenti/16-pattern-matching-con-match.md)
- [Pattern Matching: if let e while let](01-fondamenti/17-pattern-matching-if-let-e-while-let.md)
- [Vettori: Vec<T> e Operazioni Comuni](01-fondamenti/18-vettori-vec-t-e-operazioni-comuni.md)
- [HashMap e Collezioni](01-fondamenti/19-hashmap-e-collezioni.md)
- [Iteratori: Concetti Base e Metodi Principali](01-fondamenti/20-iteratori-concetti-base-e-metodi-principali.md)
- [Iteratori: map, filter, collect e Catene](01-fondamenti/21-iteratori-map-filter-collect-e-catene.md)
- [Trait: Definizione e Implementazione](01-fondamenti/22-trait-definizione-e-implementazione.md)
- [Trait: Trait Bounds e Generics](01-fondamenti/23-trait-trait-bounds-e-generics.md)
- [Closures e Funzioni di Ordine Superiore](01-fondamenti/24-closures-e-funzioni-di-ordine-superiore.md)
- [Moduli e Visibilità: Organizzare il Codice](01-fondamenti/25-moduli-e-visibilita-organizzare-il-codice.md)

## 02-setup

- [Installare Rust con rustup](02-setup/01-installare-rust-con-rustup.md)
- [Componenti della Toolchain: rustc, cargo, rustfmt, clippy](02-setup/02-componenti-della-toolchain-rustc-cargo-rustfmt-clippy.md)
- [Creare il Primo Progetto con cargo new](02-setup/03-creare-il-primo-progetto-con-cargo-new.md)
- [Struttura di un Progetto Cargo](02-setup/04-struttura-di-un-progetto-cargo.md)
- [Cargo.toml: Gestione Dipendenze](02-setup/05-cargo-toml-gestione-dipendenze.md)
- [Cargo.toml: Features e Profili di Compilazione](02-setup/06-cargo-toml-features-e-profili-di-compilazione.md)
- [Configurare VS Code per Rust](02-setup/07-configurare-vs-code-per-rust.md)
- [Configurare rust-analyzer e le Estensioni Utili](02-setup/08-configurare-rust-analyzer-e-le-estensioni-utili.md)
- [Compilazione e Ciclo Edit-Compile-Run](02-setup/09-compilazione-e-ciclo-edit-compile-run.md)
- [Gestione Errori del Compilatore: Leggere i Messaggi](02-setup/10-gestione-errori-del-compilatore-leggere-i-messaggi.md)
- [Cargo build: Debug vs Release](02-setup/11-cargo-build-debug-vs-release.md)
- [Cargo test: Scrivere e Eseguire Test Unitari](02-setup/12-cargo-test-scrivere-e-eseguire-test-unitari.md)
- [Cargo test: Test di Integrazione e Organizzazione](02-setup/13-cargo-test-test-di-integrazione-e-organizzazione.md)
- [Cargo doc: Generare Documentazione](02-setup/14-cargo-doc-generare-documentazione.md)
- [Clippy: Linting e Best Practices Automatiche](02-setup/15-clippy-linting-e-best-practices-automatiche.md)
- [Rustfmt: Formattazione Automatica del Codice](02-setup/16-rustfmt-formattazione-automatica-del-codice.md)
- [Debug con println! e dbg!](02-setup/17-debug-con-println-e-dbg.md)
- [Debug Avanzato con Breakpoint e LLDB/GDB](02-setup/18-debug-avanzato-con-breakpoint-e-lldbgdb.md)
- [Gestione Versioni Rust con rustup](02-setup/19-gestione-versioni-rust-con-rustup.md)
- [Workspace Cargo per Progetti Multi-Crate](02-setup/20-workspace-cargo-per-progetti-multi-crate.md)
- [Pubblicare su crates.io: Preparazione](02-setup/21-pubblicare-su-cratesio-preparazione.md)
- [Continuous Integration per Progetti Rust](02-setup/22-continuous-integration-per-progetti-rust.md)
- [Configurare Git e .gitignore per Rust](02-setup/23-configurare-git-e-gitignore-per-rust.md)

## 03-async

- [Introduzione alla Programmazione Asincrona in Rust](03-async/01-introduzione-alla-programmazione-asincrona.md)
- [Differenza tra Codice Sincrono e Asincrono](03-async/02-differenza-sync-vs-async.md)
- [Il Tipo Future in Rust](03-async/03-il-tipo-future-in-rust.md)
- [Installare Tokio Runtime](03-async/04-installare-tokio-runtime.md)
- [Async/Await in Rust](03-async/05-async-await.md)

---

Generato il 2026-02-02 15:35:43
