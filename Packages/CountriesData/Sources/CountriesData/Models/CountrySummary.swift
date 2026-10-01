public struct CountrySummary: Identifiable, Equatable, Sendable {
    public let code: String
    public let name: String
    public let emoji: String
    public let continent: String

    public var id: String { code }

    public init(
        code: String,
        name: String,
        emoji: String,
        continent: String
    ) {
        self.code = code
        self.name = name
        self.emoji = emoji
        self.continent = continent
    }
}
