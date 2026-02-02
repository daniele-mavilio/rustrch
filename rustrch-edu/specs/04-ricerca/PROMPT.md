# FASE 4: MOTORE DI RICERCA (BM25 + SEMANTICO)

## 🎯 OBIETTIVO DIDATTICO

Insegnare allo studente come combinare ricerca per keyword (BM25) e ricerca semantica (embedding) per risultati migliori.

---

## 📚 CONCETTI RUST DA INSEGNARE

### 1. Ricerca Full-Text
- Indicizzazione testuale
- Tokenizzazione
- Term frequency

### 2. Algoritmo BM25
- Formula matematica
- IDF (Inverse Document Frequency)
- TF (Term Frequency)
- Parametri k1 e b

### 3. Ricerca Ibrida
- Combinare BM25 e similarità embedding
- Pesi e normalizzazione
- Ranking finale

### 4. Strutture per i Risultati
- Struct per risultato di ricerca
- Ordinamento per score
- Limitazione risultati (top-k)

### 5. Iteratori in Rust
- Il trait Iterator
- Metodi come `map`, `filter`, `collect`
- Ordinamento con `sort_by`

---

## 📝 SEZIONI DA GENERARE

### Sezione 4.1: Introduzione alla Fase
- Perché una sola tecnica non basta
- BM25 per keyword esatte
- Embedding per significato
- L'idea della ricerca ibrida

### Sezione 4.2: Tokenizzazione (Teoria)
- Spezzare il testo in parole
- Rimozione stopword (opzionale)
- Stemming (opzionale)

### Sezione 4.3: Algoritmo BM25 (Teoria)
- Spiegazione della formula:
  ```
  score(d, q) = Σ IDF(q_i) * (f(q_i, d) * (k1 + 1)) / (f(q_i, d) + k1 * (1 - b + b * |d| / avgdl))
  ```
- IDF: termini rari valgono di più
- TF: frequenza del termine nel documento
- Parametri k1 e b: tuning

### Sezione 4.4: Pseudocodice per BM25
```plaintext
funzione calcola_idf(termine, totale_documenti, documenti_con_termine):
    numeratore = totale_documenti - documenti_con_termine + 0.5
    denominatore = documenti_con_termine + 0.5
    restituisci log(numeratore / denominatore)

funzione calcola_bm25(documento, query, k1=1.5, b=0.75):
    punteggio = 0
    termini_query = tokenizza(query)
    
    per ogni termine in termini_query:
        tf = conta_frequenza(termine, documento)
        idf = calcola_idf(termine)
        lunghezza_doc = conta_parole(documento)
        lunghezza_media = lunghezza_media_documenti()
        
        numeratore = tf * (k1 + 1)
        denominatore = tf + k1 * (1 - b + b * lunghezza_doc / lunghezza_media)
        
        punteggio = punteggio + (idf * numeratore / denominatore)
    
    restituisci punteggio
```

### Sezione 4.5: Pseudocodice per Ricerca Semantica
```plaintext
funzione ricerca_semantica(query, tutti_file):
    // Genera embedding della query
    query_embedding = genera_embedding(query)
    
    risultati = []
    
    per ogni file in tutti_file:
        se file.embedding esiste:
            similarita = similarita_coseno(query_embedding, file.embedding)
            aggiungi a risultati (file, similarita)
    
    // Ordina per similarità decrescente
    ordina(risultati, per=similarita, decrescente=true)
    
    restituisci risultati
```

### Sezione 4.6: Pseudocodice per Ricerca Ibrida
```plaintext
funzione ricerca_ibrida(query, tutti_file, peso_bm25=0.5, peso_semantico=0.5):
    risultati_bm25 = ricerca_bm25(query, tutti_file)
    risultati_semantici = ricerca_semantica(query, tutti_file)
    
    risultati_combinati = []
    
    per ogni file in tutti_file:
        punteggio_bm25 = cerca_in(risultati_bm25, file) ?? 0
        punteggio_semantico = cerca_in(risultati_semantici, file) ?? 0
        
        // Normalizza i punteggi (opzionale)
        punteggio_bm25_norm = normalizza(punteggio_bm25)
        punteggio_semantico_norm = normalizza(punteggio_semantico)
        
        // Combina con pesi
        punteggio_finale = (peso_bm25 * punteggio_bm25_norm) + 
                           (peso_semantico * punteggio_semantico_norm)
        
        aggiungi a risultati_combinati (file, punteggio_finale)
    
    // Ordina e restituisci top-k
    ordina(risultati_combinati, per=punteggio_finale, decrescente=true)
    restituisci primi_n(risultati_combinati, k=10)
```

### Sezione 4.7: Spiegazione della Ricerca Ibrida
- Perché i pesi sono importanti
- Quando preferire BM25 (keyword esatte)
- Quando preferire semantico (sinonimi, concetti)
- Esempio pratico

### Sezione 4.8: Esercizi e Domande
- 5 domazioni di comprensione
- 2 esercizi pratici (calcoli BM25)
- Riepilogo

---

## 🔗 RISORSE DA CITARE

- [BM25 Algorithm](https://en.wikipedia.org/wiki/Okapi_BM25)
- [Information Retrieval Book](https://nlp.stanford.edu/IR-book/)
- [Hybrid Search Explained](https://www.pinecone.io/learn/hybrid-search/)
- [Rust Iterator Documentation](https://doc.rust-lang.org/std/iter/trait.Iterator.html)

---

## ⚠️ NOTE PER L'AGENT

- BM25 è complesso: spiega la formula pezzo per pezzo
- Usa esempi concreti: "cerca 'rust programming'"
- Mostra come BM25 trova keyword, embedding trova 'linguaggio di sistema'
