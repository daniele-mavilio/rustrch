# Continuous Integration per Progetti Rust

## Teoria

La Continuous Integration (CI) è una pratica fondamentale nello sviluppo software moderno che prevede l'integrazione automatica del codice in un repository condiviso più volte al giorno. Per progetti Rust, CI automatizza la verifica che il codice compili correttamente, passi tutti i test, rispetti le convenzioni di stile, e soddisfi altri requisiti di qualità prima di essere integrato nel branch principale.

Una pipeline CI tipica per Rust include: compilazione su multiple piattaforme (Linux, macOS, Windows), esecuzione di test unitari e di integrazione, verifica di formattazione con rustfmt, linting con clippy, generazione di documentazione, e calcolo di code coverage. Alcune pipeline includono anche test di cross-compilazione per architetture diverse, test di MSRV (Minimum Supported Rust Version), e security auditing.

GitHub Actions è la soluzione CI più comune per progetti Rust open source grazie alla sua integrazione nativa con GitHub e la disponibilità di runner gratuiti per repository pubblici. Esistono anche alternative come GitLab CI, Travis CI, CircleCI, e Azure Pipelines, tutte configurabili con file YAML che definiscono i passaggi della pipeline.

## Esempio

Configurazione GitHub Actions base per Rust:

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
      - run: cargo build --verbose
      - run: cargo test --verbose
```

Questo workflow si attiva su ogni push e pull request, checkout del codice, setup dell'ambiente Rust, e esegue build e test.

## Pseudocodice

```yaml
// GITHUB ACTIONS - CONFIGURAZIONE COMPLETA

// File: .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  CARGO_TERM_COLOR: always

jobs:
  // Test su multiple piattaforme
  test:
    name: Test
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        rust: [stable, beta]
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Rust
        uses: dtolnay/rust-action@master
        with:
          toolchain: ${{ matrix.rust }}
      
      - name: Cache cargo registry
        uses: actions/cache@v3
        with:
          path: ~/.cargo/registry
          key: ${{ runner.os }}-cargo-registry-${{ hashFiles('**/Cargo.lock') }}
      
      - name: Cache cargo index
        uses: actions/cache@v3
        with:
          path: ~/.cargo/git
          key: ${{ runner.os }}-cargo-index-${{ hashFiles('**/Cargo.lock') }}
      
      - name: Cache cargo build
        uses: actions/cache@v3
        with:
          path: target
          key: ${{ runner.os }}-cargo-build-target-${{ hashFiles('**/Cargo.lock') }}
      
      - name: Build
        run: cargo build --verbose
      
      - name: Run tests
        run: cargo test --verbose

  // Verifica formattazione
  fmt:
    name: Rustfmt
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
        with:
          components: rustfmt
      - run: cargo fmt --all -- --check

  // Linting con clippy
  clippy:
    name: Clippy
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
        with:
          components: clippy
      - run: cargo clippy --all-targets --all-features -- -D warnings

  // Test MSRV
  msrv:
    name: MSRV
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@master
        with:
          toolchain: 1.65.0  # Specifica MSRV
      - run: cargo build --verbose
      - run: cargo test --verbose

  // Documentazione
  doc:
    name: Documentation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
      - run: cargo doc --no-deps
        env:
          RUSTDOCFLAGS: -D warnings

  // Code coverage
  coverage:
    name: Code Coverage
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
      - name: Install tarpaulin
        run: cargo install cargo-tarpaulin
      - name: Generate coverage
        run: cargo tarpaulin --verbose --all-features --workspace --timeout 120 --out xml
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./cobertura.xml
          fail_ci_if_error: false

  // Security audit
  security-audit:
    name: Security Audit
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions-rs/audit-check@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

// WORKFLOW DI RELEASE

// File: .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    name: Release
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        include:
          - os: ubuntu-latest
            target: x86_64-unknown-linux-gnu
            suffix: ''
          - os: windows-latest
            target: x86_64-pc-windows-msvc
            suffix: '.exe'
          - os: macos-latest
            target: x86_64-apple-darwin
            suffix: ''
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
      
      - name: Build release
        run: cargo build --release --target ${{ matrix.target }}
      
      - name: Package
        shell: bash
        run: |
          cd target/${{ matrix.target }}/release
          tar czvf ../../../mia-app-${{ matrix.target }}.tar.gz mia-app${{ matrix.suffix }}
          cd -
      
      - name: Release
        uses: softprops/action-gh-release@v1
        with:
          files: mia-app-*.tar.gz
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

// GITLAB CI

// File: .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  CARGO_HOME: $CI_PROJECT_DIR/cargo
  APT_CACHE_DIR: $CI_PROJECT_DIR/apt

cache:
  paths:
    - cargo/
    - target/

test:
  stage: test
  image: rust:latest
  script:
    - cargo test --verbose
  cache:
    key: "${CI_COMMIT_REF_SLUG}"
    paths:
      - target/

fmt:
  stage: test
  image: rust:latest
  script:
    - rustup component add rustfmt
    - cargo fmt --all -- --check

clippy:
  stage: test
  image: rust:latest
  script:
    - rustup component add clippy
    - cargo clippy --all-targets --all-features -- -D warnings

build:
  stage: build
  image: rust:latest
  script:
    - cargo build --release
  artifacts:
    paths:
      - target/release/

// TRAVIS CI

// File: .travis.yml
language: rust
rust:
  - stable
  - beta
  - nightly
matrix:
  allow_failures:
    - rust: nightly
  fast_finish: true
cache: cargo
script:
  - cargo build --verbose
  - cargo test --verbose
  - cargo fmt --all -- --check
  - cargo clippy --all-targets --all-features -- -D warnings

// CIRCLECI

// File: .circleci/config.yml
version: 2.1

jobs:
  build:
    docker:
      - image: cimg/rust:1.70.0
    steps:
      - checkout
      - restore_cache:
          key: project-cache
      - run:
          name: Build
          command: cargo build
      - run:
          name: Test
          command: cargo test
      - save_cache:
          key: project-cache
          paths:
            - "~/.cargo"
            - "./target"

workflows:
  version: 2
  build_and_test:
    jobs:
      - build

// AZURE PIPELINES

// File: azure-pipelines.yml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: UseRust@1
    inputs:
      version: 'stable'
  
  - script: cargo build --verbose
    displayName: 'Build'
  
  - script: cargo test --verbose
    displayName: 'Test'
  
  - script: cargo fmt --all -- --check
    displayName: 'Check formatting'

// STRATEGIE CI AVANZATE

// 1. Test con features diverse
- run: cargo test --no-default-features
- run: cargo test --all-features

// 2. Cross-compilazione
- run: rustup target add wasm32-unknown-unknown
- run: cargo build --target wasm32-unknown-unknown

// 3. Test di documentazione
- run: cargo test --doc

// 4. Bench in CI (con cautela)
- run: cargo bench --no-fail-fast

// 5. Check di semver
- run: cargo install cargo-semver-checks
- run: cargo semver-checks

// BADGES

// In README.md, aggiungi badges:
// [![CI](https://github.com/user/repo/actions/workflows/ci.yml/badge.svg)](https://github.com/user/repo/actions)
// [![Coverage](https://codecov.io/gh/user/repo/branch/main/graph/badge.svg)](https://codecov.io/gh/user/repo)
// [![Crates.io](https://img.shields.io/crates/v/mia-crate.svg)](https://crates.io/crates/mia-crate)
// [![Docs.rs](https://docs.rs/mia-crate/badge.svg)](https://docs.rs/mia-crate)
```

## Risorse

- [GitHub Actions](https://docs.github.com/en/actions)
[GitLab CI](https://docs.gitlab.com/ee/ci/)
- [Travis CI](https://docs.travis-ci.com/)

## Esercizio

Crea una CI pipeline per un progetto Rust:

1. Crea un progetto "ci-demo" con Git repository
2. Crea `.github/workflows/ci.yml` con:
   - Build e test su Ubuntu
   - Verifica formattazione
   - Linting con clippy
3. Fai un commit che viola la formattazione
4. Verifica che la CI fallisca
5. Correggi e verifica che passi

**Traccia di soluzione:**
```bash
# 1. Crea progetto
cargo new ci-demo
cd ci-demo
git init
git add .
git commit -m "Initial commit"

# 2. Crea workflow
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
      - run: cargo build
      - run: cargo test

  fmt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
        with:
          components: rustfmt
      - run: cargo fmt --all -- --check

  clippy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dtolnay/rust-action@stable
        with:
          components: clippy
      - run: cargo clippy -- -D warnings
EOF

# 3. Commit workflow
git add .github/workflows/ci.yml
git commit -m "Add CI workflow"

# 4. Crea errore di formattazione
echo 'fn main(){println!("bad formatting");}' > src/main.rs
git add src/main.rs
git commit -m "Bad formatting"
git push origin main  # Se hai remote configurato

# 5. Correggi
cargo fmt
git add src/main.rs
git commit -m "Fix formatting"
```
