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
    
//    Перечисление ключей настроек
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
    
//    Создаем хранилище UserDefaults
    private var storage = UserDefaults.standard
//    Ключ, по которому будут храниться настройки игры
    let storageKey: String = "cardsSettings"
    
//    Загрузка настроек
    func loadSettings() -> GameSettings{
        var resultSettings: GameSettings
        var resultBacks: [CardBackSideType] = []
        var resultFronts: [CardType] = []
        var resultColors: [CardColor] = []
        var resultCountPairs: Int
        
//        Загружаем из UserDefaults настройки игры
        guard let settingsFromStorage = storage.object(forKey: storageKey) as? [String: [String]] else {
            return defaultSettings
        }
        
//        Получаем параметры
        guard let rawBacks = settingsFromStorage[SettingsKey.backs.rawValue],
              let rawFronts = settingsFromStorage[SettingsKey.fronts.rawValue],
              let rawColors = settingsFromStorage[SettingsKey.colors.rawValue],
              let rawPairs = settingsFromStorage[SettingsKey.pairs.rawValue] else {
                  return defaultSettings
              }
        
//        Если нет сохраненных настроек, то возвращаем стандартные
        guard !rawBacks.isEmpty,
              !rawFronts.isEmpty,
              !rawColors.isEmpty else {
                  return defaultSettings
              }
        
//        Добавляем в соответствующие массивы параметры карточек
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
        
//        Сохраняем загруженные из хранилища параметры игры
        resultSettings.availableCardBacks = resultBacks
        resultSettings.availableCardFronts = resultFronts
        resultSettings.availableCardColors = resultColors
        resultSettings.countCardPairs = resultCountPairs
        
        return resultSettings
    }
    
//    Сохранение настроек
    func saveSettings(_ settings: GameSettings) {
//        Хранилище для новых настроек
        var newGameSettingsArray: [String: [String]] = [:]
        
//        Сохраняем вырбранные пользователем парамерты карточек (обложка, рубашка и цвет)
        newGameSettingsArray[SettingsKey.backs.rawValue] = settings.availableCardBacks.map { back in
            back.rawValue
        }
        newGameSettingsArray[SettingsKey.fronts.rawValue] = settings.availableCardFronts.map { front in
            front.rawValue
        }
        newGameSettingsArray[SettingsKey.colors.rawValue] = settings.availableCardColors.map { color in
            color.rawValue
        }
        
//        Сохраняем выбранное пользователем количество пар карточек
        let pairsCount = String(settings.countCardPairs)
        newGameSettingsArray[SettingsKey.pairs.rawValue] = [pairsCount]
     
//        Сохраняем настройки в UserDefaults
        storage.set(newGameSettingsArray, forKey: storageKey)
    }
    
}
