//
//  StartScreenController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 07.03.2022.
//

import UIKit

class StartScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setupStartScreenView()
    }
    
//    Настройка главного экрана
    private func setupStartScreenView() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
//        Создаем элементы интерфейса
        let stackViewForButtons = getStackView()
        let goToGameScreenButton = getNewButton(
            title: "Начать игру",
            selector: #selector(goToBoardGameView(_:))
        )
        let goToSettingsScreenButton = getNewButton(
            title: "Настройки",
            selector: #selector(goToSettingsView(_:))
        )
        let continuGameButton = getNewButton(
            title: "Продолжить игру",
            selector: #selector(continueGame(_:))
        )
        
//        Добавляем элементы интерфейса на сцену
        view.addSubview(stackViewForButtons)
        stackViewForButtons.addArrangedSubview(goToGameScreenButton)
        stackViewForButtons.addArrangedSubview(continuGameButton)
        stackViewForButtons.addArrangedSubview(goToSettingsScreenButton)
    }

//    MARK: Создание интерфейса
//    Стэк для кнопок
    private func getStackView() -> UIStackView {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        stack.center.x = view.center.x
        stack.center.y = view.center.y
        
        stack.spacing = 3
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        return stack
    }
    
//    Кнопка
    private func getNewButton(title: String, selector: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        button.setTitle("\(title)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: selector, for: .touchUpInside)
        
        return button
        
    }
    
//    Отображение всплывающего окна, уведомляющего об отсутствии сохраненной игры
    private func showProgressGameIsEmptyAllert() {
//        Создаем всплывающее окно
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не найденно сохраненной игры",
            preferredStyle: .alert
        )
        
//        Создаем кнопку начала новой игры
        let newGameAction = UIAlertAction(
            title: "Новая игра",
            style: .default) {_ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let boardGameController = storyboard.instantiateViewController(withIdentifier: "BoardGameController")
                self.navigationController?.pushViewController(boardGameController, animated: true)
            }
//        Создаем кноку закрытия окна
        let endAction = UIAlertAction(title: "Выход", style: .cancel, handler: nil)
        
//        Добавляем кнопки на всплывающее окно
        alert.addAction(newGameAction)
        alert.addAction(endAction)
        
        present(alert, animated: true, completion: nil)
    }
    
//    MARK: Обработчики нажатия кнопок
//    Переход к началу новой игры
    @objc func goToBoardGameView(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let boardGameController = storyboard.instantiateViewController(withIdentifier: "BoardGameController")
        navigationController?.pushViewController(boardGameController, animated: true)
    }
    
//    Переход в меню настроек
    @objc func goToSettingsView(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameSettingsController = storyboard.instantiateViewController(withIdentifier: "GameSettingsController")
        navigationController?.pushViewController(gameSettingsController, animated: true)
    }
    
//    Продолжение ранее сохраненной игры
    @objc func continueGame(_ sender: UIButton) {
        let storage = GameProgressStorage()
        let loadedProgress = storage.loadProgress()
        
        if loadedProgress!.isEmpty {
            showProgressGameIsEmptyAllert()
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let boardGameController = storyboard.instantiateViewController(withIdentifier: "BoardGameController") as! BoardGameController
        boardGameController.isContinuationGame = true
        boardGameController.gameProgress = loadedProgress!
        navigationController?.pushViewController(boardGameController, animated: true)
        
    }
}
