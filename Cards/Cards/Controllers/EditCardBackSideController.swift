//
//  CardBackSideController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class EditCardBackSideController: UITableViewController {
    
    typealias TypeCardBackSideShapeInformation = (type: CardBackSideType, title: String)

    lazy var cardViewFactory = CardViewFactory()
    
    var cardBackSideShapeInformation: [TypeCardBackSideShapeInformation] = [
        (type: .line, title: "Линии"),
        (type: .circle, title: "Круги")
    ]
    
    var doAfterCardBackSideSelected: (([CardBackSideType]) -> Void)?
    var selectedBackSides: [CardBackSideType] = []

    @objc func goBack(_ sender: UIBarButtonItem) {
        guard selectedBackSides.count > 0 else {
            let allertController = UIAlertController(
                title: "Ошибка",
                message: "Выберите хотя бы одну рубашку",
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
        doAfterCardBackSideSelected?(selectedBackSides)
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
        return cardBackSideShapeInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardSideViewCell", for: indexPath) as! CardSideViewCell
        let typeDescription = cardBackSideShapeInformation[indexPath.row]
        
        let cardFrontSideShapeView = cardViewFactory.getBackSideView(
            typeDescription.type,
            withSize: CGSize(width: 60, height: 60),
            andColor: .black
        )
        
        cell.cardSideShape.addSubview(cardFrontSideShapeView)
        cell.cardSideShapeName.text = typeDescription.title
        
        if selectedBackSides.contains(typeDescription.type) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBackSide = cardBackSideShapeInformation[indexPath.row].type
        
        if !selectedBackSides.contains(currentBackSide) {
            selectedBackSides.append(currentBackSide)
            tableView.reloadData()
        } else {
            guard let currentBackSideIndex = selectedBackSides.firstIndex(of: currentBackSide) else {
                return
            }
            selectedBackSides.remove(at: currentBackSideIndex)
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
