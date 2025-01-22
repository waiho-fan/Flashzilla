//
//  ContentView.swift
//  Flashzilla
//
//  Created by iOS Dev Ninja on 14/1/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.modelContext) var modelContext

    @State private var isActive = true
    @Query var allCards: [Card]
    @State private var gameCards: [Card] = []
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(gameCards) { card in
                        CardView(card: card) { isCorrect in
                            if !isCorrect {
                                withAnimation {
                                    let newCard = Card(prompt: card.prompt, answer: card.answer)
                                    if let index = getIndex(of: card) {
                                        gameCards.remove(at: index)
                                        gameCards.insert(newCard, at: 0)
                                    }
                                }
                            } else {
                                withAnimation {
                                    if let index = getIndex(of: card) {
                                        gameCards.remove(at: index)
                                    }
                                }
                            }
                        }
                        .stacked(at: gameCards.firstIndex(where: { $0.id == card.id }) ?? 0, in: gameCards.count)
                        .allowsHitTesting(gameCards.last?.id == card.id)
                        .accessibilityHidden(gameCards.last?.id != card.id)
                        .accessibilityAddTraits(.isButton)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if gameCards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
//            if true {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                if let lastCard = gameCards.last, 
                                    let index = getIndex(of: lastCard) {
                                    removeCard(at: index)
                                }
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                if let lastCard = gameCards.last,
                                    let index = getIndex(of: lastCard) {
                                    removeCard(at: index)
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if gameCards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .onAppear(perform: resetCards)
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        gameCards = allCards
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        gameCards.remove(at: index)
        
        if gameCards.isEmpty {
            isActive = false
        }
    }
    
    func getIndex(of card: Card) -> Int? {
        return gameCards.firstIndex(where: { $0.id == card.id })
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Card.self)
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}
