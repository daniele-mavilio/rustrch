#!/bin/bash
# ============================================================================
# SCRIPT DI AVVIO - Rustrch Edu su Termux
# ============================================================================

set -e

echo "=========================================="
echo "  Rustrch Edu - Avvio Ralph Orchestrator"
echo "=========================================="
echo ""

# Verifica prerequisiti
echo "🔍 Verifica prerequisiti..."

if ! command -v ralph &> /dev/null; then
    echo "❌ Ralph non trovato. Installa con:"
    echo "   cargo install ralph-orchestrator"
    exit 1
fi
echo "✅ Ralph trovato"

if ! command -v git &> /dev/null; then
    echo "❌ Git non trovato. Installa con:"
    echo "   pkg install git"
    exit 1
fi
echo "✅ Git trovato"

# Inizializza git se necessario
if [ ! -d ".git" ]; then
    echo "📁 Inizializzazione repository git..."
    git init
    git add .
    git commit -m "Setup iniziale progetto educativo Rust"
fi

# Crea directory output se non esiste
mkdir -p lezione
mkdir -p .ralph

echo ""
echo "=========================================="
echo "  CONFIGURAZIONE"
echo "=========================================="
echo ""

# Verifica configurazione Codex/OpenRouter
if [ -z "$OPENROUTER_API_KEY" ] && [ -z "$CODEX_API_KEY" ]; then
    echo "⚠️  Variabili d'ambiente non trovate"
    echo ""
    echo "Se usi OpenRouter, esegui:"
    echo "   export OPENROUTER_API_KEY='sk-or-v1-...'"
    echo ""
    echo "Se usi Codex diretto, esegui:"
    echo "   export CODEX_API_KEY='sk-...'"
    echo ""
    read -p "Vuoi continuare comunque? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "  AVVIO RALPH"
echo "=========================================="
echo ""
echo "⏱️  Durata stimata: 3-4 ore"
echo "📱 Su Termux sarà più lento - sii paziente"
echo ""
echo "Per monitorare in un altro terminale:"
echo "   ralph health"
echo "   ralph tools task list"
echo ""
echo "Per fermare: Ctrl+C"
echo ""
read -p "Premi INVIO per avviare..."

# Avvia Ralph
echo "🚀 Avvio Ralph Orchestrator..."
ralph run -c ralph.yml -p "Inizia la lezione sul motore di ricerca in Rust"

echo ""
echo "=========================================="
echo "  COMPLETATO!"
echo "=========================================="
echo ""
echo "📚 Materiale generato in: lezione/"
echo ""
echo "Prossimi passi:"
echo "1. Leggi i file in lezione/01-crawling/"
echo "2. Fai gli esercizi proposti"
echo "3. Passa alla fase successiva"
echo ""
