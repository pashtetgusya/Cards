//
//  GameSettingsController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 08.03.2022.
//

import UIKit

class GameSettingsController: UITableViewController {
    
    private var storage: GameSettingsStorageProtocol = GameSettingStorage()
    private var gameSettings: GameSettings!
    
    private var gameCardPairsCount: Int = 0
    private var gameCardType: Array<CardType> = [CardType]()
    private var gameCardColor: Array<CardColor> = [CardColor]()
    private var gameCardBackSide: Array<CardBackSideType> = [CardBackSideType]()

    @IBOutlet var countCardPairs: UISlider!
    
    @objc func goBack(_ sender: UIBarButtonItem) {
//        Сохраняем выбранные пользователем настройки
        gameSettings = (
            availableCardBacks: gameCardBackSide,
            availableCardFronts: gameCardType,
            availableCardColors: gameCardColor,
            countCardPairs: Int(countCardPairs.value)
        )
//        Сохраняем настройки
        storage.saveSettings(gameSettings)
        navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Загружаем настройки
        gameSettings = storage.loadSettings()
        countCardPairs.value = Float(gameSettings.countCardPairs)
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(goBack(_:))
        )
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationItem.backButtonDisplayMode = .minimal
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditCardBackSide" {
//            Ссылка на контроллер назначения
            let destination = segue.destination as! EditCardBackSideController
//            Передача выбранных рубашек карт
            destination.selectedBackSides = gameSettings.availableCardBacks
//            Передача обработчика выбора рубашек карт
            destination.doAfterCardBackSideSelected = { [self] selectedCardBackShapes in
                gameCardBackSide = selectedCardBackShapes
            }
        }
        
        if segue.identifier == "toEditCardType" {
//            Ссылка на контроллер назначения
            let destination = segue.destination as! EditCardTypeController
//            Передача выбранных фигур карт
            destination.selectedCardTypes = gameSettings.availableCardFronts
//            Передача обработчика выбора фигур карт
            destination.doAfterCardTypeSelected = { [self] selectedCardFrontShapes in
                gameCardType = selectedCardFrontShapes
            }
        }
        
        if segue.identifier == "toEditCardColor" {
//            Ссылка на контроллер назначения
            let destination = segue.destination as! EditCardColorController
//            Передача выбранных цветов карт
            destination.selectedColors = gameSettings.availableCardColors
//            Передача выбора цветов карт
            destination.doAfterColorSelected = { [self] selectedCardColors in
                gameCardColor = selectedCardColors
            }
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.isNavigationBarHidden = true
    }
    
}
