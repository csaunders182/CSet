//
//  SetCardFieldView.swift
//  CSet
//
//  Created by Cole Saunders on 1/11/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import UIKit

class CardFieldView: UIView {

    var theGrid: Grid!
    var cardsOnField = [CardView]()
    var cardInitialFrame: CGRect!
    var cardDiscardFrame: CGRect!
    
    struct animationConstants {
        static let moveFrameDuration = 0.5
        static let dealCardDuration = 0.5
        static let flipCardDuration = 0.4
    }
    
    weak var delegate: CardFieldViewDelegate?
    
    lazy var animator = UIDynamicAnimator(referenceView: self)
    lazy var cardBehavior = CardViewDynamicBehavior(in: animator)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayoutOfCards(count: cardsOnField.count)
        delegate?.layoutNeedsNewDeckLabelFrame()
    }
    
    @objc func swipeHandler(sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            if sender.direction == .down {
              delegate?.swipeReceived()
            }
        default:
            break
        }
    }
    
    @objc func rotionHandler(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            delegate?.rotationCaptured()
        default:
            break
        }
    }
    
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            delegate?.cardTapped(sender: sender.view as! CardView)
        default:
            break
        }
    }
    
    func getCardViewIndex(_ cardView: CardView) -> Int? {
        if let index = cardsOnField.index(of: cardView) {
            return index
        }
        return nil
    }
    
    func updateBorderColors(indices: [Int], color: UIColor) {
        for index in cardsOnField.indices {
            if indices.contains(index) {
                cardsOnField[index].borderColor = color
            } else {
                cardsOnField[index].borderColor = .darkGray
            }
        }
    }
    
    func updateLayoutOfCards(count: Int, deckCount: Int = 1) {
        theGrid = Grid(layout: .aspectRatio(0.625), frame: bounds)
        theGrid.cellCount = count
        
        if count < cardsOnField.count {
            removeExtraCardViews(count: count)
            
        } else if count > cardsOnField.count {
            createCardView(count: count)
            
        }
        
        for index in cardsOnField.indices {
            let cardView = cardsOnField[index]
            let newFrame = theGrid[index]!
            if cardView.frame != newFrame {
                moveFrame(cardView: cardView, newFrame: newFrame)
            }
        }
    }
    
    //looks for cardViews that have 0.0 alpha and animate a card
    //from the deck the cardField
    func dealCards() {
        var undealt = cardsOnField.filter({ $0.alpha == 0.0
        })
        
        //added to make sure there are three dealt cards if
        //layout rearrangement removes one - aesthetic thing
        if undealt.count < 3 && undealt.count > 0 {
            let cardViews = cardsOnField
            for cardView in cardViews.reversed() {
                if cardView.alpha != 0.0 {
                    cardView.alpha = 0.0
                    undealt.append(cardView)
                    if undealt.count == 3 {
                        break
                    }
                }
            }
        }
        
        for index in undealt.indices {
            let cardView = undealt[index]
            if let cardIndex = cardsOnField.index(of: cardView) {
                let frame = theGrid[cardIndex]!
                dealCardAnimation(cardView: cardView, newFrame: frame, delay: Double(index))
            }
        }
    }
    
    func updateCard(at index: Int, card: Card) {
        assert(index <= cardsOnField.count, "Update Card Out of Range")
        let cardView = cardsOnField[index]
        cardView.shape = card.shape
        cardView.fillPattern = card.fillPattern
        cardView.shapeQuantity = card.numberOfShapes
        cardView.shapeColor = card.color.color
        cardView.setNeedsDisplay()
    }
    
 
    private func addACardToTheField() -> CardView {
        let card = CardView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        return card
    }
    
    func dealCardAnimation(cardView: CardView, newFrame: CGRect, delay: Double) {
        cardView.alpha = 1.0
        cardView.showingCardBack = true
        cardView.frame = cardInitialFrame
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationConstants.moveFrameDuration, delay: (animationConstants.moveFrameDuration + delay)/4, options: [.curveEaseInOut], animations: {
            cardView.frame = newFrame
        }, completion: { (finished) in
            UIView.transition(with: cardView, duration: animationConstants.flipCardDuration, options: [.transitionFlipFromLeft], animations: {
                cardView.showingCardBack = false
            })
        })
    }
    
    func cardMatchFoundAnimation(indices: [Int], deckCount: Int) {
        explodeMatchedCard(Indices: indices)
        if deckCount > 0 {
            indices.forEach { index in
                cardsOnField[index].alpha = 0.0
            }
        } else {
            var cardViews = [CardView]()
            indices.forEach({ (index) in
                let view = cardsOnField[index]
                cardViews.append(view)
            })
            cardViews.forEach({ (cardView) in
                let index = cardsOnField.index(of: cardView)!
                cardView.removeFromSuperview()
                cardsOnField.remove(at: index)
            })
        }
    }
    
    private func explodeMatchedCard(Indices: [Int]) {
        var tempCardViews = [CardView]()
        Indices.forEach { (index) in
            let cardView = cardsOnField[index].makeCopy()
            tempCardViews.append(cardView)
            cardView.isOpaque = false
            addSubview(cardView)
            cardBehavior.addItem(cardView)
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            tempCardViews.forEach({ (cardView) in
                self.cardBehavior.removeItem(cardView)
            })
            self.collectCardToDiscardPile(cardViews: tempCardViews)
        }
    }
    
    private func collectCardToDiscardPile(cardViews: [CardView]) {
        cardViews.forEach { (cardView) in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                cardView.transform = .identity
                cardView.frame = self.cardDiscardFrame
            }, completion: { (finished) in
                cardView.removeFromSuperview()
            })
        }
    }
    
    private func createCardView(count: Int) {
        for _ in cardsOnField.count..<count {
            let cardView = addACardToTheField()
            let cardTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cardTapped(sender:)))
            cardView.addGestureRecognizer(cardTappedRecognizer)
            cardView.isUserInteractionEnabled = true
            cardView.frame = cardInitialFrame
            cardView.isOpaque = false
            cardsOnField.append(cardView)
            cardView.alpha = 0.0
            addSubview(cardView)
        }
    }
    
    private func removeExtraCardViews(count: Int) {
        for index in (count..<cardsOnField.count).reversed() {
            let cardView = cardsOnField[index]
            if let frame = theGrid[index] {
                cardView.frame = frame
            }
            cardView.removeFromSuperview()
            cardsOnField.remove(at: index)
        }
    }
    
    private func moveFrame(cardView: CardView, newFrame: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationConstants.moveFrameDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cardView.frame = newFrame
        })
    }
}
