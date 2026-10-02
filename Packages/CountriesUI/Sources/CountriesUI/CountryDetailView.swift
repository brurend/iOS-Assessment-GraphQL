import CountriesData
import SwiftUI

struct CountryDetailView: View {
    let state: CountryDetailState
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .loading:
            ProgressView("Loading country")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Country Details")
        case let .content(country):
            CountryDetailContent(country: country)
                .navigationTitle(country.name)
                .navigationBarTitleDisplayMode(.inline)
        case .error:
            ContentUnavailableView {
                Label("Unable to Load Country", systemImage: "exclamationmark.triangle")
            } description: {
                Text("Something went wrong while loading the country.")
            } actions: {
                Button("Try Again") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Country Details")
        }
    }
}

private struct CountryDetailContent: View {
    @Environment(\.locale) private var locale

    let country: CountryDetails

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(country.emoji)
                        .font(.largeTitle)
                        .accessibilityHidden(true)

                    Text(country.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(country.continent)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
            }

            Section("Information") {
                LabeledContent("Capital") {
                    if let capital = country.capital, !capital.isEmpty {
                        Text(capital)
                    } else {
                        Text("Not available")
                            .foregroundStyle(.secondary)
                    }
                }

                LabeledContent("Currency") {
                    if let currency = country.currency, !currency.isEmpty {
                        Text(currency)
                    } else {
                        Text("Not available")
                            .foregroundStyle(.secondary)
                    }
                }

                LabeledContent("Languages") {
                    if country.languages.isEmpty {
                        Text("Not available")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(
                            country.languages.formatted(
                                .list(type: .and).locale(locale)
                            )
                        )
                        .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
}

#Preview("Loading") {
    NavigationStack {
        CountryDetailView(state: .loading, onRetry: {})
    }
}

#Preview("Content") {
    NavigationStack {
        CountryDetailView(
            state: .content(
                CountryDetails(
                    code: "BR",
                    name: "Brazil",
                    emoji: "🇧🇷",
                    capital: "Brasília",
                    currency: "BRL",
                    languages: ["Portuguese"],
                    continent: "South America"
                )
            ),
            onRetry: {}
        )
    }
}

#Preview("Unavailable Values") {
    NavigationStack {
        CountryDetailView(
            state: .content(
                CountryDetails(
                    code: "AQ",
                    name: "Antarctica",
                    emoji: "🇦🇶",
                    capital: nil,
                    currency: nil,
                    languages: [],
                    continent: "Antarctica"
                )
            ),
            onRetry: {}
        )
    }
}

#Preview("Error") {
    NavigationStack {
        CountryDetailView(state: .error, onRetry: {})
    }
}

#Preview("Accessibility Text") {
    NavigationStack {
        CountryDetailView(
            state: .content(
                CountryDetails(
                    code: "CH",
                    name: "Switzerland",
                    emoji: "🇨🇭",
                    capital: "Bern",
                    currency: "CHF",
                    languages: ["German", "French", "Italian", "Romansh"],
                    continent: "Europe"
                )
            ),
            onRetry: {}
        )
    }
    .dynamicTypeSize(.accessibility3)
}
