# Configurare VS Code per Rust

## Teoria

Visual Studio Code è l'editor più popolare per lo sviluppo in Rust grazie alla sua leggerezza, estensibilità, e all'ecosistema di estensioni di alta qualità. Configurare correttamente VS Code per Rust significa installare le estensioni giuste, configurare le impostazioni per il formato e linting automatico, e ottimizzare l'integrazione con il toolchain.

L'estensione fondamentale è `rust-analyzer`, che fornisce tutte le funzionalità IDE moderne: autocompletamento intelligente, goto definition, refactoring, inline errors, e molto altro. `rust-analyzer` ha sostituito il precedente RLS (Rust Language Server) ed è molto più veloce e completo. È mantenuta attivamente dalla comunità Rust ed è considerata l'IDE experience definitiva per Rust.

Oltre a `rust-analyzer`, estensioni utili includono: `Even Better TOML` per editing avanzato di Cargo.toml, `CodeLLDB` per debugging nativo, `Error Lens` per mostrare errori direttamente sulla riga interessata, e `Crates` per gestire le dipendenze. Una configurazione ben curata trasforma VS Code in un ambiente di sviluppo professionale per Rust.

## Esempio

Estensioni essenziali da installare:

1. **rust-analyzer** (matklad.rust-analyzer) - LSP completo per Rust
2. **Even Better TOML** (tamasfe.even-better-toml) - Supporto TOML
3. **CodeLLDB** (vadimcn.vscode-lldb) - Debugger nativo
4. **Error Lens** (usernamehw.errorlens) - Errori inline

Configurazione base in `.vscode/settings.json`:

```json
{
  "rust-analyzer.checkOnSave.command": "clippy",
  "editor.formatOnSave": true,
  "[rust]": {
    "editor.defaultFormatter": "rust-lang.rust-analyzer"
  }
}
```

## Pseudocodice

```bash
// INSTALLAZIONE ESTENSIONI

// 1. Apri VS Code
// 2. Vai su Extensions (Ctrl+Shift+X)
// 3. Cerca e installa:

// ESTENSIONE PRINCIPALE
Nome: rust-analyzer
ID: rust-lang.rust-analyzer
Descrizione: LSP per Rust con autocompletamento, refactoring, etc.

// ESTENSIONI CONSIGLIATE

// Even Better TOML
Nome: Even Better TOML
ID: tamasfe.even-better-toml
Descrizione: Syntax highlighting e validazione per TOML

// CodeLLDB (debugger)
Nome: CodeLLDB
ID: vadimcn.vscode-lldb
Descrizione: Debugger nativo per C/C++/Rust

// Error Lens
Nome: Error Lens
ID: usernamehw.errorlens
Descrizione: Mostra errori e warning inline

// Crates
Nome: Crates
ID: serayuzgur.crates
Descrizione: Gestione versioni dipendenze

// Todo Tree
Nome: Todo Tree
ID: gruntfuggly.todo-tree
Descrizione: Visualizza TODO/FIXME nel progetto

// Better Comments
Nome: Better Comments
ID: aaron-bond.better-comments
Descrizione: Commenti evidenziati

// CONFIGURAZIONE SETTINGS.JSON

// File: .vscode/settings.json (progetto-specifico)
// Oppure: VS Code Settings (globale)

{
  // === RUST-ANALYZER ===
  
  // Abilita check con Clippy al salvataggio
  "rust-analyzer.checkOnSave.command": "clippy",
  "rust-analyzer.checkOnSave.extraArgs": ["--all-targets", "--all-features"],
  
  // Abilita procedural macros
  "rust-analyzer.procMacro.enable": true,
  
  // Import automatici
  "rust-analyzer.completion.autoimport.enable": true,
  
  // Highlighting avanzato
  "rust-analyzer.semanticHighlighting.operator.specialization.enable": true,
  "rust-analyzer.semanticHighlighting.punctuation.specialization.enable": true,
  
  // Lens (informazioni inline)
  "rust-analyzer.lens.enable": true,
  "rust-analyzer.lens.implementations.enable": true,
  "rust-analyzer.lens.references.enable": true,
  "rust-analyzer.lens.runnables.enable": true,
  
  // Hover actions
  "rust-analyzer.hover.actions.enable": true,
  "rust-analyzer.hover.actions.implementations.enable": true,
  "rust-analyzer.hover.actions.references.enable": true,
  
  // === FORMATTAZIONE ===
  
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "[rust]": {
    "editor.defaultFormatter": "rust-lang.rust-analyzer",
    "editor.formatOnSave": true
  },
  "[toml]": {
    "editor.defaultFormatter": "tamasfe.even-better-toml"
  },
  
  // === LINTER ===
  
  // Error Lens
  "errorLens.enabled": true,
  "errorLens.highlightStyle": "custom",
  "errorLens.messageBackgroundMode": "message",
  "errorLens.gutterIconsEnabled": true,
  "errorLens.gutterIconSet": "default",
  "errorLens.gutterIconSize": "auto",
  
  // === DEBUG ===
  
  // CodeLLDB
  "lldb.verboseLogging": false,
  "lldb.suppressMissingSourceFiles": true,
  
  // === EDITOR ===
  
  // Raccomandazioni Rust
  "editor.inlayHints.enabled": true,
  "editor.inlayHints.fontSize": 11,
  "editor.inlayHints.fontFamily": "Fira Code",
  
  // Minimap disabilitata per Rust (spazio per inlay hints)
  "[rust]": {
    "editor.minimap.enabled": false
  },
  
  // Word wrap per commenti lunghi
  "editor.wordWrap": "on",
  "editor.wordWrapColumn": 100,
  
  // Rulers
  "editor.rulers": [80, 100, 120],
  
  // === TERMINALE ===
  
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  
  // === FILE ===
  
  // Escludi directory di build
  "files.exclude": {
    "**/target": true,
    "**/.git": true,
    "**/.DS_Store": true
  },
  
  // Watch file
  "files.watcherExclude": {
    "**/target/**": true
  },
  
  // === RICERCA ===
  
  "search.exclude": {
    "**/target": true,
    "**/Cargo.lock": true
  }
}

// CONFIGURAZIONE LAUNCH.JSON (Debug)

// File: .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug executable",
      "cargo": {
        "args": ["build", "--bin=mio-progetto"],
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
    }
  ]
}

// CONFIGURAZIONE TASKS.JSON

// File: .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "cargo",
      "command": "build",
      "problemMatcher": ["$rustc"],
      "group": "build",
      "label": "rust: cargo build"
    },
    {
      "type": "cargo",
      "command": "test",
      "problemMatcher": ["$rustc"],
      "group": "test",
      "label": "rust: cargo test"
    },
    {
      "type": "cargo",
      "command": "clippy",
      "args": ["--all-targets", "--all-features"],
      "problemMatcher": ["$rustc"],
      "group": "build",
      "label": "rust: cargo clippy"
    },
    {
      "type": "cargo",
      "command": "fmt",
      "problemMatcher": [],
      "group": "build",
      "label": "rust: cargo fmt"
    }
  ]
}

// KEYBINDINGS CONSIGLIATI

// Apri keybindings.json e aggiungi:

[
  {
    "key": "ctrl+shift+b",
    "command": "cargo.build"
  },
  {
    "key": "ctrl+shift+t",
    "command": "cargo.test"
  },
  {
    "key": "ctrl+shift+r",
    "command": "cargo.run"
  },
  {
    "key": "f5",
    "command": "rust-analyzer.debug"
  }
]
```

## Risorse

- [rust-analyzer VS Code](https://rust-analyzer.github.io/manual.html#vs-code)
- [VS Code Rust Setup](https://code.visualstudio.com/docs/languages/rust)
- [Rust in VS Code](https://www.jetbrains.com/rust/)

## Esercizio

Configura VS Code per il tuo progetto Rust:

1. Installa l'estensione rust-analyzer
2. Crea il file `.vscode/settings.json` con:
   - Formattazione automatica al salvataggio
   - Check con clippy abilitato
   - Error Lens per visualizzare errori inline
3. Crea `.vscode/launch.json` per debugging
4. Prova a scrivere codice con autocompletamento

**Traccia di soluzione:**
1. Apri VS Code → Extensions → Cerca "rust-analyzer" → Installa
2. Crea directory `.vscode/` nel tuo progetto
3. Crea `settings.json` con la configurazione fornita sopra
4. Crea `launch.json` per debugging
5. Apri un file `.rs` e verifica che appaiano suggerimenti mentre scrivi
6. Salva un file e verifica che si formatti automaticamente
