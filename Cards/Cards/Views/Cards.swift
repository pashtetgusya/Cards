//
//  Cards.swift
//  Cards
//
//  Created by Pavel Yarovoi on 02.03.2022.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flippCompletationHandler: ((FlippableView) -> Void)? { get set }
    
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    private var margin: Int = 10
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var startTouchPoint: CGPoint!
    
    lazy var frontSideView: UIView = self.getFrontSideView()
    lazy var backSideView: UIView = self.getBackSideView()
    
    var cornerRadius: Int = 20
    var color: UIColor!
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flippCompletationHandler: ((FlippableView) -> Void)?
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(cooder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
        
        if (!self.superview!.bounds.intersection(self.frame).equalTo(self.frame)) {
            UIView.animate(withDuration: 0.5, animations: {
//                Если карточка выходит за какую-либо из границ, то она перемещается обратно внутрь игрового поля
//                X и Y разделены для того, чтобы при выходе карточки за обе координаты она возвращалась обратно в угол
//                P.S Уверен, что можно сделать как-то более аккуратно
                if self.frame.origin.x > ((self.superview?.bounds.width)! - self.frame.width) {
                    self.frame.origin = CGPoint(x: ((self.superview?.bounds.width)! - self.frame.width), y: self.frame.origin.y)
                } else if self.frame.origin.x < 0 {
                    self.frame.origin = CGPoint(x: 0, y: self.frame.origin.y)
                }
                if self.frame.origin.y > ((self.superview?.bounds.height)! - self.frame.height) {
                    self.frame.origin = CGPoint(x: self.frame.origin.x, y: ((self.superview?.bounds.height)! - self.frame.height))
                } else if self.frame.origin.y < 0 {
                    self.frame.origin = CGPoint(x: self.frame.origin.x, y: 0)
                }
            })
        }

    }
    
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: { _ in
            self.flippCompletationHandler?(self)
        })
        isFlipped.toggle()
    }

    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        let shapeView = UIView(frame: CGRect(
            x: margin,
            y: margin,
            width: Int(self.bounds.width) - margin * 2,
            height: Int(self.bounds.height) - margin * 2)
        )
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)

        view.backgroundColor = .white
        view.addSubview(shapeView)
        
        shapeView.layer.addSublayer(shapeLayer)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
     
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        switch ["circle", "line"].randomElement() {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
}
