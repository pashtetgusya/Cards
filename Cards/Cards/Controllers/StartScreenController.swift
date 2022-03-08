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
    
    private func setupStartScreenView() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        let stackViewForButtoms = getStackView()
        let goToGameScreenButton = getGoToGameScreenButton()
        
        view.addSubview(stackViewForButtoms)
        stackViewForButtoms.addSubview(goToGameScreenButton)
    }
    
    private func getStackView() -> UIStackView {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        stack.center.x = view.center.x
        stack.center.y = view.center.y
        
        return stack
    }
    
    private func getGoToGameScreenButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(goToBoardGameView(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func goToBoardGameView(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let boardGameController = storyboard.instantiateViewController(withIdentifier: "BoardGameController")
        navigationController?.pushViewController(boardGameController, animated: true)
    }
}
