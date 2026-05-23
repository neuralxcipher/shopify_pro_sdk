# Contributing to shopify_pro_sdk

Thank you for your interest in contributing to **shopify_pro_sdk**!  
This project is developed and maintained by **Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED**.

---

## Code of Conduct

All contributors are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).  
We foster an open, respectful, and collaborative environment.

---

## How to Contribute

### 1. Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md).  
Include:
- SDK version
- Flutter/Dart version
- Minimal reproduction steps
- Expected vs actual behavior
- Full stack trace

### 2. Requesting Features

Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md).  
Describe:
- The use case (not just the solution)
- Expected API surface
- Alternative approaches considered

### 3. Submitting Pull Requests

1. Fork the repository
2. Create a branch: `git checkout -b feat/your-feature-name`
3. Follow the architecture conventions (see below)
4. Add/update tests for your changes
5. Run `flutter analyze` — zero warnings required
6. Run `flutter test` — all tests must pass
7. Update `CHANGELOG.md` under `[Unreleased]`
8. Open a PR against `main` using the PR template

---

## Architecture Conventions

### Feature-First Clean Architecture

```
lib/src/features/<feature>/
├── data/
│   ├── models/          # Pure Dart data classes (fromJson, toJson, copyWith)
│   ├── queries/         # GraphQL query/mutation strings
│   └── repositories/    # Concrete repository implementations
└── domain/
    ├── repositories/    # Abstract repository interfaces
    └── <feature>_service.dart  # Business logic / use-case orchestration
```

### Rules

- **No print statements** — use `ShopifyLogger`
- **No dynamic types** — strict-mode is enforced
- **Models are immutable** — use `copyWith` for updates
- **All public APIs must have dartdoc comments**
- **Prefer `const` constructors** where possible
- **Tests are not optional** — every repository impl needs unit tests

---

## Development Setup

```bash
# Clone
git clone https://github.com/neuralxcipher/shopify_pro_sdk.git
cd shopify_pro_sdk

# Get dependencies
flutter pub get

# Run analyzer
flutter analyze

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage
```

---

## Coding Standards

- Dart 3 / null-safe only
- Follow `analysis_options.yaml` (strict mode)
- Single quotes for strings
- Trailing commas in argument lists
- `prefer_final_locals` — use `final` by default
- No unnecessary comments — code should be self-documenting

---

## Versioning

We use [Semantic Versioning](https://semver.org/):
- `MAJOR` — breaking API changes
- `MINOR` — new backward-compatible features
- `PATCH` — bug fixes and internal improvements

---

## License

By contributing, you agree that your contributions will be licensed under the  
[MIT License](LICENSE) of this project.

---

*Developed and maintained by **Abrar Ali** — NEURALXCIPHER (PRIVATE) LIMITED*
