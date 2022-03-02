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
