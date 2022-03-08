//
//  BoardGameController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import UIKit

class BoardGameController: UIViewController {
    
    var cardsPairsCount = 4
    var cardViews = [UIView]()
    
    lazy var game: Game = getNewGame()
    lazy var startButtonView = getStartButtonView()
    lazy var flipAllCardsButtonView = getFlipAllCardsButtonView()
    lazy var goBackButtonView = getGoBackButtonView()
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
        
        view.backgroundColor = .white
        view.addSubview(startButtonView)
        view.addSubview(flipAllCardsButtonView)
        view.addSubview(goBackButtonView)
        view.addSubview(boardGameView)
    }
    
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
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
    
    private func getNewGame() -> Game{
        let game = Game()
        
        game.cardsCount = self.cardsPairsCount
        game.generateCards()
        
        return game
    }
    
    private func getStartButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window!.safeAreaInsets.top
        
        button.center.x = view.center.x
        button.frame.origin.y = topPadding
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func getFlipAllCardsButtonView() -> UIButton {
        let margin: CGFloat = 10
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - margin * 2, height: 30))
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        let bottomPadding = window!.safeAreaInsets.bottom
        
        button.center.x = view.center.x
        button.frame.origin.y = self.view.frame.height - bottomPadding - 20
        button.setTitle("Перевернуть все карточки", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(flipAllCards(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func getGoBackButtonView() -> UIButton {
        let margin: CGFloat = 10
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        
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
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - bottomPadding - flipAllCardsButtonView.frame.height
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 8/255, green: 69/255, blue: 8/255, alpha: 1)
        
        return boardView
    }
    
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
            (card as! FlippableView).flippCompletationHandler = { flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)
            }
        }
        
        for card in cardViews {
            (card as! FlippableView).flippCompletationHandler = { [self] flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                if self.flippedCards.count == 2 {
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    if game.checkCards(firstCard, secondCard) {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        }, completion: { _ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        })
                    } else {
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                    }
                }
            }
        }
        
        return cardViews
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
