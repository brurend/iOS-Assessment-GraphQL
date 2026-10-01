# AGENTS.md

## Project

This is an iOS take-home assignment built with Swift, SwiftUI, Apollo iOS,
GraphQL, and Swift Package Manager.

Prefer clear, maintainable, production-quality code appropriate to the scope
of the assignment. Avoid unnecessary abstractions and overengineering.

## Architecture

- The app target must contain only application entry-point and dependency-
  composition code.
- Feature UI and presentation logic belong in `CountriesUI`.
- Data access and networking belong in `CountriesData`.
- `CountriesUI` may depend on `CountriesData`.
- `CountriesData` must not depend on `CountriesUI`.
- Apollo-generated types must remain internal to `CountriesData` and must not
  appear in its public API.
- Do not introduce additional layers, packages, or abstractions without a
  concrete need.

## Swift

- Use Swift 6 language mode.
- Maintain complete strict concurrency checking without warnings.
- Prefer structured concurrency and `async/await`.
- Use `@MainActor` where actor isolation is semantically appropriate.

## Development

- Keep changes focused on the requested task.
- Do not make unrelated refactors.
- Do not modify generated source manually.
- Build affected targets after code changes.
- Run relevant tests after behavioral changes.
- Do not consider work complete if it introduces build errors, test failures,
  or concurrency warnings.
