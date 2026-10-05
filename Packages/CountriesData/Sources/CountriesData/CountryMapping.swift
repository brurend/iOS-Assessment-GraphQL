extension CountrySummary {
    init(_ fields: CountriesAPI.CountryCoreFields) {
        self.init(
            code: fields.code,
            name: fields.name,
            emoji: fields.emoji,
            continent: fields.continent.name
        )
    }
}

extension CountryDetails {
    init(_ country: CountriesAPI.CountryDetailsQuery.Data.Country) {
        let fields = country.fragments.countryCoreFields

        self.init(
            code: fields.code,
            name: fields.name,
            emoji: fields.emoji,
            capital: country.capital,
            currency: country.currency,
            languages: country.languages.map(\.name),
            continent: fields.continent.name
        )
    }
}
