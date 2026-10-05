import CountriesData
import Observation

@MainActor
@Observable
final class CountryDetailViewModel {
    private(set) var state: CountryDetailState = .loading

    @ObservationIgnored
    private let code: String

    @ObservationIgnored
    private let repository: any CountryRepository

    @ObservationIgnored
    private var requestTask: Task<Void, Never>?

    @ObservationIgnored
    private var requestGeneration = 0

    init(code: String, repository: any CountryRepository) {
        self.code = code
        self.repository = repository
    }

    deinit {
        requestTask?.cancel()
    }

    func load() async {
        let generation = beginRequest()
        await performRequest(generation: generation)
    }

    func retry() {
        let generation = beginRequest()
        let code = code
        let repository = repository

        requestTask = Task { [weak self] in
            do {
                let country = try await repository.country(code: code)
                guard let self, isCurrent(generation) else {
                    return
                }

                state = .content(country)
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

    private func performRequest(generation: Int) async {
        do {
            let country = try await repository.country(code: code)

            guard isCurrent(generation) else {
                return
            }

            state = .content(country)
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
}
