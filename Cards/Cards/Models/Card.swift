//
//  Card.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import Foundation

enum CardType: String, CaseIterable {
    case filledCircle
    case unfilledCircle
    case cross
    case square
    case fill
}

enum CardBackSideType: String, CaseIterable {
    case line
    case circle
}

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

typealias Card = (type: CardType, color: CardColor)
