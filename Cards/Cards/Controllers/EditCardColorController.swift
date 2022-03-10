//
//  CardColorController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class EditCardColorController: UITableViewController {
    
    typealias TypeCardColorInformation = (type: CardColor, title: String, color: UIColor)
    
    var cardColorInformation: [TypeCardColorInformation] = [
        (type: .red, title: "Красный", color: .red),
        (type: .green, title: "Зеленый", color: .green),
        (type: .black, title: "Черный", color: .black),
        (type: .gray, title: "Серый", color: .gray),
        (type: .brown, title: "Коричневый", color: .brown),
        (type: .yellow, title: "Желтый", color: .yellow),
        (type: .purple, title: "Фиолетовый", color: .purple),
        (type: .orange, title: "Оранжевый", color: .orange)
    ]
    
    var doAfterColorSelected: (([CardColor]) -> Void)?
    var selectedColors: [CardColor] = []

    @objc func goBack(_ sender: UIBarButtonItem) {
        guard selectedColors.count > 0 else {
            let allertController = UIAlertController(
                title: "Ошибка",
                message: "Выберите хотя бы один цвет",
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
        doAfterColorSelected?(selectedColors)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellTypeNib = UINib(nibName: "CardColorCell", bundle: nil)
        tableView.register(cellTypeNib, forCellReuseIdentifier: "CardColorCell")
        
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
        return cardColorInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardColorCell", for: indexPath) as! CardColorCell
        let typeDescription = cardColorInformation[indexPath.row]
        
        cell.cardColor.backgroundColor = typeDescription.color
        cell.cardColorName.text = typeDescription.title
        
        if selectedColors.contains(typeDescription.type) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentColor = cardColorInformation[indexPath.row].type
        
        if !selectedColors.contains(currentColor) {
            selectedColors.append(currentColor)
            tableView.reloadData()
        } else {
            guard let currentColorIndex = selectedColors.firstIndex(of: currentColor) else {
                return
            }
            selectedColors.remove(at: currentColorIndex)
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
