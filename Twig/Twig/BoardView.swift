//
//  BoardView.swift
//  Twig
//
//  Created by Jedd Goble on 2/23/17.
//  Copyright © 2017 Bells & Missiles. All rights reserved.
//

import UIKit

protocol BoardViewDelegate {
    func didTapBoard(atPosition position: Position)
}

@IBDesignable
class BoardView: UIView {
    
    var delegate: BoardViewDelegate?
    
    var starPositions: [Position] {
        return [Position(x: 4, y: 4), Position(x: 10, y: 4), Position(x: 16, y: 4), Position(x: 4, y: 10), Position(x: 10, y: 10), Position(x: 16, y: 10), Position(x: 4, y: 16), Position(x: 10, y: 16), Position(x: 15, y: 16)]
    }
    
    var boardSize: Int = 19 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var gameState: GameState? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineColor: UIColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        clearsContextBeforeDrawing = true
    }
    
    var didLayoutSubviewsOnce: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard didLayoutSubviewsOnce == false else {
            return
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBoard(sender:)))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
        
        didLayoutSubviewsOnce = true
    }
    
    func didTapBoard(sender: UITapGestureRecognizer) {
        
        let width = min(bounds.size.width, bounds.size.height)
        
        let tapLocation = sender.location(in: self)
        let xTapPosition = Int((tapLocation.x / width) * CGFloat(boardSize))
        let yTapPosition = Int((tapLocation.y / width) * CGFloat(boardSize))
        
        delegate?.didTapBoard(atPosition: Position(x: xTapPosition, y: yTapPosition))
        
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width = min(rect.size.width, rect.size.height)
        let sidePadding = width * 0.05
        let spaceBetweenLines: CGFloat = (width - sidePadding * 2.0) / CGFloat(boardSize - 1)
        let lines = UIBezierPath()
        
        for row in 0..<boardSize {
            
            let left: CGFloat = sidePadding
            let right: CGFloat = width - sidePadding
            
            let y = CGFloat(row) * spaceBetweenLines + sidePadding
            
            let startPoint = CGPoint(x: left, y: y)
            let endPoint = CGPoint(x: right, y: y)
            
            lines.move(to: startPoint)
            lines.addLine(to: endPoint)
            
        }
        
        for column in 0..<boardSize {
            
            let top: CGFloat = sidePadding
            let bottom: CGFloat = width - sidePadding
            
            let x = CGFloat(column) * spaceBetweenLines + sidePadding
            
            let startPoint = CGPoint(x: x, y: top)
            let endPoint = CGPoint(x: x, y: bottom)
            
            lines.move(to: startPoint)
            lines.addLine(to: endPoint)
            
        }
        
        lines.lineWidth = 1.0
        lineColor.setStroke()
        lines.stroke()
        
        for starPosition in starPositions {
            
            let starSizeFactor: CGFloat = 0.25
            
            var starOrigin = CGPoint()
            starOrigin.x = (CGFloat(starPosition.x) * spaceBetweenLines) - ((spaceBetweenLines * starSizeFactor) / 2.0)
            
            starOrigin.y = (CGFloat(starPosition.y) * spaceBetweenLines) - ((spaceBetweenLines * starSizeFactor) / 2.0)
            
            var starSize = CGSize()
            starSize.width = spaceBetweenLines * starSizeFactor
            starSize.height = spaceBetweenLines * starSizeFactor
            
            let starRect = CGRect(origin: starOrigin, size: starSize)
            
            drawStar(inRect: starRect)
            
        }
        
        guard let gameState = gameState else {
            return
        }
        
        for turn in gameState.board.turns {
            
            guard let stone = turn.stone else {
                continue
            }
            
            var stoneOrigin = CGPoint()
            stoneOrigin.x = (CGFloat(stone.position.x) * spaceBetweenLines) - (spaceBetweenLines / 2.0) + (spaceBetweenLines * 0.1) + sidePadding
            stoneOrigin.y = (CGFloat(stone.position.y) * spaceBetweenLines) - (spaceBetweenLines / 2.0) + (spaceBetweenLines * 0.1) + sidePadding
            
            var stoneSize = CGSize()
            stoneSize.width = spaceBetweenLines - (spaceBetweenLines * 0.2)
            stoneSize.height = spaceBetweenLines - (spaceBetweenLines * 0.2)
            
            let stoneRect = CGRect(origin: stoneOrigin, size: stoneSize)
            
            drawStone(stone, inRect: stoneRect)
        }
    }
    
    func drawStar(inRect rect: CGRect) {
        
        let outline = UIBezierPath(ovalIn: rect)
        lineColor.setFill()
        outline.fill()
        
    }
    
    func drawStone(_ stone: Stone, inRect rect: CGRect) {
        
        let outline = UIBezierPath(ovalIn: rect)
        
        switch stone.color {
        case .black:
            UIColor.whiteStone().setStroke()
            UIColor.blackStone().setFill()
        case .white:
            UIColor.blackStone().setStroke()
            UIColor.whiteStone().setFill()
        }
        
        outline.fill()
        outline.lineWidth = 1.0
        outline.stroke()
        
    }
}

extension BoardView: UIGestureRecognizerDelegate {
    
}
