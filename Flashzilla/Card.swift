//
//  Card.swift
//  Flashzilla
//
//  Created by Gary on 14/1/2025.
//

struct Card: Codable {
    var prompt: String
    var answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
