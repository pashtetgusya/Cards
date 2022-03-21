//
//  BoardGameController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import UIKit

class BoardGameController: UIViewController {
    
//    Экземпляр хранилища прогресса игры
    private var gameSaveStorage: GameProgressStorageProtocol = GameProgressStorage()
//    Хранилище для текущего прогресса игры
    var gameProgress = [CardInfoForStorage]()
    
//    Хранилище для представлений карточек
    var cardViews = [UIView]()
//    Количество переворотов
    var countFlip: Int = 0
    
//    Является ли игра продолжением ранее запущенной
    var isContinuationGame: Bool = false
    
//    Сущность игра
    lazy var game: Game = getNewGame()
//    Элементы интерфейса
    lazy var startButtonView = getStartButtonView()
    lazy var flipAllCardsButtonView = getFlipAllCardsButtonView()
    lazy var goBackButtonView = getGoBackButtonView()
    lazy var goToSettingsButtonView = getGoToSettingsButtinView()
    lazy var gameScoreLabel = getGameScoreLabel()
    lazy var boardGameView = getBoardGameView()

//    Размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
//    Максимально допустимые координаты
    private var cardMaxCoordinateX: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxCoordinateY: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
//    Массив перевернутых карточек
    private var flippedCards = [UIView]()
    
    override func viewDidLoad() {
//        Если запущено продолжение игры
        if isContinuationGame == true {
//            Загружаем игру
            continueGame()
        }
        
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        Если на поле имеются карточки
        if !boardGameView.subviews.isEmpty {
//            Перебираем все карточки
            for card in boardGameView.subviews{
//                Получаем все параметры карточки
                let cardTag = card.tag
                let cardFront = game.cards[card.tag].type
                let cardBack = game.cards[card.tag].backSideType
                let cardColor = game.cards[card.tag].color
                let cardCoordinateX = Int(card.frame.origin.x)
                let cardCoordinateY = Int(card.frame.origin.y)
                
//                Сохраняем парамерты карточки
                let currentCardInfo: CardInfoForStorage = (
                    cardTag: cardTag,
                    cardFrontSide: cardFront,
                    cardBackSide: cardBack,
                    cardColor: cardColor,
                    cardCoordinateX: cardCoordinateX,
                    cardCoordinateY: cardCoordinateY)
                
//                Добавляем в хранилище прогресса
                gameProgress.append(currentCardInfo)
            }
            
//            Получаем текущее количество переворотов
            let countFlip = Int(gameScoreLabel.text ?? "0") ?? 0
            
//            Сохраняем весь текущий прогресс
            gameSaveStorage.saveProgress(gameProgress)
            gameSaveStorage.saveCountFlip(countFlip)
//            Если на поле не осталось карточек
        } else {
//            Сохраняем пустой прогресс
            gameSaveStorage.saveProgress(gameProgress)
        }
    }
    
    override func loadView() {
        super.loadView()
        
//        Добавляем элементы интерфейса на сцену
        view.addSubview(startButtonView)
        view.addSubview(flipAllCardsButtonView)
        view.addSubview(goBackButtonView)
        view.addSubview(goToSettingsButtonView)
        view.addSubview(gameScoreLabel)
        view.addSubview(boardGameView)
    }
    
//    MARK: Обработчики нажатия кнопок
//    Старт новой игры
    @objc func startGame(_ sender: UIButton) {
        for view in boardGameView.subviews {
            view.removeFromSuperview()
        }
        isContinuationGame = false
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        countFlip = 0
        gameScoreLabel.text = "0"
    }
    
//    Перворот всех находящихся на поле карточек
    @objc func flipAllCards(_ sender: UIButton) {
        var frontSideCards: [FlippableView] = []
        var backSideCards: [FlippableView] = []
        
        let cards = boardGameView.subviews as? [FlippableView]

        for card in cards! {
            if card.isFlipped {
                frontSideCards.append(card)
            } else if !card.isFlipped {
                backSideCards.append(card)
            }
        }
        
        if frontSideCards.count > backSideCards.count {
            for card in frontSideCards {
                card.flipWithoutHandler()
            }
        } else {
            for card in backSideCards {
                card.flipWithoutHandler()
            }
        }
    }
    
//    Переход на гланый экран
    @objc func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//    Переход в меню настроек
    @objc func goToSettingsView(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameSettingsController = storyboard.instantiateViewController(withIdentifier: "GameSettingsController")
        navigationController?.pushViewController(gameSettingsController, animated: true)
    }
    
    private func getNewGame() -> Game{
        let game = Game()
        game.generateCards()
        return game
    }
    
//    MARK: Создание интерфейса
//    Кнопка старта игры
    private func getStartButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top

        button.center.x = view.frame.width / 4
        button.frame.origin.y = topPadding
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        
        return button
    }
    
//    Кнопка переворота всех карточек
    private func getFlipAllCardsButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top
        
        button.center.x = view.frame.width / 4 * 3
        button.frame.origin.y = topPadding
        button.setImage(UIImage(systemName: "rectangle.2.swap"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(nil, action: #selector(flipAllCards(_:)), for: .touchUpInside)
        
        return button
    }
    
//    Кнопка возврата в главное меню
    private func getGoBackButtonView() -> UIButton {
        let margin: CGFloat = 10
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top
        
        button.frame.origin.x = margin
        button.frame.origin.y = topPadding
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(nil, action: #selector(goBack(_:)), for: .touchUpInside)
        
        return button
    }
    
//    Кнопка перехода к настройкам
    private func getGoToSettingsButtinView() -> UIButton {
        let margin: CGFloat = 10
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top
        
        button.frame.origin.x = self.view.frame.width - button.frame.width - margin
        button.frame.origin.y = topPadding
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(nil, action: #selector(goToSettingsView(_:)), for: .touchUpInside)
        
        return button
    }
    
//    Счетчик количества переворотов
    private func getGameScoreLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top
        
        label.frame.origin.x = view.center.x
        label.frame.origin.y = topPadding
        label.text = "0"
        
        return label
    }
    
//    Игровое поле
    private func getBoardGameView() -> UIView {
        let margin: CGFloat = 10
        
        let boardView = UIView()
                
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top
        let bottomPadding = window!.safeAreaInsets.bottom
        
        boardView.frame.origin.x = margin
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - bottomPadding
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 8/255, green: 69/255, blue: 8/255, alpha: 1)
        
        return boardView
    }
    
//    Генерация массива карточек на оснвое данных модели
    private func getCardBy(modelData: [Card]) -> [UIView] {
//        Хранилище для представлений карточек
        var cardViews = [UIView]()
//        Фабрика карточек
        let cardViewFactory = CardViewFactory()
        
        
        switch isContinuationGame {
//            Если игра была загружена
        case true:
//            Перебираем массив карточек
            for (index, modelCard) in modelData.enumerated() {
//                Создаем экземпляр загруженной карточки
                let newCard = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
                let cardTag = gameProgress[index].cardTag
                newCard.tag = cardTag
//                Добавляем созданную карточку
                cardViews.append(newCard)
            }
//            Если началась новая игра
        case false:
//            Перебираем массив карточек
            for (index, modelCard) in modelData.enumerated() {
//                Создаем два экземпляра карточки
                let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
                let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
                cardOne.tag = index
                cardTwo.tag = index
//                Добавляем созданные карточки
                cardViews.append(cardOne)
                cardViews.append(cardTwo)
            }
        }
        
//        Устанавливаем для каждой карточки обработчик переворота
        for card in cardViews {
            getCardFlipHandler(card: card)
        }
        return cardViews
    }
    
//    Добавление карточке обработчик переворота
    private func getCardFlipHandler(card: UIView) {
        (card as! FlippableView).flippCompletationHandler = { [self] flippedCard in
//            Переносим карту ввео иерархии
            flippedCard.superview?.bringSubviewToFront(flippedCard)
            
//            Добавляем или удаляем карту
            if flippedCard.isFlipped {
                flippedCards.append(flippedCard)
                countFlip += 1
                gameScoreLabel.text = String(countFlip)
            } else {
                if let cardIndex = flippedCards.firstIndex(of: flippedCard) {
                    flippedCards.remove(at: cardIndex)
                }
            }
            
//            Если перевернуто 2 карты
            if self.flippedCards.count == 2 {
//                Получаем карты из данных модели
                let firstCard = game.cards[flippedCards.first!.tag]
                let secondCard = game.cards[flippedCards.last!.tag]
                
//                Если карты одинаковые
                if game.checkCards(firstCard, secondCard) {
//                    Анимированно скрываем
                    UIView.animate(withDuration: 0.3, animations: { [self] in
                        flippedCards.first!.layer.opacity = 0
                        flippedCards.last!.layer.opacity = 0
//                        Удаляем из иерархии
                    }, completion: { [self] _ in
                        flippedCards.first!.removeFromSuperview()
                        flippedCards.last!.removeFromSuperview()
                        flippedCards = []
//                        Если карточек не остается
                        if boardGameView.subviews.isEmpty {
//                            Отображаем всплывающее окно с результатом и предложением начать новую игру
                            showGameEndedAlert()
                        }
                    })
//                    Иначе переворачиваем карты обратно
                } else {
                    for card in flippedCards {
                        (card as! FlippableView).flip()
                    }
                }
            }
        }
    }
    
//    Отображение всплывающего окна, уведомляющего об окончании игры
    private func showGameEndedAlert() {
//        Создаем всплывающее окно
        let alert = UIAlertController(
            title: "Игра закончена",
            message: "Поздравляем, вы закончили игру. Количество переворотов – \(countFlip).",
            preferredStyle: .alert
        )
        
//        Создаем кнопку начала новой игры
        let newGameAction = UIAlertAction(title: "Новая игра", style: .default) {_ in
            self.game = self.getNewGame()
            let cards = self.getCardBy(modelData: self.game.cards)
            self.placeCardsOnBoard(cards)
            self.countFlip = 0
            self.gameScoreLabel.text = "0"
        }
//        Создаем кнопку выхода
        let endGameAction = UIAlertAction(title: "Выход", style: .cancel) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        
//        Добавляем кнопки на всплывающее окно
        alert.addAction(newGameAction)
        alert.addAction(endGameAction)
        
        present(alert, animated: true, completion: nil)
    }
    
//    MARK: Загрузка схораненной игры
    private func continueGame() {
        var loadedCards = [Card]()
        var loadedCardsCoordinates = [CGPoint]()
//        Загружаем карточки
        guard let loadedGameProgress = gameSaveStorage.loadProgress() else {
            return
        }
//        Загружаем количество переворотов
        guard let loadedCountFlip = gameSaveStorage.loadCountFlip() else {
            return
        }
        
        for loadedCard in loadedGameProgress {
            let newCard: Card = (loadedCard.cardFrontSide, loadedCard.cardBackSide, loadedCard.cardColor)
            let newCardCoordinate = CGPoint(x: loadedCard.cardCoordinateX, y: loadedCard.cardCoordinateY)
            
            loadedCards.append(newCard)
            loadedCardsCoordinates.append(newCardCoordinate)
        }
        
        game.getCardsFromProgressStorage(loadedGameProgress)
        
        let cards = getCardBy(modelData: loadedCards)
        placeLoadedCardOnBoard(cards, loadedCardsCoordinates)
        
        gameScoreLabel.text = String(loadedCountFlip)
    }
    
//    MARK: Размещение карточек на игровом поле
//    Размещения карточек
    private func placeCardsOnBoard(_ cards: [UIView]) {
//        Удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        
        cardViews = cards
//        Перебираем все карточки
        for card in cardViews {
//            Для каждой карточки устанавливаем случайные координаты
            let randomCoordinateX = Int.random(in: 0...cardMaxCoordinateX)
            let randomCoordinateY = Int.random(in: 0...cardMaxCoordinateY)
            card.frame.origin = CGPoint(x: randomCoordinateX, y: randomCoordinateY)
//            Размещаем карточку на игровом поле
            boardGameView.addSubview(card)
        }
    }
    
//    Размещения ранее загруженных карточек
    private func placeLoadedCardOnBoard(_ cards: [UIView], _ coordinates: [CGPoint]) {
        for i in 0..<cards.count {
//            Получаем карточку
            let card = cards[i]
//            Устанавливаем соответствующие координаты из массива координат
            card.frame.origin = coordinates[i]
//            Размещаем карточку на игровом поле
            boardGameView.addSubview(card)
        }

    }
}
