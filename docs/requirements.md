# iOS Countries Assessment Requirements

This document is the operational source of truth for the iOS take-home assessment. It records required scope without adding speculative implementation decisions.

## Product

- Build an iOS app for browsing countries from the public Countries GraphQL API.
- The country list must show every country's flag, name, and continent.
- Users must be able to search or filter countries by name.
- Debounce search so a query is not issued for every keystroke.
- The list must represent loading, empty, and error states.
- Selecting a country must open its detail screen.
- Country detail must show the country's name, emoji or flag, capital, currency, languages, and continent.
- Detail must represent loading and error states.
- Semantic colors supporting light and dark mode and Dynamic Type are optional enhancements.

## Architecture

- Use Swift and SwiftUI.
- Use at least two local Swift packages consumed by the app target.
- One package must own data and networking responsibilities.
- One package must own UI and presentation responsibilities.
- The app target must contain only application entry-point and dependency-composition code.
- UI must not depend directly on Apollo-generated types.
- Map GraphQL data into application-owned domain models at the data boundary.
- Use Swift 6 strict concurrency without warnings.

## Networking and GraphQL

- Use Apollo iOS.
- There is no separate starter project; the original brief's statement that Apollo is already configured is outdated.
- Set up Apollo iOS and Apollo code generation as part of the assessment.
- Download the GraphQL schema from `https://countries.trevorblades.com`.
- Keep the schema and code-generation configuration in the repository so code generation is reproducible.
- Document the steps required to regenerate Apollo-generated code in the README.
- Define separate GraphQL operations for the country list and country detail.
- Use a GraphQL fragment for fields shared by those operations.
- Keep the network and data layer behind a protocol so it can be substituted in tests.
- Prefer `async`/`await`; do not create custom completion-handler APIs.
- Surface failures explicitly instead of silently converting them into empty data.

## State and SwiftUI

- Use Observation with `@Observable` for list and detail view models.
- Apply `@MainActor` where appropriate.
- Use Combine for search debouncing.
- Use stable row identity across reloads and filtering.
- Custom `ViewModifier` and `EnvironmentValues` extensions are optional; if introduced, they should address a genuine need and be used by more than one view.

## Testing

- Test the list view model for successful loading.
- Test the list view model for an empty result.
- Test the list view model for a network failure.
- Use a mocked or substituted data boundary; tests must not access the real network.
- Include at least one test covering GraphQL-response-to-domain-model mapping.
- XCTest or Swift Testing may be used.

## Submission and Quality

- The final submission must be a public GitHub repository with commit history intact.
- The README must explain build and run steps, including the Xcode version, iOS target, and simulator.
- The README must document key technical decisions, omissions, and what would be changed with more time.
- Maintain production-quality code appropriate to the assignment's scope.
- Configure SwiftFormat and/or SwiftLint; using either one is sufficient.

## Interpretation Rule

- This document describes the required application scope.
- Do not infer additional product requirements merely because fields or entities exist in the GraphQL schema.
- Do not replace explicitly required technologies with alternatives.
- When an implementation choice is not specified here, prefer the simplest solution that satisfies these requirements and the existing architecture.
