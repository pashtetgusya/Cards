//
//  CardTypeController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class EditCardTypeController: UITableViewController {
    
    typealias TypeCardFrontSideShapeInformation = (type: CardType, title: String)
    
    lazy var cardViewFactory = CardViewFactory()
    
    var cardFrontSideShapeInformation: [TypeCardFrontSideShapeInformation] = [
        (type: .filledCircle, title: "Закрашенный круг"),
        (type: .unfilledCircle, title: "Не закрашенный круг"),
        (type: .cross, title: "Крест"),
        (type: .square, title: "Квадрат"),
        (type: .fill, title: "Закрашенный прямоугольник")
    ]
    
    var doAfterCardTypeSelected: (([CardType]) -> Void)?
    var selectedCardTypes: [CardType] = []

    @objc func goBack(_ sender: UIBarButtonItem) {
        guard selectedCardTypes.count > 0 else {
            let allertController = UIAlertController(
                title: "Ошибка",
                message: "Выберите хотя бы одну фигуру",
                preferredStyle: .alert
            )
            let actionOK = UIAlertAction(
                title: "Ок",
                style: .cancel,
                handler: nil
            )
            allertController.addAction(actionOK)
            present(allertController, animated: true, completion: nil)
            return
        }
        doAfterCardTypeSelected?(selectedCardTypes)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellTypeNib = UINib(nibName: "CardSideViewCell", bundle: nil)
        tableView.register(cellTypeNib, forCellReuseIdentifier: "CardSideViewCell")
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(goBack(_:))
        )
        navigationItem.leftBarButtonItem = backButton
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardFrontSideShapeInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardSideViewCell", for: indexPath) as! CardSideViewCell
        let typeDescription = cardFrontSideShapeInformation[indexPath.row]
        
        let cardFrontSideShapeView = cardViewFactory.getFrontSideView(
            typeDescription.type,
            withSize: CGSize(width: 60, height: 60),
            andColor: .black
        )
        
        cell.cardSideShape.addSubview(cardFrontSideShapeView)
        cell.cardSideShapeName.text = typeDescription.title
        
        if selectedCardTypes.contains(typeDescription.type) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentFrontSide = cardFrontSideShapeInformation[indexPath.row].type
        
        if !selectedCardTypes.contains(currentFrontSide) {
            selectedCardTypes.append(currentFrontSide)
            tableView.reloadData()
        } else {
            guard let currentFrontSideIndex = selectedCardTypes.firstIndex(of: currentFrontSide) else {
                return
            }
            selectedCardTypes.remove(at: currentFrontSideIndex)
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
