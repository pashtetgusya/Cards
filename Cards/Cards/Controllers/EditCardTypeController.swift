//
//  CardTypeController.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class EditCardTypeController: UITableViewController {
    
//    Кортеж, описывающий тип фигуры карточки
    typealias TypeCardFrontSideShapeInformation = (type: CardType, title: String)
    
//    Фабрика карточек
    lazy var cardViewFactory = CardViewFactory()
    
//    Название типов фигур карточек
    var cardFrontSideShapeInformation: [TypeCardFrontSideShapeInformation] = [
        (type: .filledCircle, title: "Закрашенный круг"),
        (type: .unfilledCircle, title: "Не закрашенный круг"),
        (type: .cross, title: "Крест"),
        (type: .square, title: "Квадрат"),
        (type: .fill, title: "Закрашенный прямоугольник")
    ]
    
//    Обработка выбора фигур карточек
    var doAfterCardTypeSelected: (([CardType]) -> Void)?
//    Выбранные фигуры карточек
    var selectedCardTypes: [CardType] = []

    @objc func goBack(_ sender: UIBarButtonItem) {
//        Проверка на количество выбранных фигур
        guard selectedCardTypes.count > 0 else {
//            Если пользователь не выбрал ни один тип фигуры, то появляется соответствующее уведомление
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
//        Вызов обработчика
        doAfterCardTypeSelected?(selectedCardTypes)
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
        return cardFrontSideShapeInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardSideViewCell", for: indexPath) as! CardSideViewCell
//        Получаем данные о фигуре, которую необходимо вывести в ячейке
        let typeDescription = cardFrontSideShapeInformation[indexPath.row]
        
        let cardFrontSideShapeView = cardViewFactory.getFrontSideView(
            typeDescription.type,
            withSize: CGSize(width: 60, height: 60),
            andColor: .black
        )
        
//        Добавляем представление фигуры в ячейку
        cell.cardSideShape.addSubview(cardFrontSideShapeView)
//        Изменяем название фигуры
        cell.cardSideShapeName.text = typeDescription.title
        
//        Если фигура находится в списке выбранных, то отмечаем ее
        if selectedCardTypes.contains(typeDescription.type) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Текущий тип фигуры
        let currentFrontSide = cardFrontSideShapeInformation[indexPath.row].type
        
//        Если типа фигуры нет в списке выбранных, то добавляем
        if !selectedCardTypes.contains(currentFrontSide) {
            selectedCardTypes.append(currentFrontSide)
            tableView.reloadData()
//            Если он уже был выбран, то удаляем его
        } else {
            guard let currentFrontSideIndex = selectedCardTypes.firstIndex(of: currentFrontSide) else {
                return
            }
            selectedCardTypes.remove(at: currentFrontSideIndex)
            tableView.reloadData()
        }
        
//        Снимаем выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
