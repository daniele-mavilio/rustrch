#!/bin/bash
# Batch create tasks for L3-L8

# L3: Setup and async
ralph tools task add "[L3.01] Osservazioni Iniziali su Setup Ambiente Rust" -p 1
ralph tools task add "[L3.02] Comandi Cargo Essenziali per il Progetto" -p 1
ralph tools task add "[L3.03] Organizzazione del Progetto Lezioni con Rust" -p 1
ralph tools task add "[L3.04] Panoramica sul Concetto di Asincronia" -p 1
ralph tools task add "[L3.05] Futures e async/await in Rust" -p 1
ralph tools task add "[L3.06] Runtime Async con Tokio" -p 1
ralph tools task add "[L3.07] Crawling Web per la Raccolta Dati" -p 1
ralph tools task add "[L3.08] Libreria Reqwest per HTTP Requests" -p 1
ralph tools task add "[L3.09] Gestione Errori in Operazioni Async" -p 1
ralph tools task add "[L3.10] Parallelismo con tokio::spawn" -p 1
ralph tools task add "[L3.11] Combinazione di Future con join! e select!" -p 1
ralph tools task add "[L3.12] Stream e Gestione di Flussi di Dati" -p 1
ralph tools task add "[L3.13] Timeout e Cancellazione di Task" -p 1
ralph tools task add "[L3.14] Debug di Programmazione Asincrona" -p 1
ralph tools task add "[L3.15] Strumenti di Testing per Codice Async" -p 1
ralph tools task add "[L3.16] Benchmarking delle Prestazioni Async" -p 1
ralph tools task add "[L3.17] Gestione della Memoria in Ambiente Async" -p 1
ralph tools task add "[L3.18] Sicurezza e Asynchronous Safety" -p 1
ralph tools task add "[L3.19] Esposizione API REST con Hyper" -p 1
ralph tools task add "[L3.20] Middleware per Routing HTTP" -p 1
ralph tools task add "[L3.21] Gestione delle Sessioni in Web API" -p 1
ralph tools task add "[L3.22] Autenticazione Base per il Crawler" -p 1
ralph tools task add "[L3.23] Rate Limiting nelle Requests" -p 1
ralph tools task add "[L3.24] Retry e Backoff nei Crawling" -p 1
ralph tools task add "[L3.25] Logging Strutturato in Ambiente Async" -p 1

# L4: Database
ralph tools task add "[L4.01] Introduzione a SQLite per Persistenza Dati" -p 1
ralph tools task add "[L4.02] Crate rusqlite per Integrazione con Rust" -p 1
ralph tools task add "[L4.03] Schema del Database per Motore di Ricerca" -p 1
ralph tools task add "[L4.04] Operazioni CRUD su SQLite" -p 1
ralph tools task add "[L4.05] Transazioni Database per Sicurezza" -p 1
ralph tools task add "[L4.06] Ottimizzazioni con Indici" -p 1
ralph tools task add "[L4.07] Gestione degli Errori del Database" -p 1
ralph tools task add "[L4.08] Connection Pooling con r2d2" -p 1
ralph tools task add "[L4.09] Migrations del Database" -p 1
ralph tools task add "[L4.10] Serializzazione Dati con Serde" -p 1
ralph tools task add "[L4.11] Query Parametrizzate per Sicurezza" -p 1
ralph tools task add "[L4.12] Bulk Insert per Performance" -p 1
ralph tools task add "[L4.13] Backup e Restore del Database" -p 1
ralph tools task add "[L4.14] Compatibilità Cross Platform" -p 1
ralph tools task add "[L4.15] Full-Text Search in SQLite" -p 1
ralph tools task add "[L4.16] Triggers e Views Personalizzate" -p 1
ralph tools task add "[L4.17] Monitoraggio Prestazioni Database" -p 1
ralph tools task add "[L4.18] Integrazione con async Runtime" -p 1
ralph tools task add "[L4.19] Testing del Layer Database" -p 1
ralph tools task add "[L4.20] Architettura Repository Pattern" -p 1
ralph tools task add "[L4.21]Caching di Query Result" -p 1
ralph tools task add "[L4.22]Gestione delle Relazioni Normalized" -p 1
ralph tools task add "[L4.23] Analisi Statistiche sul Database" -p 1
ralph tools task add "[L4.24] Ottimizzazioni per Memória Limitata" -p 1
ralph tools task add "[L4.25] Sicurezza e Sanitizzazione Input" -p 1

# L5: ML
ralph tools task add "[L5.01] Introduzione al Machine Learning per Ricerca" -p 1
ralph tools task add "[L5.02] Crate ONNX per Modelli Embedding" -p 1
ralph tools task add "[L5.03] Caricamento di Modelli Embedding" -p 1
ralph tools task add "[L5.04] Generazione di Vettori Embedding" -p 1
ralph tools task add "[L5.05] Operazioni sui Vettori in Rust" -p 1
ralph tools task add "[L5.06] Calcolo della Somiglianza Cosine" -p 1
ralph tools task add "[L5.07] Indexing dei Vettori Embedding" -p 1
ralph tools task add "[L5.08] ANN attraverso HNSW" -p 1
ralph tools task add "[L5.09] Libreria hnsw per Rust" -p 1
ralph tools task add "[L5.10] Configurazione e Tuning di HNSW" -p 1
ralph tools task add "[L5.11] Query ANN per Ricerche Semantiche" -p 1
ralph tools task add "[L5.12] Integrazione di Embedding e ANN" -p 1
ralph tools task add "[L5.13] Gestione Errori nei Modelli ML" -p 1
ralph tools task add "[L5.14] Ottimizzazione della Memoria per ML" -p 1
ralph tools task add "[L5.15] Benchmarking performance ANN" -p 1
ralph tools task add "[L5.16] Vectorizzazione di dati di input" -p 1
ralph tools task add "[L5.17] Preprocessing testi per Embedding" -p 1
ralph tools task add "[L5.18] Batch processing di embedding" -p 1
ralph tools task add "[L5.19] Guadare esigenze inferenza vs training" -p 1
ralph tools task add "[L5.20] Deployment modelli leggeri" -p 1
ralph tools task add "[L5.21] Cross-validation dati" -p 1
ralph tools task add "[L5.22] Monitoring accuracy modelli" -p 1
ralph tools task add "[L5.23] Update incrementale embedding" -p 1
ralph tools task add "[L5.24] Scalabilità pipeline ML" -p 1
ralph tools task add "[L5.25] Sicurezza in esecuzione modelli" -p 1

# L6: Search
ralph tools task add "[L6.01] Fondamenti di Algoritmi di Ricerca" -p 1
ralph tools task add "[L6.02] Tokenizzazione del Testo" -p 1
ralph tools task add "[L6.03] Crate per Natural Language Processing" -p 1
ralph tools task add "[L6.04] Stemming e Lemmatizzazione" -p 1
ralph tools task add "[L6.05] Rimozione di Stop Words" -p 1
ralph tools task add "[L6.06] Costruzione dell'Inverted Index" -p 1
ralph tools task add "[L6.07] Strutture Dati per indici Inverted" -p 1
ralph tools task add "[L6.08] Memorizzazione su Disco dell'Indice" -p 1
ralph tools task add "[L6.09] Algoritmo BM25 per Scoring" -p 1
ralph tools task add "[L6.10] Implementazione BM25 Step by Step" -p 1
ralph tools task add "[L6.11] Ottimizzazioni per BM25" -p 1
ralph tools task add "[L6.12] Multi-Field Search con BM25" -p 1
ralph tools task add "[L6.13] Ranking Finale dei Risultati" -p 1
ralph tools task add "[L6.14] Query Parsing attraverso Parser" -p 1
ralph tools task add "[L6.15] Gestione delle Boolean Queries" -p 1
ralph tools task add "[L6.16] Fuzzy Matching per tolleranza errori" -p 1
ralph tools task add "[L6.17] Gestione dei Sinonimi" -p 1
ralph tools task add "[L6.18] Paginazione dei Risultati" -p 1
ralph tools task add "[L6.19] Highlights dei Snippets" -p 1
ralph tools task add "[L6.20] Caching Query Results" -p 1
ralph tools task add "[L6.21] Monitoraggio Performance Search" -p 1
ralph tools task add "[L6.22] Supporto per Multiple Lingue" -p 1
ralph tools task add "[L6.23] Search in Tempo Reale" -p 1
ralph tools task add "[L6.24] Ottimizzazioni per Query Frequent" -p 1
ralph tools task add "[L6.25] Sicurezza nella Preparazione Query" -p 1

# L7: Performance
ralph tools task add "[L7.01] Parallelismo con crate Rayon" -p 1
ralph tools task add "[L7.02] Iteratori Parallel per Dati Grandi" -p 1
ralph tools task add "[L7.03] Integrazione Rayon con Async" -p 1
ralph tools task add "[L7.04] Benchmarking con Criterion" -p 1
ralph tools task add "[L7.05] Misurazione Tempi di Esecuzione" -p 1
ralph tools task add "[L7.06] Profiling del Codice Rust" -p 1
ralph tools task add "[L7.07] Strumenti per Analisi Prestazioni" -p 1
ralph tools task add "[L7.08] Ottimizzazioni di Memoria" -p 1
ralph tools task add "[L7.09] Uso Intelligente di Rc e Arc" -p 1
ralph tools task add "[L7.10] Evitare Allocazioni Inutili" -p 1
ralph tools task add "[L7.11] Caching Strategie Efficienti" -p 1
ralph tools task add "[L7.12] LRU Cache Implementation" -p 1
ralph tools task add "[L7.13] Compression Dati per Storage" -p 1
ralph tools task add "[L7.14] Ottimizzazioni I/O Disk" -p 1
ralph tools task add "[L7.15] Async I/O per Alta Throughput" -p 1
ralph tools task add "[L7.16] Rate Limiting e Throttling" -p 1
ralph tools task add "[L7.17] Scalabilità Orizontale" -p 1
ralph tools task add "[L7.18] Monitoraggio Risorse di Sistema" -p 1
ralph tools task add "[L7.19] Evasione Memory Leaks" -p 1
ralph tools task add "[L7.20] Zero-Copy Operations" -p 1
ralph tools task add "[L7.21] SIMD per Vector Processing" -p 1
ralph tools task add "[L7.22] CPU Cache Aware Algorithms" -p 1
ralph tools task add "[L7.23] Profiling async Tasks" -p 1
ralph tools task add "[L7.24] Balancing Load Workloads" -p 1
ralph tools task add "[L7.25] Tuning Garbage Collection in Rust" -p 1

# L8: Deployment
ralph tools task add "[L8.01] Build in Release Mode" -p 1
ralph tools task add "[L8.02] Ottimizzazioni Compilation" -p 1
ralph tools task add "[L8.03] Packaging Applicazioni Rust" -p 1
ralph tools task add "[L8.04] Docker Images per Deployment" -p 1
ralph tools task add "[L8.05] Containerization con cargo2dockertools" -p 1
ralph tools task add "[L8.06] Orchestrazione con Kubernetes" -p 1
ralph tools task add "[L8.07] Configurazione Ambiente Production" -p 1
ralph tools task add "[L8.08] Logging Production" -p 1
ralph tools task add "[L8.09] Monitoring Applicazioni" -p 1
ralph tools task add "[L8.10] Gestione degli Errori Production" -p 1
ralph tools task add "[L8.11] Backup e Disaster Recovery" -p 1
ralph tools task add "[L8.12] Sicurezza in Ambiente Production" -p 1
ralph tools task add "[L8.13] Ottimizzazioni per Cloud Deployment" -p 1
ralph tools task add "[L8.14] Scaling Horizontal nel Cloud" -p 1
ralph tools task add "[L8.15] Cost Optimization" -p 1
ralph tools task add "[L8.16] CI/CD Pipeline Setup" -p 1
ralph tools task add "[L8.17] Automazione Tests in CI" -p 1
ralph tools task add "[L8.18] Release Management" -p 1
ralph tools task add "[L8.19] Versionamento API" -p 1
ralph tools task add "[L8.20] Documentazione per Utenti" -p 1
ralph tools task add "[L8.21] Supporto e Maintenance" -p 1
ralph tools task add "[L8.22] Upgrade Dependencies" -p 1
ralph tools task add "[L8.23] Handling Breaking Changes" -p 1
ralph tools task add "[L8.24] User Feedback Integration" -p 1
ralph tools task add "[L8.25] Roadmap Futuro Sviluppo" -p 1
