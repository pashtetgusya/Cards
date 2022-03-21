//
//  CardViewFactory.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import UIKit

class CardViewFactory {
    func get (_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
//        На основе размеров определяем фрейм
        let frame = CGRect(origin: .zero, size: size)
//        Определяем UI-цвет на основе цвета модели
        let viewColor = getViewColorBy(modelColor: color)
        
//        Генерируем и возвращаем карточку
        switch shape {
        case .filledCircle:
            return CardView<FilledCircleShape>(frame: frame, color: viewColor)
        case .unfilledCircle:
            return CardView<UnfilledCircleShape>(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor)
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor)
        }
    }
    
    func getFrontSideView (_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        let viewColor = getViewColorBy(modelColor: color)
        
//        Генерируем и возвращаем лицевую сторону карточки
        switch shape {
        case .filledCircle:
            return CardView<FilledCircleShape>(frame: frame, color: viewColor).frontSideView
        case .unfilledCircle:
            return CardView<UnfilledCircleShape>(frame: frame, color: viewColor).frontSideView
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor).frontSideView
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor).frontSideView
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor).frontSideView
        }
    }
    
    func getBackSideView (_ shape: CardBackSideType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        let viewColor = getViewColorBy(modelColor: color)
        
//        Генерируем и возвращаем рубашку карточки 
        switch shape {
        case .line:
            return CardView<BackSideLine>(frame: frame, color: viewColor).frontSideView
        case .circle:
            return CardView<BackSideCircle>(frame: frame, color: viewColor).frontSideView
        }
    }
    
//    Преобразуем цвет модели в цвет представления
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .red:
            return .red
        case .green:
            return .green
        case .black:
            return .black
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}
