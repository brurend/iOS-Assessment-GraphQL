// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension CountriesAPI {
  nonisolated struct CountryCoreFields: CountriesAPI.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment CountryCoreFields on Country { __typename code name emoji continent { __typename name } }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Country }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("code", CountriesAPI.ID.self),
      .field("name", String.self),
      .field("emoji", String.self),
      .field("continent", Continent.self),
    ] }
    static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CountryCoreFields.self
    ] }

    var code: CountriesAPI.ID { __data["code"] }
    var name: String { __data["name"] }
    var emoji: String { __data["emoji"] }
    var continent: Continent { __data["continent"] }

    /// Continent
    ///
    /// Parent Type: `Continent`
    nonisolated struct Continent: CountriesAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CountriesAPI.Objects.Continent }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CountryCoreFields.Continent.self
      ] }

      var name: String { __data["name"] }
    }
  }

}