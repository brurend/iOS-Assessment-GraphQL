import CountriesData

enum RepositoryStubError: Error, Sendable {
    case failed
}

actor CountryRepositoryStub: CountryRepository {
    enum CountriesResult: Sendable {
        case success([CountrySummary])
        case failure
    }

    enum CountryResult: Sendable {
        case success(CountryDetails)
        case failure
    }

    private let countriesResult: CountriesResult
    private let countryResult: CountryResult

    init(
        countriesResult: CountriesResult = .success([]),
        countryResult: CountryResult = .failure
    ) {
        self.countriesResult = countriesResult
        self.countryResult = countryResult
    }

    func countries(searchTerm: String?) async throws -> [CountrySummary] {
        switch countriesResult {
        case let .success(countries):
            countries
        case .failure:
            throw RepositoryStubError.failed
        }
    }

    func country(code: String) async throws -> CountryDetails {
        switch countryResult {
        case let .success(country):
            country
        case .failure:
            throw RepositoryStubError.failed
        }
    }
}

actor ControlledCountryRepository: CountryRepository {
    private var nextRequestID = 0
    private var continuations: [Int: CheckedContinuation<[CountrySummary], Error>] = [:]
    private var requestWaiters: [(count: Int, continuation: CheckedContinuation<Void, Never>)] = []

    func countries(searchTerm: String?) async throws -> [CountrySummary] {
        nextRequestID += 1
        let requestID = nextRequestID
        resumeSatisfiedWaiters()

        return try await withCheckedThrowingContinuation { continuation in
            continuations[requestID] = continuation
        }
    }

    func country(code: String) async throws -> CountryDetails {
        throw RepositoryStubError.failed
    }

    func waitForRequestCount(_ count: Int) async {
        guard nextRequestID < count else {
            return
        }

        await withCheckedContinuation { continuation in
            requestWaiters.append((count, continuation))
        }
    }

    func succeedRequest(_ requestID: Int, with countries: [CountrySummary]) {
        continuations.removeValue(forKey: requestID)?.resume(returning: countries)
    }

    private func resumeSatisfiedWaiters() {
        let satisfiedWaiters = requestWaiters.filter { $0.count <= nextRequestID }
        requestWaiters.removeAll { $0.count <= nextRequestID }

        for waiter in satisfiedWaiters {
            waiter.continuation.resume()
        }
    }
}
