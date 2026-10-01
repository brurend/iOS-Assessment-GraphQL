public struct CountryDetails: Identifiable, Equatable, Sendable {
    public let code: String
    public let name: String
    public let emoji: String
    public let capital: String?
    public let currency: String?
    public let languages: [String]
    public let continent: String

    public var id: String { code }

    public init(
        code: String,
        name: String,
        emoji: String,
        capital: String?,
        currency: String?,
        languages: [String],
        continent: String
    ) {
        self.code = code
        self.name = name
        self.emoji = emoji
        self.capital = capital
        self.currency = currency
        self.languages = languages
        self.continent = continent
    }
}
