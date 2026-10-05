// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CountriesAPI {
  nonisolated struct CountryDetailsQuery: GraphQLQuery {
    static let operationName: String = "CountryDetails"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query CountryDetails($code: ID!) { country(code: $code) { __typename ...CountryCoreFields capital currency languages { __typename name } } }"#,
        fragments: [CountryCoreFields.self]
      ))

    public var code: ID

    public init(code: ID) {
      self.code = code
    }

    @_spi(Unsafe) public var __variables: Variables? { ["code": code] }

    nonisolated struct Data: CountriesAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("country", Country?.self, arguments: ["code": .variable("code")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CountryDetailsQuery.Data.self
      ] }

      var country: Country? { __data["country"] }

      /// Country
      ///
      /// Parent Type: `Country`
      nonisolated struct Country: CountriesAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Country }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("capital", String?.self),
          .field("currency", String?.self),
          .field("languages", [Language].self),
          .fragment(CountryCoreFields.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CountryDetailsQuery.Data.Country.self,
          CountryCoreFields.self
        ] }

        var capital: String? { __data["capital"] }
        var currency: String? { __data["currency"] }
        var languages: [Language] { __data["languages"] }
        var code: CountriesAPI.ID { __data["code"] }
        var name: String { __data["name"] }
        var emoji: String { __data["emoji"] }
        var continent: Continent { __data["continent"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var countryCoreFields: CountryCoreFields { _toFragment() }
        }

        /// Country.Language
        ///
        /// Parent Type: `Language`
        nonisolated struct Language: CountriesAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Language }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            CountryDetailsQuery.Data.Country.Language.self
          ] }

          var name: String { __data["name"] }
        }

        typealias Continent = CountryCoreFields.Continent
      }
    }
  }

}