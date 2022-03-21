//
//  GameProgressStirage.swift
//  Cards
//
//  Created by Pavel Yarovoi on 17.03.2022.
//

import UIKit

//Хранилище информации о карточке
typealias CardInfoForStorage = (
    cardTag: Int,
    cardFrontSide: CardType,
    cardBackSide: CardBackSideType,
    cardColor: CardColor,
    cardCoordinateX: Int,
    cardCoordinateY: Int
)

//Протокол хранилища прогресса игры
protocol GameProgressStorageProtocol {
    func loadProgress() -> [CardInfoForStorage]?
    func saveProgress(_ progress: [CardInfoForStorage])
    
    func loadCountFlip() -> Int?
    func saveCountFlip(_ count: Int)
}

class GameProgressStorage: GameProgressStorageProtocol {
    
    private enum ProgressKey: String {
        case cardTag
        case cardFront
        case cardBack
        case cardColor
        case coordinateX
        case coordinateY
    }
    
    private var storage = UserDefaults.standard
    let storageProgressKey: String = "gameProgress"
    let storageCountFlipKey: String = "gameFlipCount"
    
//    Загрузка прогресса
    func loadProgress() -> [CardInfoForStorage]? {
        var loadedGameProgress: [CardInfoForStorage] = []
        
        guard let progressFromStorage = storage.object(forKey: storageProgressKey) as? [[String: String]] else {
            return nil
        }
        
        for card in progressFromStorage {
            guard let tag = card[ProgressKey.cardTag.rawValue],
                  let front = card[ProgressKey.cardFront.rawValue],
                  let back = card[ProgressKey.cardBack.rawValue],
                  let color = card[ProgressKey.cardColor.rawValue],
                  let coordinateX = card[ProgressKey.coordinateX.rawValue],
                  let coordinateY = card[ProgressKey.coordinateY.rawValue] else {
                return nil
            }
            let cardTag = Int(tag)!
            let cardFront = CardType(rawValue: front)!
            let cardBack = CardBackSideType(rawValue: back)!
            let cardColor = CardColor(rawValue: color)!
            let cardCoordinateX = Int(coordinateX)!
            let cardCoordinateY = Int(coordinateY)!
            
            let loadedCard: CardInfoForStorage = (
                cardTag: cardTag,
                cardFrontSide: cardFront,
                cardBackSide: cardBack,
                cardColor: cardColor,
                cardCoordinateX: cardCoordinateX,
                cardCoordinateY: cardCoordinateY)
            
            loadedGameProgress.append(loadedCard)
        }
        
        return loadedGameProgress
    }
    
//    Сохранение прогресса
    func saveProgress(_ progress: [CardInfoForStorage]) {
        var newGameProgress: [[String: String]] = []
        
        for card in progress {
            var savedCard: [String: String] = [:]
            
            savedCard[ProgressKey.cardTag.rawValue] = String(card.cardTag)
            savedCard[ProgressKey.cardFront.rawValue] = card.cardFrontSide.rawValue
            savedCard[ProgressKey.cardBack.rawValue] = card.cardBackSide.rawValue
            savedCard[ProgressKey.cardColor.rawValue] = card.cardColor.rawValue
            savedCard[ProgressKey.coordinateX.rawValue] = String(card.cardCoordinateX)
            savedCard[ProgressKey.coordinateY.rawValue] = String(card.cardCoordinateY)
            
            newGameProgress.append(savedCard)
        }

        storage.set(newGameProgress, forKey: storageProgressKey)
    }
    
//    Загрузка количества переворотов
    func loadCountFlip() -> Int? {
        var newCountFlip: Int
        
        guard let loadedCountFlip = storage.object(forKey: storageCountFlipKey) as? Int else {
            return 0
        }
        
        newCountFlip = loadedCountFlip
        
        return newCountFlip
    }
    
//    Сохранение количества переворотов
    func saveCountFlip(_ count: Int) {
        var newCountFlip: Int
        newCountFlip = count
        
        storage.set(newCountFlip, forKey: storageCountFlipKey)
    }
}
