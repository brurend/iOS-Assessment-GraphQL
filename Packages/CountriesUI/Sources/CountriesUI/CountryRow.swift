import SwiftUI

struct CountryRow: View {
    let emoji: String
    let name: String
    let continent: String

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.largeTitle)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)

                Text(continent)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
