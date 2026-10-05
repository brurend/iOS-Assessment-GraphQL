@testable import CountriesUI
import CountriesData
import Testing

@MainActor
struct CountryDetailViewModelTests {
    @Test
    func successfulLoadPublishesContent() async {
        let country = CountryDetails(
            code: "BR",
            name: "Brazil",
            emoji: "🇧🇷",
            capital: "Brasília",
            currency: "BRL",
            languages: ["Portuguese"],
            continent: "South America"
        )
        let repository = CountryRepositoryStub(countryResult: .success(country))
        let viewModel = CountryDetailViewModel(code: country.code, repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .content(country))
    }

    @Test
    func failedLoadPublishesError() async {
        let repository = CountryRepositoryStub(countryResult: .failure)
        let viewModel = CountryDetailViewModel(code: "BR", repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .error)
    }
}
