public protocol CountryRepository: Sendable {
    func countries(searchTerm: String?) async throws -> [CountrySummary]
    func country(code: String) async throws -> CountryDetails
}

public enum CountryRepositoryError: Error, Equatable, Sendable {
    case countryNotFound(code: String)
}
