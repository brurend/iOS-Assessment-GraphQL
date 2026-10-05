@testable import CountriesUI
import CountriesData
import Testing

@MainActor
struct CountryListViewModelTests {
    @Test
    func successfulLoadPublishesContent() async {
        let countries = [Self.brazil]
        let repository = CountryRepositoryStub(countriesResult: .success(countries))
        let viewModel = CountryListViewModel(repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .content(countries))
    }

    @Test
    func emptyLoadPublishesEmpty() async {
        let repository = CountryRepositoryStub(countriesResult: .success([]))
        let viewModel = CountryListViewModel(repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .empty)
    }

    @Test
    func failedLoadPublishesError() async {
        let repository = CountryRepositoryStub(countriesResult: .failure)
        let viewModel = CountryListViewModel(repository: repository)

        await viewModel.load()

        #expect(viewModel.state == .error)
    }

    @Test(.timeLimit(.minutes(1)))
    func olderRequestCannotOverwriteNewerResult() async {
        let repository = ControlledCountryRepository()
        let viewModel = CountryListViewModel(repository: repository)

        let olderRequest = Task {
            await viewModel.load()
        }
        await repository.waitForRequestCount(1)

        viewModel.retry()
        await repository.waitForRequestCount(2)

        await repository.succeedRequest(2, with: [Self.canada])
        await waitForState(.content([Self.canada]), in: viewModel)

        await repository.succeedRequest(1, with: [Self.brazil])
        await olderRequest.value

        #expect(viewModel.state == .content([Self.canada]))
    }

    private func waitForState(
        _ expectedState: CountryListState,
        in viewModel: CountryListViewModel
    ) async {
        while viewModel.state != expectedState {
            await Task.yield()
        }
    }

    private static let brazil = CountrySummary(
        code: "BR",
        name: "Brazil",
        emoji: "🇧🇷",
        continent: "South America"
    )

    private static let canada = CountrySummary(
        code: "CA",
        name: "Canada",
        emoji: "🇨🇦",
        continent: "North America"
    )
}
