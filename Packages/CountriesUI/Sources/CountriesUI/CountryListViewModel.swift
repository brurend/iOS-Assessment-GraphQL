import Combine
import CountriesData
import Foundation
import Observation

@MainActor
@Observable
final class CountryListViewModel {
    private(set) var state: CountryListState = .loading

    var searchText = "" {
        didSet {
            searchSubject.send(Self.normalizedSearchTerm(searchText))
        }
    }

    @ObservationIgnored
    private let repository: any CountryRepository

    @ObservationIgnored
    private let searchSubject = PassthroughSubject<String?, Never>()

    @ObservationIgnored
    private var searchSubscription: AnyCancellable?

    @ObservationIgnored
    private var requestTask: Task<Void, Never>?

    @ObservationIgnored
    private var requestGeneration = 0

    init(repository: any CountryRepository) {
        self.repository = repository

        searchSubscription = searchSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                self?.startManagedRequest(searchTerm: searchTerm)
            }
    }

    deinit {
        requestTask?.cancel()
    }

    func load() async {
        let searchTerm = Self.normalizedSearchTerm(searchText)
        let generation = beginRequest()
        await performRequest(searchTerm: searchTerm, generation: generation)
    }

    func retry() {
        startManagedRequest(searchTerm: Self.normalizedSearchTerm(searchText))
    }

    private func startManagedRequest(searchTerm: String?) {
        let generation = beginRequest()
        let repository = repository

        requestTask = Task { [weak self] in
            do {
                let countries = try await repository.countries(searchTerm: searchTerm)
                guard let self, isCurrent(generation) else {
                    return
                }

                state = countries.isEmpty ? .empty : .content(countries)
            } catch {
                guard let self, isCurrent(generation) else {
                    return
                }

                state = .error
            }
        }
    }

    private func beginRequest() -> Int {
        requestTask?.cancel()
        requestGeneration += 1
        state = .loading
        return requestGeneration
    }

    private func performRequest(searchTerm: String?, generation: Int) async {
        do {
            let countries = try await repository.countries(searchTerm: searchTerm)

            guard isCurrent(generation) else {
                return
            }

            state = countries.isEmpty ? .empty : .content(countries)
        } catch {
            guard isCurrent(generation) else {
                return
            }

            state = .error
        }
    }

    private func isCurrent(_ generation: Int) -> Bool {
        generation == requestGeneration && !Task.isCancelled
    }

    private static func normalizedSearchTerm(_ value: String) -> String? {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue.isEmpty ? nil : trimmedValue
    }
}
