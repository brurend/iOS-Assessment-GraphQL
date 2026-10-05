@_spi(Unsafe) import ApolloAPI
@testable import CountriesData
import Testing

struct CountryMappingTests {
    @Test
    func mapsCountrySummaryFromGraphQLFragment() {
        let fields = makeCoreFields(
            code: "BR",
            name: "Brazil",
            emoji: "🇧🇷",
            continent: "South America"
        )

        let summary = CountrySummary(fields)

        #expect(summary == CountrySummary(
            code: "BR",
            name: "Brazil",
            emoji: "🇧🇷",
            continent: "South America"
        ))
    }

    @Test
    func mapsCountryDetailsIncludingOptionalValuesAndLanguages() {
        let country = makeDetailsCountry(
            code: "CH",
            name: "Switzerland",
            emoji: "🇨🇭",
            continent: "Europe",
            capital: nil,
            currency: "CHF",
            languages: ["German", "French", "Italian"]
        )

        let details = CountryDetails(country)

        #expect(details == CountryDetails(
            code: "CH",
            name: "Switzerland",
            emoji: "🇨🇭",
            capital: nil,
            currency: "CHF",
            languages: ["German", "French", "Italian"],
            continent: "Europe"
        ))
    }
}

private func makeCoreFields(
    code: String,
    name: String,
    emoji: String,
    continent: String
) -> CountriesAPI.CountryCoreFields {
    let continentData = DataDict(
        data: ["__typename": "Continent", "name": continent],
        fulfilledFragments: [ObjectIdentifier(CountriesAPI.CountryCoreFields.Continent.self)]
    )
    let countryData = DataDict(
        data: [
            "__typename": "Country",
            "code": code,
            "name": name,
            "emoji": emoji,
            "continent": continentData,
        ],
        fulfilledFragments: [ObjectIdentifier(CountriesAPI.CountryCoreFields.self)]
    )
    return CountriesAPI.CountryCoreFields(_dataDict: countryData)
}

private func makeDetailsCountry(
    code: String,
    name: String,
    emoji: String,
    continent: String,
    capital: String?,
    currency: String?,
    languages: [String]
) -> CountriesAPI.CountryDetailsQuery.Data.Country {
    let continentData = DataDict(
        data: ["__typename": "Continent", "name": continent],
        fulfilledFragments: [ObjectIdentifier(CountriesAPI.CountryCoreFields.Continent.self)]
    )
    let languageData = languages.map {
        DataDict(
            data: ["__typename": "Language", "name": $0],
            fulfilledFragments: [
                ObjectIdentifier(CountriesAPI.CountryDetailsQuery.Data.Country.Language.self),
            ]
        )
    }
    let countryData = DataDict(
        data: [
            "__typename": "Country",
            "code": code,
            "name": name,
            "emoji": emoji,
            "continent": continentData,
            "capital": capital,
            "currency": currency,
            "languages": languageData,
        ],
        fulfilledFragments: [
            ObjectIdentifier(CountriesAPI.CountryDetailsQuery.Data.Country.self),
            ObjectIdentifier(CountriesAPI.CountryCoreFields.self),
        ]
    )
    return CountriesAPI.CountryDetailsQuery.Data.Country(_dataDict: countryData)
}
