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
    
//    Перечисление ключей параметров карточки
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
//        Хранилище загруженного прогресса игры
        var loadedGameProgress: [CardInfoForStorage] = []
        
//        Загружаем из UserDefaults сохраненноый прогрес игры
        guard let progressFromStorage = storage.object(forKey: storageProgressKey) as? [[String: String]] else {
            return nil
        }
        
//        Перебираем все карточки из сохраненного прогресса
        for card in progressFromStorage {
//            Получаем параметры карточки
            guard let tag = card[ProgressKey.cardTag.rawValue],
                  let front = card[ProgressKey.cardFront.rawValue],
                  let back = card[ProgressKey.cardBack.rawValue],
                  let color = card[ProgressKey.cardColor.rawValue],
                  let coordinateX = card[ProgressKey.coordinateX.rawValue],
                  let coordinateY = card[ProgressKey.coordinateY.rawValue] else {
                return nil
            }
//            Преобразуем параметры карточки в соответствующие типы
            let cardTag = Int(tag)!
            let cardFront = CardType(rawValue: front)!
            let cardBack = CardBackSideType(rawValue: back)!
            let cardColor = CardColor(rawValue: color)!
            let cardCoordinateX = Int(coordinateX)!
            let cardCoordinateY = Int(coordinateY)!
            
//            Сохраняем все параметры карточк
            let loadedCard: CardInfoForStorage = (
                cardTag: cardTag,
                cardFrontSide: cardFront,
                cardBackSide: cardBack,
                cardColor: cardColor,
                cardCoordinateX: cardCoordinateX,
                cardCoordinateY: cardCoordinateY)
            
//            Добавляем карточку в хранилище загруженного прогресса
            loadedGameProgress.append(loadedCard)
        }
        
        return loadedGameProgress
    }
    
//    Сохранение прогресса
    func saveProgress(_ progress: [CardInfoForStorage]) {
//        Хранилище прогресса игры
        var newGameProgress: [[String: String]] = []
        
//        Перебираем переданные карточки
        for card in progress {
//            Хранилище параметов карточки
            var savedCard: [String: String] = [:]
            
//            Записываем в хранилище параметры карточки
            savedCard[ProgressKey.cardTag.rawValue] = String(card.cardTag)
            savedCard[ProgressKey.cardFront.rawValue] = card.cardFrontSide.rawValue
            savedCard[ProgressKey.cardBack.rawValue] = card.cardBackSide.rawValue
            savedCard[ProgressKey.cardColor.rawValue] = card.cardColor.rawValue
            savedCard[ProgressKey.coordinateX.rawValue] = String(card.cardCoordinateX)
            savedCard[ProgressKey.coordinateY.rawValue] = String(card.cardCoordinateY)
            
//            Добавляем карточку в хранилище прогресса
            newGameProgress.append(savedCard)
        }

//        Записываем прогресс игры в UserDefauilts
        storage.set(newGameProgress, forKey: storageProgressKey)
    }
    
//    Загрузка количества переворотов
    func loadCountFlip() -> Int? {
        var newCountFlip: Int
        
//        Загружаем из UserDefauilts количество переворотов
        guard let loadedCountFlip = storage.object(forKey: storageCountFlipKey) as? Int else {
            return 0
        }
        
//        Сохраняем загруженное из хранилища количество переворотов
        newCountFlip = loadedCountFlip
        
        return newCountFlip
    }
    
//    Сохранение количества переворотов
    func saveCountFlip(_ count: Int) {
        var newCountFlip: Int
//        Записываем переданное количество переворотов
        newCountFlip = count
        
//        Сохраняем в UserDefaults
        storage.set(newCountFlip, forKey: storageCountFlipKey)
    }
}
