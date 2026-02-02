# Configurare rust-analyzer e le Estensioni Utili

## Teoria

`rust-analyzer` è il Language Server Protocol (LSP) per Rust, fornendo funzionalità IDE avanzate come autocompletamento, navigazione del codice, refactoring, analisi statica in tempo reale, e molto altro. A differenza del precedente RLS, rust-analyzer è progettato per essere veloce, responsivo e completo, analizzando il codice in modo incrementale e fornendo feedback immediato mentre scrivi.

L'architettura di rust-analyzer si basa su un'analisi profonda del codice sorgente che va oltre la semplice compilazione. Mantiene un database incrementale del codice che viene aggiornato mentre modifichi i file, permettendo operazioni complesse come "find all references" o "rename symbol" in tempo reale. Questo database include informazioni su tipi, risoluzione dei nomi, trait resolution, e molto altro.

Oltre alle funzionalità standard, rust-analyzer offre feature uniche come "inlay hints" (annotazioni inline che mostrano tipi inferiti e nomi dei parametri), "lens" (azioni contestuali che appaiono sopra funzioni e struct), e integrazione profonda con Cargo. Comprendere come configurare e sfruttare queste funzionalità migliora drasticamente la produttività nello sviluppo Rust.

## Esempio

Configurazione avanzata di rust-analyzer in VS Code per massima produttività:

```json
{
  "rust-analyzer.cargo.features": "all",
  "rust-analyzer.checkOnSave.command": "clippy",
  "rust-analyzer.procMacro.enable": true,
  "rust-analyzer.lens.enable": true,
  "editor.inlayHints.enabled": true
}
```

Questa configurazione:
- Abilita tutte le features durante l'analisi
- Usa clippy per check al salvataggio (più completo del semplice check)
- Abilita le procedural macros (essenziali per serde, tokio, etc.)
- Mostra lens sopra funzioni (Run Test, Debug, etc.)
- Abilita inlay hints per tipi e parametri

## Pseudocodice

```bash
// INSTALLAZIONE RUST-ANALYZER

// VS Code (metodo consigliato)
// Estensioni → Cerca "rust-analyzer" → Installa

// Installazione manuale del server
$ rustup component add rust-analyzer

// Aggiornamento
$ rustup update

// CONFIGURAZIONE COMPLETA RUST-ANALYZER

{
  // === ANALISI DEL CODICE ===
  
  // Features da abilitare nell'analisi
  "rust-analyzer.cargo.features": "all",
  // Opzioni: "all", ["feature1", "feature2"], null
  
  // Target specifico
  "rust-analyzer.cargo.target": null,
  // Esempio: "x86_64-unknown-linux-gnu"
  
  // Check al salvataggio
  "rust-analyzer.checkOnSave.enable": true,
  "rust-analyzer.checkOnSave.command": "clippy",
  // Alternative: "check", "rustc"
  "rust-analyzer.checkOnSave.extraArgs": [],
  "rust-analyzer.checkOnSave.allTargets": true,
  
  // === PROCEDURAL MACROS ===
  
  "rust-analyzer.procMacro.enable": true,
  "rust-analyzer.procMacro.ignored": {
    // Macro da ignorare se problematiche
    "some-macro": ["attribute"]
  },
  
  // === INLAY HINTS (Annotazioni inline) ===
  
  "rust-analyzer.inlayHints.bindingModeHints.enable": false,
  "rust-analyzer.inlayHints.closureReturnTypeHints.enable": "never",
  "rust-analyzer.inlayHints.lifetimeElisionHints.enable": "never",
  "rust-analyzer.inlayHints.parameterHints.enable": true,
  "rust-analyzer.inlayHints.typeHints.enable": true,
  "rust-analyzer.inlayHints.chainingHints.enable": true,
  "rust-analyzer.inlayHints.closureCaptureHints.enable": false,
  "rust-analyzer.inlayHints.discriminantHints.enable": "never",
  "rust-analyzer.inlayHints.expressionAdjustmentHints.enable": "never",
  "rust-analyzer.inlayHints.maxLength": 25,
  "rust-analyzer.inlayHints.renderColons": true,
  
  // === LENS (Azioni contestuali) ===
  
  "rust-analyzer.lens.enable": true,
  "rust-analyzer.lens.debug.enable": true,
  "rust-analyzer.lens.implementations.enable": true,
  "rust-analyzer.lens.references.enable": true,
  "rust-analyzer.lens.references.adt.enable": true,
  "rust-analyzer.lens.references.enumVariant.enable": true,
  "rust-analyzer.lens.references.method.enable": true,
  "rust-analyzer.lens.references.trait.enable": true,
  "rust-analyzer.lens.runnables.enable": true,
  
  // === DIAGNOSTICHE ===
  
  "rust-analyzer.diagnostics.enable": true,
  "rust-analyzer.diagnostics.experimental.enable": false,
  "rust-analyzer.diagnostics.style.enable": true,
  "rust-analyzer.diagnostics.warningsAsHint": [],
  "rust-analyzer.diagnostics.warningsAsInfo": [],
  
  // === COMPLETAMENTO ===
  
  "rust-analyzer.completion.autoimport.enable": true,
  "rust-analyzer.completion.autoself.enable": true,
  "rust-analyzer.completion.postfix.enable": true,
  "rust-analyzer.completion.privateEditable.enable": false,
  "rust-analyzer.completion.snippets.enable": true,
  "rust-analyzer.completion.addCallArgumentSnippets": true,
  "rust-analyzer.completion.addCallParenthesis": true,
  
  // === IMPORT ===
  
  "rust-analyzer.imports.granularity.enable": "crate",
  // Opzioni: "preserve", "crate", "module", "item"
  "rust-analyzer.imports.group.enable": true,
  "rust-analyzer.imports.merge.glob": true,
  "rust-analyzer.imports.prefix": "plain",
  
  // === ASSISTS (Azioni rapide) ===
  
  "rust-analyzer.assist.emitMustUse": false,
  "rust-analyzer.assist.expressionFillDefault": "todo",
  // "todo" o "default"
  
  // === HOVER (Tooltip) ===
  
  "rust-analyzer.hover.actions.enable": true,
  "rust-analyzer.hover.actions.debug.enable": true,
  "rust-analyzer.hover.actions.gotoTypeDef.enable": true,
  "rust-analyzer.hover.actions.implementations.enable": true,
  "rust-analyzer.hover.actions.references.enable": false,
  "rust-analyzer.hover.actions.run.enable": true,
  "rust-analyzer.hover.documentation.enable": true,
  "rust-analyzer.hover.documentation.keywords": true,
  "rust-analyzer.hover.links.enable": true,
  
  // === SIGNATURE HELP ===
  
  "rust-analyzer.signatureInfo.documentation.enable": true,
  "rust-analyzer.signatureInfo.parameters.enable": true,
  
  // === WORKSPACE ===
  
  "rust-analyzer.workspace.symbol.search.kind": "all_symbols",
  "rust-analyzer.workspace.symbol.search.scope": "workspace",
  "rust-analyzer.workspace.symbol.search.limit": 128,
  
  // === CACHE E PERFORMANCE ===
  
  "rust-analyzer.cache.warmup.enable": true,
  "rust-analyzer.cargo.buildScripts.enable": true,
  "rust-analyzer.cargo.buildScripts.overrideCommand": null,
  "rust-analyzer.cargo.buildScripts.useRustcWrapper": true,
  
  // === TESTING ===
  
  "rust-analyzer.testExplorer": false,
  // true per abilitare il Test Explorer UI
  
  // === RUSTFMT ===
  
  "rust-analyzer.rustfmt.extraArgs": [],
  "rust-analyzer.rustfmt.overrideCommand": null,
  "rust-analyzer.rustfmt.rangeFormatting.enable": false,
  
  // === TRACING ===
  
  "rust-analyzer.trace.extension": false,
  "rust-analyzer.trace.server": "off"
}

// ALTRI EDITOR

// Vim/Neovim
// Plugin: rust-tools.nvim (basato su rust-analyzer)
// Configurazione Lua:
// require('rust-tools').setup({
//     tools = {
//         inlay_hints = { auto = true },
//     },
//     server = {
//         on_attach = on_attach,
//         settings = {
//             ["rust-analyzer"] = {
//                 checkOnSave = { command = "clippy" },
//             }
//         }
//     }
// })

// Emacs
// Package: lsp-mode + rust-analyzer
// (use-package rust-mode
//   :hook (rust-mode . lsp))

// IntelliJ IDEA / CLion
// Plugin: Rust (proprietario, non usa rust-analyzer)

// Sublime Text
// Package: LSP + LSP-rust-analyzer

// FUNZIONALITÀ AVANZATE RUST-ANALYZER

// 1. Auto-import
// Quando scrivi un nome non importato, rust-analyzer suggerisce l'import
// e lo aggiunge automaticamente

// 2. Refactoring
// - Rename symbol (F2)
// - Extract variable
// - Extract function
// - Inline variable

// 3. Code Actions
// - Fill match arms
// - Add missing impl members
// - Generate getter/setter
// - Replace if let with match

// 4. Type inference inline
// Mostra i tipi inferiti come annotazioni virtuali nel codice

// 5. Error squiggles in tempo reale
// Mostra errori mentre scrivi, non solo al salvataggio

// TROUBLESHOOTING

// Se rust-analyzer non funziona:
// 1. Verifica che sia installato: rustup component list | grep rust-analyzer
// 2. Riavvia VS Code
// 3. Controlla l'output: View → Output → "Rust Analyzer Language Server"
// 4. Aggiorna: rustup update
// 5. Reinstalla estensione
```

## Risorse

- [rust-analyzer Manual](https://rust-analyzer.github.io/manual.html)
- [Configuration](https://rust-analyzer.github.io/manual.html#configuration)
- [Features](https://rust-analyzer.github.io/manual.html#features)

## Esercizio

Sperimenta con le funzionalità di rust-analyzer:

1. Crea un progetto Cargo e aprilo in VS Code
2. Scrivi una funzione con parametri e osserva gli inlay hints
3. Scrivi `vec!` e usa l'auto-import
4. Definisci un enum e usa "Fill match arms" (lampadina gialla)
5. Fai click su una funzione e premi F12 (Go to Definition)
6. Fai rename di una variabile con F2
7. Attiva lens sopra una funzione con `#[test]` e clicca "Run"

**Traccia di soluzione:**
```rust
// In src/main.rs

use std::collections::HashMap;  // rust-analyzer suggerirà questo import

fn main() {
    let mut scores = HashMap::new();  // Inlay hint: HashMap<&str, i32>
    calcola_punteggio(&mut scores, "Mario", 100);  // Inlay hints parametri
}

fn calcola_punteggio(scores: &mut HashMap<&str, i32>, nome: &str, punti: i32) {
    scores.insert(nome, punti);  // Prova F2 su 'scores' per rename
}

enum Stato {
    Attivo,
    Inattivo,
    Sospeso(String),
}

fn gestisci_stato(stato: Stato) {
    // Scrivi 'match stato {' e usa "Fill match arms"
    match stato {
        Stato::Attivo => todo!(),
        Stato::Inattivo => todo!(),
        Stato::Sospeso(_) => todo!(),
    }
}

#[test]
fn test_somma() {
    // Lens "Run" apparirà sopra questa funzione
    assert_eq!(2 + 2, 4);
}
```
