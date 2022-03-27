//
//  CardColorController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class EditCardColorController: UITableViewController {
    
//    Кортеж, описывающий цвет карточки
    typealias TypeCardColorInformation = (type: CardColor, title: String, color: UIColor)
    
//    Название типов цветов карточек
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
    
//    Обработка выбора цветов картчоек
    var doAfterColorSelected: (([CardColor]) -> Void)?
//    Выбранные цвета карточек
    var selectedColors: [CardColor] = []

    @objc func goBack(_ sender: UIBarButtonItem) {
//        Проверка на количество выбранных цветов
        guard selectedColors.count > 0 else {
//            Если пользователь не выбрал ни один цвет, то появляется соответствующее уведомление
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
//        Вызов обработчика
        doAfterColorSelected?(selectedColors)
//        Возврат к предыдущему экрану
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Получение значения типа UINib, соответствующее xib-файлу ячейки
        let cellTypeNib = UINib(nibName: "CardColorCell", bundle: nil)
//        Регистрация ячейки в табличном представлении
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
//        Загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardColorCell", for: indexPath) as! CardColorCell
//        Получаем данные о цвете, который необходимо вывести в ячейке
        let typeDescription = cardColorInformation[indexPath.row]
        
//        Изменяем цвет "Квадрата цвета" в ячейке
        cell.cardColor.backgroundColor = typeDescription.color
//        Изменяем название цвета
        cell.cardColorName.text = typeDescription.title
        
//        Если цвет находится в списке выбранных, то отмечаем его
        if selectedColors.contains(typeDescription.type) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Текущий цвет
        let currentColor = cardColorInformation[indexPath.row].type
        
//        Если цвета нет в списке выбранных, то добавляем 
        if !selectedColors.contains(currentColor) {
            selectedColors.append(currentColor)
            tableView.reloadData()
//        Если он уже был выбран, то удаляем его
        } else {
            guard let currentColorIndex = selectedColors.firstIndex(of: currentColor) else {
                return
            }
            selectedColors.remove(at: currentColorIndex)
            tableView.reloadData()
        }
        
//        Снимаем выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
