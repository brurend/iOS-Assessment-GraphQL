import CountriesData
import SwiftUI

struct CountryListView: View {
    let state: CountryListState
    @Binding var searchText: String
    let onSelectCountry: (CountrySummary) -> Void
    let onRetry: () -> Void

    var body: some View {
        CountryListContent(
            state: state,
            onSelectCountry: onSelectCountry,
            onRetry: onRetry
        )
        .navigationTitle("Countries")
        .searchable(text: $searchText, prompt: "Search countries")
    }
}

private struct CountryListContent: View {
    let state: CountryListState
    let onSelectCountry: (CountrySummary) -> Void
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .loading:
            ProgressView("Loading countries")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case let .content(countries):
            List(countries) { country in
                Button {
                    onSelectCountry(country)
                } label: {
                    CountryRow(
                        emoji: country.emoji,
                        name: country.name,
                        continent: country.continent
                    )
                }
                .buttonStyle(.plain)
            }
        case .empty:
            ContentUnavailableView(
                "No Countries",
                systemImage: "globe",
                description: Text("No countries are available.")
            )
        case .error:
            ContentUnavailableView {
                Label("Unable to Load Countries", systemImage: "exclamationmark.triangle")
            } description: {
                Text("Something went wrong while loading countries.")
            } actions: {
                Button("Try Again", action: onRetry)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview("Loading") {
    @Previewable @State var searchText = ""

    NavigationStack {
        CountryListView(
            state: .loading,
            searchText: $searchText,
            onSelectCountry: { _ in },
            onRetry: {}
        )
    }
}

#Preview("Content") {
    @Previewable @State var searchText = ""

    NavigationStack {
        CountryListView(
            state: .content(CountrySummary.previewCountries),
            searchText: $searchText,
            onSelectCountry: { _ in },
            onRetry: {}
        )
    }
}

#Preview("Empty") {
    @Previewable @State var searchText = ""

    NavigationStack {
        CountryListView(
            state: .empty,
            searchText: $searchText,
            onSelectCountry: { _ in },
            onRetry: {}
        )
    }
}

#Preview("Error") {
    @Previewable @State var searchText = ""

    NavigationStack {
        CountryListView(
            state: .error,
            searchText: $searchText,
            onSelectCountry: { _ in },
            onRetry: {}
        )
    }
}

#Preview("Accessibility Text") {
    @Previewable @State var searchText = ""

    NavigationStack {
        CountryListView(
            state: .content(CountrySummary.previewCountries),
            searchText: $searchText,
            onSelectCountry: { _ in },
            onRetry: {}
        )
    }
    .dynamicTypeSize(.accessibility3)
}

private extension CountrySummary {
    static let previewCountries = [
        CountrySummary(
            code: "BR",
            name: "Brazil",
            emoji: "🇧🇷",
            continent: "South America"
        ),
        CountrySummary(
            code: "JP",
            name: "Japan",
            emoji: "🇯🇵",
            continent: "Asia"
        ),
        CountrySummary(
            code: "ZA",
            name: "South Africa",
            emoji: "🇿🇦",
            continent: "Africa"
        ),
    ]
}
