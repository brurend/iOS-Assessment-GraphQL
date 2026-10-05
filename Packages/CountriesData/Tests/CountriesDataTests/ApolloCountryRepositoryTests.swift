import Apollo
@_spi(Unsafe) import ApolloAPI
@testable import CountriesData
import Foundation
import Testing

struct ApolloCountryRepositoryTests {
    @Test(arguments: [nil, "", "   \n"])
    func nilOrBlankSearchProducesUnfilteredQuery(searchTerm: String?) {
        let query = ApolloCountryRepository.makeCountryListQuery(searchTerm: searchTerm)

        #expect(query.filter.unwrapped == nil)
    }

    @Test
    func searchPatternTreatsRegexMetacharactersLiterally() throws {
        let pattern = ApolloCountryRepository.caseInsensitiveLiteralPattern(for: "u.s+[")
        let expression = try NSRegularExpression(pattern: pattern)
        let matchingValue = "U.S+["
        let nonmatchingValue = "USA"

        #expect(expression.firstMatch(
            in: matchingValue,
            range: NSRange(matchingValue.startIndex..., in: matchingValue)
        ) != nil)
        #expect(expression.firstMatch(
            in: nonmatchingValue,
            range: NSRange(nonmatchingValue.startIndex..., in: nonmatchingValue)
        ) == nil)
    }

    @Test
    func nilDetailCountryIsNotFound() {
        let data = DataDict(
            data: ["country": Optional<DataDict>.none],
            fulfilledFragments: [ObjectIdentifier(CountriesAPI.CountryDetailsQuery.Data.self)]
        )
        let response = GraphQLResponse<CountriesAPI.CountryDetailsQuery>(
            data: CountriesAPI.CountryDetailsQuery.Data(_dataDict: data),
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )

        #expect(throws: CountryRepositoryError.countryNotFound(code: "ZZ")) {
            try ApolloCountryRepository.mapCountryDetailsResponse(response, code: "ZZ")
        }
    }

    @Test
    func validEmptyCountryListIsSuccessful() throws {
        let data = DataDict(
            data: ["countries": [DataDict]()],
            fulfilledFragments: [ObjectIdentifier(CountriesAPI.CountryListQuery.Data.self)]
        )
        let response = GraphQLResponse<CountriesAPI.CountryListQuery>(
            data: CountriesAPI.CountryListQuery.Data(_dataDict: data),
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )

        #expect(try ApolloCountryRepository.mapCountryListResponse(response).isEmpty)
    }

    @Test
    func graphQLErrorsAreNotConsumedAsPartialData() {
        let data = DataDict(
            data: ["countries": [DataDict]()],
            fulfilledFragments: [ObjectIdentifier(CountriesAPI.CountryListQuery.Data.self)]
        )
        let response = GraphQLResponse<CountriesAPI.CountryListQuery>(
            data: CountriesAPI.CountryListQuery.Data(_dataDict: data),
            extensions: nil,
            errors: [GraphQLError(["message": "Query failed"])],
            source: .server,
            dependentKeys: nil
        )

        #expect(throws: ApolloCountryRepositoryError.graphQL(messages: ["Query failed"])) {
            try ApolloCountryRepository.mapCountryListResponse(response)
        }
    }
}
