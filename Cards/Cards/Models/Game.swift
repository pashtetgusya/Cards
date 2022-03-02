//
//  Game.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import Foundation

class Game {
    var cardsCount = 0
    var cards = [Card]()
    
    func generateCards() {
        var cards = [Card]()
        
        for _ in 0...cardsCount {
            let randomElement = (
                type: CardType.allCases.randomElement()!,
                color: CardColor.allCases.randomElement()!
            )
            cards.append(randomElement)
        }
        
        self.cards = cards
    }
    
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        } else {
            return false
        }
    }
}
