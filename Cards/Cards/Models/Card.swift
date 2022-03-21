//
//  Card.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import Foundation

//Типы фигуры карт
enum CardType: String, CaseIterable {
    case filledCircle
    case unfilledCircle
    case cross
    case square
    case fill
}

//Типы рубашек карт
enum CardBackSideType: String, CaseIterable {
    case line
    case circle
}

//Типы цветов карт
enum CardColor: String, CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

//Игральная карточка
typealias Card = (type: CardType, backSideType: CardBackSideType, color: CardColor)
