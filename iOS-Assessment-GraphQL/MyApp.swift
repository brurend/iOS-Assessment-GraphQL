import CountriesData
import CountriesUI
import Foundation
import SwiftUI

@main struct MyApp: App {
    private let repository: any CountryRepository

    init() {
        guard let endpointURL = URL(string: "https://countries.trevorblades.com") else {
            preconditionFailure("The Countries GraphQL endpoint URL is invalid.")
        }

        repository = ApolloCountryRepository(endpointURL: endpointURL)
    }

    var body: some Scene {
        WindowGroup {
            CountriesRootView(repository: repository)
        }
    }
}
