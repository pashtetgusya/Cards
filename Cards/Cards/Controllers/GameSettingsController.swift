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
        gameSettings = (
            availableCardBacks: gameCardBackSide,
            availableCardFronts: gameCardType,
            availableCardColors: gameCardColor,
            countCardPairs: Int(countCardPairs.value)
        )
        storage.saveSettings(gameSettings)
        navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            let destination = segue.destination as! EditCardBackSideController
            destination.selectedBackSides = gameSettings.availableCardBacks
            destination.doAfterCardBackSideSelected = { [self] selectedCardBackShapes in
                gameCardBackSide = selectedCardBackShapes
            }
        }
        
        if segue.identifier == "toEditCardType" {
            let destination = segue.destination as! EditCardTypeController
            destination.selectedCardTypes = gameSettings.availableCardFronts
            destination.doAfterCardTypeSelected = { [self] selectedCardFrontShapes in
                gameCardType = selectedCardFrontShapes
            }
        }
        
        if segue.identifier == "toEditCardColor" {
            let destination = segue.destination as! EditCardColorController
            destination.selectedColors = gameSettings.availableCardColors
            destination.doAfterColorSelected = { [self] selectedCardColors in
                gameCardColor = selectedCardColors
            }
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.isNavigationBarHidden = true
    }
    
}
