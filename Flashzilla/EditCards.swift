//
//  EditCards.swift
//  Flashzilla
//
//  Created by Gary on 14/1/2025.
//

import SwiftData
import SwiftUI

struct EditCards: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var cards: [Card]
    @State private var newPrompt = ""
    @State private var newAnswer = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }

                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
        }
    }

    func done() {
        dismiss()
    }

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        modelContext.insert(card)

        reset()
    }

    func removeCards(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cards[index])
        }
    }
    
    func reset() {
        newPrompt = ""
        newAnswer = ""
    }
}

#Preview {
    EditCards()
        .modelContainer(for: Card.self)
}
