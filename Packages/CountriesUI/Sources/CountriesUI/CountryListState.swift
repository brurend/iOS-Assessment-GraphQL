import CountriesData

enum CountryListState: Equatable {
    case loading
    case content([CountrySummary])
    case empty
    case error
}
