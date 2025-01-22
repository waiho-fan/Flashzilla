//
//  Card.swift
//  Flashzilla
//
//  Created by Gary on 14/1/2025.
//

import Foundation
import SwiftData

@Model
class Card: Identifiable {
    var id = UUID()
    var prompt: String
    var answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    init(prompt: String, answer: String) {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
}
