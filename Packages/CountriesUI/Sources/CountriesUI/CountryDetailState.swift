import CountriesData

enum CountryDetailState: Equatable {
    case loading
    case content(CountryDetails)
    case error
}
