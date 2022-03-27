//
//  CardBackSideController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class EditCardBackSideController: UITableViewController {
    
//    Коржет, описывающий рубашку карточеки
    typealias TypeCardBackSideShapeInformation = (type: CardBackSideType, title: String)

//    Фабрика карточек
    lazy var cardViewFactory = CardViewFactory()
    
//    Название типов рубашек карточек
    var cardBackSideShapeInformation: [TypeCardBackSideShapeInformation] = [
        (type: .line, title: "Линии"),
        (type: .circle, title: "Круги")
    ]
    
//    Обработка выбора рубашек карточек
    var doAfterCardBackSideSelected: (([CardBackSideType]) -> Void)?
//    Выбранные рубашки карточек
    var selectedBackSides: [CardBackSideType] = []

    @objc func goBack(_ sender: UIBarButtonItem) {
//        Проверка на количество выбранных рубашек
        guard selectedBackSides.count > 0 else {
//            Если пользователь не выбрал ни один тип рубашки, то появляется соответствующее уведомление
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
//        Вызов обработчика
        doAfterCardBackSideSelected?(selectedBackSides)
//        Возврат к предыдущему экрану
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Получение значения типа UINib, соответствующее xib-файлу ячейки
        let cellTypeNib = UINib(nibName: "CardSideViewCell", bundle: nil)
//        Регистрация ячейки в табличном представлении
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
//        Загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardSideViewCell", for: indexPath) as! CardSideViewCell
//        Получаем данные о рубашке, которую необходимо вывести в ячейке
        let typeDescription = cardBackSideShapeInformation[indexPath.row]
        
        let cardFrontSideShapeView = cardViewFactory.getBackSideView(
            typeDescription.type,
            withSize: CGSize(width: 60, height: 60),
            andColor: .black
        )
        
//        Добавляем представление рубашки в ячейку
        cell.cardSideShape.addSubview(cardFrontSideShapeView)
//        Изменяем название рубашки
        cell.cardSideShapeName.text = typeDescription.title
        
//        Если рубашка находится в списке выбранных, то отмечаем ее
        if selectedBackSides.contains(typeDescription.type) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Текущая рубашка
        let currentBackSide = cardBackSideShapeInformation[indexPath.row].type
        
//        Если рубашки нет в списке выбранных, то добавляем
        if !selectedBackSides.contains(currentBackSide) {
            selectedBackSides.append(currentBackSide)
            tableView.reloadData()
//            Если он уже был выбран, то удаляем его
        } else {
            guard let currentBackSideIndex = selectedBackSides.firstIndex(of: currentBackSide) else {
                return
            }
            selectedBackSides.remove(at: currentBackSideIndex)
            tableView.reloadData()
        }
        
//        Снимаем выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
