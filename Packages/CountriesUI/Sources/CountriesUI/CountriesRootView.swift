import CountriesData
import SwiftUI

public struct CountriesRootView: View {
    @State private var navigationPath: [String] = []
    @State private var listViewModel: CountryListViewModel

    private let repository: any CountryRepository

    public init(repository: any CountryRepository) {
        self.repository = repository
        _listViewModel = State(
            initialValue: CountryListViewModel(repository: repository)
        )
    }

    public var body: some View {
        @Bindable var listViewModel = listViewModel

        NavigationStack(path: $navigationPath) {
            CountryListView(
                state: listViewModel.state,
                searchText: $listViewModel.searchText,
                onSelectCountry: { country in
                    navigationPath.append(country.code)
                },
                onRetry: listViewModel.retry
            )
            .task {
                await listViewModel.load()
            }
            .navigationDestination(for: String.self) { countryCode in
                CountryDetailContainer(
                    code: countryCode,
                    repository: repository
                )
            }
        }
    }
}

private struct CountryDetailContainer: View {
    @State private var viewModel: CountryDetailViewModel

    init(code: String, repository: any CountryRepository) {
        _viewModel = State(
            initialValue: CountryDetailViewModel(
                code: code,
                repository: repository
            )
        )
    }

    var body: some View {
        CountryDetailView(
            state: viewModel.state,
            onRetry: viewModel.retry
        )
        .task {
            await viewModel.load()
        }
    }
}
