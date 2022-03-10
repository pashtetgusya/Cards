//
//  Game.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import Foundation

class Game {
    private var storage: GameSettingsStorageProtocol = GameSettingStorage()
    private var gameSettings: GameSettings
    
    var cardsPairsCount: Int
    var availableCardBacks: [CardBackSideType]
    var availableCardFronts: [CardType]
    var availableCardColors: [CardColor]
    
    var cards = [Card]()
    
    init() {
        gameSettings = storage.loadSettings()
        cardsPairsCount = gameSettings.countCardPairs
        availableCardBacks = gameSettings.availableCardBacks
        availableCardFronts = gameSettings.availableCardFronts
        availableCardColors = gameSettings.availableCardColors
    }
    
    func generateCards() {
        var cards = [Card]()
        
        for _ in 0...cardsPairsCount {
            let randomElement = (
                type: availableCardFronts.randomElement()!,
                color: availableCardColors.randomElement()!
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
