# FASE 3: GENERAZIONE DI EMBEDDING

## 🎯 OBIETTIVO DIDATTICO

Insegnare allo studente cosa sono gli embedding e come usarli per la ricerca semantica in Rust.

---

## 📚 CONCETTI RUST DA INSEGNARE

### 1. Cos'è un Embedding
- Vettori di numeri che rappresentano significato
- Da testo a numeri (vettori)
- Similarità semantica

### 2. Machine Learning in Rust
- ONNX Runtime
- Modelli pre-addestrati
- Inferenza locale

### 3. La Crate Ort
- Caricare modelli ONNX
- Preparare input
- Eseguire inferenza

### 4. Vettori e Operazioni
- Vettori in Rust (`Vec<f32>`)
- Similarità del coseno (formula matematica)
- Distanza euclidea (opzionale)

### 5. Memorizzazione degli Embedding
- Blob in SQLite
- Serializzazione vettori
- Recupero e deserializzazione

---

## 📝 SEZIONI DA GENERARE

### Sezione 3.1: Introduzione alla Fase
- Perché serve la ricerca semantica
- Limiti della ricerca per keyword
- Overview degli embedding

### Sezione 3.2: Cos'è un Embedding (Teoria)
- Analogia: embedding = coordinate semantiche
- Esempio visivo (descrivere)
- Similarità = vicinanza nello spazio vettoriale

### Sezione 3.3: Machine Learning in Rust
- ONNX come standard
- Modelli di sentence embedding (es: all-MiniLM)
- Vantaggi dell'inferenza locale

### Sezione 3.4: Pseudocodice per Generare Embedding
```plaintext
funzione carica_modello(percorso_modello):
    sessione = onnx.carica(percorso_modello)
    restituisci sessione

funzione genera_embedding(sessione, testo):
    // Tokenizza il testo
    tokens = tokenizza(testo)
    
    // Prepara input per il modello
    input = prepara_input(tokens)
    
    // Esegui inferenza
    output = sessione.esegui(input)
    
    // Estrai il vettore embedding
    embedding = output[0]
    
    restituisci embedding

funzione salva_embedding(connessione, file_id, embedding):
    embedding_serializzato = serializza(embedding)
    esegui_query(connessione,
        "AGGIORNA file SET embedding = ? DOVE id = ?",
        [embedding_serializzato, file_id]
    )
```

### Sezione 3.5: Similarità del Coseno (Teoria)
- Formula matematica
- Interpretazione: 1 = identici, 0 = ortogonali
- Perché si usa per gli embedding

### Sezione 3.6: Pseudocodice per Calcolare Similarità
```plaintext
funzione similarita_coseno(vettore_a, vettore_b):
    prodotto_scalare = 0
    norma_a = 0
    norma_b = 0
    
    per i da 0 a lunghezza(vettore_a):
        prodotto_scalare = prodotto_scalare + (vettore_a[i] * vettore_b[i])
        norma_a = norma_a + (vettore_a[i] * vettore_a[i])
        norma_b = norma_b + (vettore_b[i] * vettore_b[i])
    
    norma_a = radice_quadrata(norma_a)
    norma_b = radice_quadrata(norma_b)
    
    similarita = prodotto_scalare / (norma_a * norma_b)
    restituisci similarita
```

### Sezione 3.7: Esercizi e Domande
- 5 domande di comprensione
- 2 esercizi pratici (calcoli a mano)
- Riepilogo

---

## 🔗 RISORSE DA CITARE

- [Ort Documentation](https://docs.rs/ort/latest/ort/)
- [ONNX Runtime](https://onnxruntime.ai/)
- [Sentence Transformers](https://www.sbert.net/)
- [Understanding Embeddings](https://jalammar.github.io/illustrated-word2vec/)
- [Cosine Similarity Explained](https://en.wikipedia.org/wiki/Cosine_similarity)

---

## ⚠️ NOTE PER L'AGENT

- Gli embedding sono concetto astratto: usa analogie (coordinate, GPS)
- La similarità del coseno: spiega la formula passo passo
- Enfatizza che il modello ONNX è una "black box" che trasforma testo in numeri
