//
//  BoardGameController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import UIKit

class BoardGameController: UIViewController {
    
    var cardViews = [UIView]()
    var countFlip: Int = 0
    
    lazy var game: Game = getNewGame()
    lazy var startButtonView = getStartButtonView()
    lazy var flipAllCardsButtonView = getFlipAllCardsButtonView()
    lazy var goBackButtonView = getGoBackButtonView()
    lazy var goToSettingsButtonView = getGoToSettingsButtinView()
    lazy var gameScoreLabel = getGameScoreLabel()
    lazy var boardGameView = getBoardGameView()

    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    private var cardMaxCoordinateX: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxCoordinateY: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    private var flippedCards = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(startButtonView)
        view.addSubview(flipAllCardsButtonView)
        view.addSubview(goBackButtonView)
        view.addSubview(goToSettingsButtonView)
        view.addSubview(gameScoreLabel)
        view.addSubview(boardGameView)
    }
    
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        countFlip = 0
        gameScoreLabel.text = "0"
    }
    
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
    
    @objc func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
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
    
//TODO: refactor func
    private func getCardBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardTwo.tag = index
            
            cardViews.append(cardOne)
            cardViews.append(cardTwo)
        }
        
        for card in cardViews {
            getCardFlipHandler(card: card)
        }
        return cardViews
    }
    
    private func getCardFlipHandler(card: UIView) {
        (card as! FlippableView).flippCompletationHandler = { [self] flippedCard in
            flippedCard.superview?.bringSubviewToFront(flippedCard)
            
            if flippedCard.isFlipped {
                flippedCards.append(flippedCard)
                countFlip += 1
                gameScoreLabel.text = String(countFlip)
            } else {
                if let cardIndex = flippedCards.firstIndex(of: flippedCard) {
                    flippedCards.remove(at: cardIndex)
                }
            }
            
            if self.flippedCards.count == 2 {
                let firstCard = game.cards[flippedCards.first!.tag]
                let secondCard = game.cards[flippedCards.last!.tag]
                
                if game.checkCards(firstCard, secondCard) {
                    UIView.animate(withDuration: 0.3, animations: {
                        flippedCards.first!.layer.opacity = 0
                        flippedCards.last!.layer.opacity = 0
                    }, completion: { _ in
                        flippedCards.first!.removeFromSuperview()
                        flippedCards.last!.removeFromSuperview()
                        flippedCards = []
                        if boardGameView.subviews.isEmpty {
                            showGameEndedAlert()
                        }
                    })
                } else {
                    for card in flippedCards {
                        (card as! FlippableView).flip()
                    }
                }
            }
        }
    }
    
    private func showGameEndedAlert() {
        let alert = UIAlertController(
            title: "Игра закончена",
            message: "Поздравляем, вы закончили игру. Количество переворотов – \(countFlip).",
            preferredStyle: .alert
        )
        
        let newGameAction = UIAlertAction(title: "Новая игра", style: .default) {_ in
            self.game = self.getNewGame()
            let cards = self.getCardBy(modelData: self.game.cards)
            self.placeCardsOnBoard(cards)
            self.countFlip = 0
            self.gameScoreLabel.text = "0"
        }
        let endGameAction = UIAlertAction(title: "Выход", style: .cancel) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(newGameAction)
        alert.addAction(endGameAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        for card in cardViews {
            card.removeFromSuperview()
        }
        
        cardViews = cards
        
        for card in cardViews {
            let randomCoordinateX = Int.random(in: 0...cardMaxCoordinateX)
            let randomCoordinateY = Int.random(in: 0...cardMaxCoordinateY)
            
            card.frame.origin = CGPoint(x: randomCoordinateX, y: randomCoordinateY)
            
            boardGameView.addSubview(card)
        }
    }
}
