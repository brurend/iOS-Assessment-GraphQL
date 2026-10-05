# iOS Countries Assessment

An iOS application for browsing countries from the public [Countries GraphQL API](https://countries.trevorblades.com). It provides a country list, debounced name search, and country details including capital, currency, languages, and continent.

The project uses Swift 6, SwiftUI, Apollo iOS, Swift Package Manager, Observation, and Combine.

## Requirements and validated environment

- Xcode 27
- Swift 6 language mode
- iOS 18.6 deployment target
- Validated with the iPhone 18 Pro Simulator

## Build and run

1. Clone the repository.
2. Open `iOS-Assessment-GraphQL.xcodeproj` in Xcode.
3. Select the shared `iOS-Assessment-GraphQL` scheme.
4. Select an appropriate iOS Simulator.
5. Build and run the app normally from Xcode.

The GraphQL schema, Apollo-generated Swift sources, and Swift package resolution files are committed. Apollo code generation is therefore not required to build a clean checkout.

## Testing

Automated tests live in the `CountriesData` and `CountriesUI` local Swift packages. They can be run by opening each package's `Package.swift` directly in Xcode and using **Product > Test**.

They can also be run from the command line using the validated simulator:

```sh
cd Packages/CountriesData
xcodebuild \
  -scheme CountriesData \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  test
```

```sh
cd Packages/CountriesUI
xcodebuild \
  -scheme CountriesUI \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  test
```

The test suites cover required list loading outcomes, substituted repository behavior without real network access, GraphQL-to-domain mapping, GraphQL error handling, missing-country behavior, search filtering safety, detail loading outcomes, and stale-response protection.

The application scheme does not include the two package test suites; run them separately using either approach above.

## Architecture

```text
App
├──> CountriesUI
│    └──> CountriesData
└──> CountriesData
     └──> Apollo
```

- **App target:** application entry point, dependency composition, and root navigation.
- **CountriesUI:** SwiftUI presentation, presentation state, `@Observable` view models, and Combine-based search debouncing.
- **CountriesData:** application-owned domain models, the `CountryRepository` abstraction, the Apollo repository implementation, GraphQL operations, and GraphQL-to-domain mapping.

Apollo-generated GraphQL types are internal to `CountriesData`. They are mapped to application-owned domain models at the data boundary and are not exposed to `CountriesUI`.

## Key technical decisions

- `CountryRepository` defines the data boundary and allows tests to substitute actor-based repositories without accessing the network.
- Repository operations use `async`/`await`, while presentation view models use `@MainActor` and Observation for UI state.
- Combine provides the required search debounce.
- Request cancellation and request-generation checks prevent an older asynchronous response from replacing newer state.
- Country codes provide stable model, list-row, and navigation identity.
- Apollo requests use `.networkOnly`, keeping loading and failure behavior explicit rather than relying on an offline cache.

## Apollo code generation

Apollo is configured in the `CountriesData` local package. The configuration, downloaded schema, GraphQL operations, and generated Swift sources are committed, so these steps are needed only after changing the schema or operation definitions—not to build the existing checkout.

Apollo iOS is pinned to version 2.4.0. Install the matching CLI from the `CountriesData` package directory:

```sh
cd Packages/CountriesData
swift package resolve
swift package --allow-writing-to-package-directory apollo-cli-install
```

This creates a local `apollo-ios-cli` executable. Re-run the install command if the executable has been removed.

To refresh only the schema from the Countries GraphQL endpoint:

```sh
./apollo-ios-cli fetch-schema --path apollo-codegen-config.json
```

To refresh the schema and regenerate Swift sources after modifying GraphQL operations:

```sh
./apollo-ios-cli generate --fetch-schema --path apollo-codegen-config.json
```

The relevant inputs and output are:

- `GraphQL/Schema/Countries.graphqls`: downloaded schema definition.
- `GraphQL/Operations`: hand-written queries and fragments.
- `Sources/CountriesData/Generated`: Apollo-generated Swift source.

Do not edit files under `Sources/CountriesData/Generated` manually. Commit schema changes, operation definitions, and their corresponding generated Swift changes together. The `apollo-ios-cli` executable and SwiftPM build artifacts are local tooling and must not be committed.

## Tradeoffs and omissions

- Requests intentionally use the network rather than an offline cache.
- User-facing error messages remain generic; implementation details are not exposed in the UI.
- Application strings are not localized.
- Automated coverage focuses on data mapping and presentation-state behavior; there is no dedicated UI automation suite.

## With more time

- Localize user-facing strings.
- Add richer internal error diagnostics and telemetry while retaining concise user-facing messages.
- Evaluate Apollo cache behavior for useful offline or degraded-network support.
- Add focused UI automation for the primary list, search, and detail flows.
