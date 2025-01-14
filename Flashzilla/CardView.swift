//
//  CardView.swift
//  Flashzilla
//
//  Created by Gary on 14/1/2025.
//

import SwiftUI

enum DragGestureStatus {
    case idle, drag
}

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    let card: Card
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    var removal: (() -> Void)? = nil
    @State private var dragGestureStatus: DragGestureStatus = .idle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(dragGestureStatus != .drag ? .white : offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
                
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    dragGestureStatus = .drag
                    offset = gesture.translation
                    print("onChanged offset \(offset)")
                }
                .onEnded { _ in
                    dragGestureStatus = .idle
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                    print("onEnded offset \(offset)")
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)

    }
    
    
}

#Preview {
    CardView(card: .example)
}
