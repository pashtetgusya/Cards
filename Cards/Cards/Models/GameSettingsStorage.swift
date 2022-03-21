//
//  GameSettingsStorage.swift
//  Cards
//
//  Created by Pavel Yarovoi on 10.03.2022.
//

import Foundation

//Хранилище настроек игры
typealias GameSettings = (
    availableCardBacks: [CardBackSideType],
    availableCardFronts: [CardType],
    availableCardColors: [CardColor],
    countCardPairs: Int
)

//Протокол хранилища настроек игры
protocol GameSettingsStorageProtocol {
    func loadSettings() -> GameSettings
    func saveSettings(_ settings: GameSettings)
}

class GameSettingStorage: GameSettingsStorageProtocol {
    
    private enum SettingsKey: String {
        case backs
        case fronts
        case colors
        case pairs
    }
    
//    Стандартные настройки игры
    private let defaultSettings: GameSettings = (
        CardBackSideType.allCases,
        CardType.allCases,
        CardColor.allCases,
        5
    )
    
    private var storage = UserDefaults.standard
    let storageKey: String = "cardsSettings"
    
//    Загрузка настроек
    func loadSettings() -> GameSettings{
        var resultSettings: GameSettings
        var resultBacks: [CardBackSideType] = []
        var resultFronts: [CardType] = []
        var resultColors: [CardColor] = []
        var resultCountPairs: Int
        
        guard let settingsFromStorage = storage.object(forKey: storageKey) as? [String: [String]] else {
            return defaultSettings
        }
        
        guard let rawBacks = settingsFromStorage[SettingsKey.backs.rawValue],
              let rawFronts = settingsFromStorage[SettingsKey.fronts.rawValue],
              let rawColors = settingsFromStorage[SettingsKey.colors.rawValue],
              let rawPairs = settingsFromStorage[SettingsKey.pairs.rawValue] else {
                  return defaultSettings
              }
        guard !rawBacks.isEmpty,
              !rawFronts.isEmpty,
              !rawColors.isEmpty else {
                  return defaultSettings
              }
        
        for rawBack in rawBacks {
            let back: CardBackSideType.RawValue = rawBack
            resultBacks.append(CardBackSideType(rawValue: back)!)
        }
        for rawFront in rawFronts {
            let front: CardType.RawValue = rawFront
            resultFronts.append(CardType(rawValue: front)!)
        }
        for rawColor in rawColors {
            let color: CardColor.RawValue = rawColor
            resultColors.append(CardColor(rawValue: color)!)
        }
        resultCountPairs = Int(rawPairs.first ?? "5") ?? 5
        
        resultSettings.availableCardBacks = resultBacks
        resultSettings.availableCardFronts = resultFronts
        resultSettings.availableCardColors = resultColors
        resultSettings.countCardPairs = resultCountPairs
        
        return resultSettings
    }
    
//    Сохранение настроек
    func saveSettings(_ settings: GameSettings) {
        var newGameSettingsArray: [String: [String]] = [:]
        
        newGameSettingsArray[SettingsKey.backs.rawValue] = settings.availableCardBacks.map { back in
            back.rawValue
        }
        newGameSettingsArray[SettingsKey.fronts.rawValue] = settings.availableCardFronts.map { front in
            front.rawValue
        }
        newGameSettingsArray[SettingsKey.colors.rawValue] = settings.availableCardColors.map { color in
            color.rawValue
        }
        
        let pairsCount = String(settings.countCardPairs)
        newGameSettingsArray[SettingsKey.pairs.rawValue] = [pairsCount]
        
        storage.set(newGameSettingsArray, forKey: storageKey)
    }
    
}
