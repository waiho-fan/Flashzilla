//
//  Tutorial.swift
//  Flashzilla
//
//  Created by iOS Dev Ninja on 14/1/2025.
//

import SwiftUI

struct Tutorial: View {
    var body: some View {
        Form {
            Text("onTapGesture(count: 2)")
                .onTapGesture(count: 2) {
                    print("Double tapped!")
                }
            Text("onLongPressGesture")
                .onLongPressGesture {
                    print("Long pressed!")
                }
            Text("onLongPressGesture\n(minimumDuration: 2)")
                .onLongPressGesture(minimumDuration: 2) {
                    print("Long pressed!")
                }
            Text("onLongPressGesture\nonPressingChanged")
                .onLongPressGesture(minimumDuration: 3) {
                    print("Long pressed!")
                } onPressingChanged: { inProgress in
                    print("In progress: \(inProgress)!")
                }
            MagnifyGestureView()
            RotationEffectView()
            ClashGestureView()
            
            SequencingGesture()
//                .listRowSeparator(.hidden)
            AllowsHitTesting()
                .listRowSeparator(.hidden)
            AllowsHitTesting02()
            TimerView()
        }
    }
}

struct MagnifyGestureView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0

    var body: some View {
        Text("MagnifyGesture")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentAmount = value.magnification - 1
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}

struct RotationEffectView: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero

    var body: some View {
        Text("RotationEffect")
            .rotationEffect(currentAmount + finalAmount)
            .gesture(
                RotateGesture()
                    .onChanged { value in
                        currentAmount = value.rotation
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = .zero
                    }
            )
    }
}

struct ClashGestureView: View {
    var body: some View {
        VStack {
            Text("Clash Gesture")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    print("VStack tapped")
                }
        )
    }
}

struct SequencingGesture: View {
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false

    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }

        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
        Section {
            Circle()
                .fill(.red)
                .frame(width: 64, height: 64)
                .scaleEffect(isDragging ? 1.5 : 1)
                .offset(offset)
                .gesture(combined)
        } header: {
            Text("Sequencing Gesture")
        }
        
    }
}

struct AllowsHitTesting: View {
    var body: some View {
        Section {
            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        print("Rectangle tapped!")
                    }

                Circle()
                    .fill(.red)
                    .frame(width: 300, height: 300)
                    .contentShape(.rect)
                    .onTapGesture {
                        print("Circle tapped!")
                    }
    //                .allowsHitTesting(false)
            }
        } header: {
            Text("Allows HitTesting 01")
        }
        
    }
}

struct AllowsHitTesting02: View {
    var body: some View {
        Section {
            VStack {
                Text("Hello")
                Spacer().frame(height: 100)
                Text("World")
            }
            .contentShape(.rect)
            .onTapGesture {
                print("VStack tapped!")
            }
        } header: {
            Text("Allows HitTesting 02")
        }
        
    }
}

struct TimerView: View {
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @State private var output = ""

    var body: some View {
        Section {
            Text(output)
                .onReceive(timer) { time in
                    if counter == 5 {
                        timer.upstream.connect().cancel()
                        output = "Timer is stopped"
                    } else {
                        output = "The time is now \(time)"
                    }

                    counter += 1
                }
        } header: {
            Text("Timer onReceive - \(counter)")
        }
        
    }
}

struct ScenePhaseView: View {
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text("Hello, world!")
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
    }
}

struct AccessibilityView: View {
    var body: some View {
        Form {
            AccessibilityDifferentiateWithoutColor()
            AccessibilityReduceMotion()
            AccessibilityReduceTransparency()
        }
    }
}

struct AccessibilityDifferentiateWithoutColor: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    var body: some View {
        HStack {
            if differentiateWithoutColor {
                Image(systemName: "checkmark.circle")
            }

            Text("Accessibility DifferentiateWithoutColor")
        }
        .padding()
        .background(differentiateWithoutColor ? .black : .green)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
}

struct AccessibilityReduceMotion: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0

    var body: some View {
        Button("AccessibilityReduceMotion") {
            withOptionalAnimation {
                scale *= 1.5
            }
        }
        .scaleEffect(scale)
    }
    
    func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        if UIAccessibility.isReduceMotionEnabled {
            return try body()
        } else {
            return try withAnimation(animation, body)
        }
    }
}

struct AccessibilityReduceTransparency: View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency

    var body: some View {
        Text("AccessibilityReduceTransparency")
            .padding()
            .background(reduceTransparency ? .black : .black.opacity(0.5))
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
}

#Preview {
    Tutorial()
//    ScenePhaseView()
//    AccessibilityView()
}
