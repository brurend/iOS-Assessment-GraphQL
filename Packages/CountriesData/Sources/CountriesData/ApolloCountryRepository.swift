import Apollo
import Foundation

public final class ApolloCountryRepository: CountryRepository, Sendable {
    private let client: ApolloClient

    public init(endpointURL: URL) {
        client = ApolloClient(url: endpointURL)
    }

    init(client: ApolloClient) {
        self.client = client
    }

    public func countries(searchTerm: String?) async throws -> [CountrySummary] {
        let response = try await client.fetch(
            query: Self.makeCountryListQuery(searchTerm: searchTerm),
            cachePolicy: .networkOnly
        )

        return try Self.mapCountryListResponse(response)
    }

    public func country(code: String) async throws -> CountryDetails {
        let response = try await client.fetch(
            query: CountriesAPI.CountryDetailsQuery(code: code),
            cachePolicy: .networkOnly
        )

        return try Self.mapCountryDetailsResponse(response, code: code)
    }
}

extension ApolloCountryRepository {
    static func makeCountryListQuery(searchTerm: String?) -> CountriesAPI.CountryListQuery {
        guard let searchTerm = searchTerm?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchTerm.isEmpty else {
            return CountriesAPI.CountryListQuery(filter: .none)
        }

        let name = CountriesAPI.StringQueryOperatorInput(
            regex: .some(caseInsensitiveLiteralPattern(for: searchTerm))
        )
        let filter = CountriesAPI.CountryFilterInput(name: .some(name))
        return CountriesAPI.CountryListQuery(filter: .some(filter))
    }

    static func caseInsensitiveLiteralPattern(for searchTerm: String) -> String {
        // The API rejects inline case-insensitive flags. Literal lower/upper variants keep
        // input escaped and predictable without attempting full Unicode case folding.
        searchTerm.map { character in
            let value = String(character)
            let variants = [value, value.lowercased(), value.uppercased()].reduce(into: [String]()) {
                if !$0.contains($1) {
                    $0.append($1)
                }
            }
            let escapedVariants = variants.map(NSRegularExpression.escapedPattern(for:))

            guard escapedVariants.count > 1 else {
                return escapedVariants[0]
            }

            return "(?:\(escapedVariants.joined(separator: "|")))"
        }
        .joined()
    }

    static func mapCountryListResponse(
        _ response: GraphQLResponse<CountriesAPI.CountryListQuery>
    ) throws -> [CountrySummary] {
        try validate(response)

        guard let data = response.data else {
            throw ApolloCountryRepositoryError.missingData
        }

        return data.countries.map { CountrySummary($0.fragments.countryCoreFields) }
    }

    static func mapCountryDetailsResponse(
        _ response: GraphQLResponse<CountriesAPI.CountryDetailsQuery>,
        code: String
    ) throws -> CountryDetails {
        try validate(response)

        guard let data = response.data else {
            throw ApolloCountryRepositoryError.missingData
        }
        guard let country = data.country else {
            throw CountryRepositoryError.countryNotFound(code: code)
        }

        return CountryDetails(country)
    }

    private static func validate<Operation>(_ response: GraphQLResponse<Operation>) throws {
        guard let errors = response.errors, !errors.isEmpty else {
            return
        }

        throw ApolloCountryRepositoryError.graphQL(
            messages: errors.map { $0.message ?? "GraphQL Error" }
        )
    }
}

enum ApolloCountryRepositoryError: Error, Equatable {
    case graphQL(messages: [String])
    case missingData
}
