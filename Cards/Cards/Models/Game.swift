//
//  Game.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import Foundation

class Game {
//    Экземпляр хранилища настроек игры
    private var storage: GameSettingsStorageProtocol = GameSettingStorage()
//    Настройки игры
    private var gameSettings: GameSettings
    
//    Количество пар карточек
    var cardsPairsCount: Int
//    Разрешенные параметры игры
    var availableCardBacks: [CardBackSideType]
    var availableCardFronts: [CardType]
    var availableCardColors: [CardColor]
    
//    Массив сгенерированных карточек
    var cards = [Card]()
    
    init() {
//        Загрузка настроек игры и установка параметров
        gameSettings = storage.loadSettings()
        cardsPairsCount = gameSettings.countCardPairs
        availableCardBacks = gameSettings.availableCardBacks
        availableCardFronts = gameSettings.availableCardFronts
        availableCardColors = gameSettings.availableCardColors
    }
    
//    Генерация массива случайных карточек
    func generateCards() {
        var cards = [Card]()
        
        for _ in 1...cardsPairsCount {
            let randomElement = (
                type: availableCardFronts.randomElement()!,
                backSideType: availableCardBacks.randomElement()!,
                color: availableCardColors.randomElement()!
            )
            cards.append(randomElement)
        }
        
        self.cards = cards
    }
    
//    Генерация массива карточек из сохраненной игры
    func getCardsFromProgressStorage(_ progress: [CardInfoForStorage]) {
        var cards = [Card]()
        
        for card in progress {
            let newCard: Card = (
                type: card.cardFrontSide,
                backSideType: card.cardBackSide,
                color: card.cardColor
            )
            cards.append(newCard)
        }
        
        self.cards = cards
    }
    
//    Првоерка эквивалентности карточек
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        } else {
            return false
        }
    }
}
