# iOS Countries Assessment

An iOS application built with Swift 6, SwiftUI, Apollo iOS, GraphQL, and Swift Package Manager.

## Apollo schema and code generation

Apollo is configured in the `CountriesData` local package. Its configuration, downloaded schema, GraphQL operation definitions, and generated Swift source are committed so a clean checkout can be built without running code generation.

Apollo iOS is pinned to version 2.4.0. Run the matching CLI from the `Packages/CountriesData` directory:

```sh
cd Packages/CountriesData
swift package resolve
swift package --allow-writing-to-package-directory apollo-cli-install
```

The install command creates a local `apollo-ios-cli` executable. Re-run it if the executable has been removed.

To refresh only the schema from the Countries GraphQL endpoint:

```sh
./apollo-ios-cli fetch-schema --path apollo-codegen-config.json
```

After GraphQL operations exist, refresh the schema and regenerate Swift source together:

```sh
./apollo-ios-cli generate --fetch-schema --path apollo-codegen-config.json
```

The inputs and generated output are:

- `GraphQL/Schema/Countries.graphqls`: downloaded schema definition.
- `GraphQL/Operations`: hand-written operations and fragments.
- `Sources/CountriesData/Generated`: Apollo-generated Swift source.

Do not edit files under `Sources/CountriesData/Generated` manually. Commit schema changes, operation definitions, and their corresponding generated Swift changes together. The `apollo-ios-cli` executable and SwiftPM build artifacts are local tooling and must not be committed.
