//
//  SetGameVC.swift
//  CSet
//
//  Created by Cole Saunders on 1/4/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import UIKit

class SetGameVC: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardFieldView: CardFieldView!
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var setsFoundLabel: UILabel!
    
    var game = SetGame()
    var currentlySelectedCardsIndices = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardFieldView.delegate = self
        configureToCardFieldView()
        setUpDeckLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateDisplay()
        
        cardFieldView.dealCards()
    }
    
    func updateDisplay() {
        
        if currentlySelectedCardsIndices.count == 3 {
            if game.attemptSet(currentlySelectedCardsIndices) {
                cardFieldView.cardMatchFoundAnimation(indices: currentlySelectedCardsIndices, deckCount: game.deck.count)
                cardFieldView.updateBorderColors(indices: currentlySelectedCardsIndices, color: .darkGray)
                currentlySelectedCardsIndices.removeAll()
            } else {
                cardFieldView.updateBorderColors(indices: currentlySelectedCardsIndices, color: .red)
            }
        } else {
            cardFieldView.updateBorderColors(indices: currentlySelectedCardsIndices, color: .blue)
        }
        
        cardFieldView.updateLayoutOfCards(count: game.cardsInPlay.count, deckCount: game.deck.count)
        
        for cardIndex in game.cardsInPlay.indices {
            let card = game.cardsInPlay[cardIndex]
            cardFieldView.updateCard(at: cardIndex, card: card)
        }
        
        cardFieldView.dealCards()
        
        scoreLabel.text = "Score: \(game.score)"
        deckLabel.text = "\(game.deck.count)"
        setsFoundLabel.text = "Matches: \(game.setsFound.count)"
    }
    
    
    //MARK: - IBActions
    @IBAction func newGamePressed(_ sender: UIButton) {
        game = SetGame()
        currentlySelectedCardsIndices = []
        updateDisplay()
    }
    
    @IBAction func dealThreeCardsPressed(_ sender: UIButton) {
        dealThreeCards()
    }
    
    @IBAction func hintButtonPressed(_ sender: UIButton) {
        if let setIndices = game.findSet() {
            currentlySelectedCardsIndices = setIndices
            updateDisplay()
        }
    }
    
    
    //MARK: - Private Functions
    private func setUpDeckLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dealThreeCards))
        deckLabel.isUserInteractionEnabled = true
        deckLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dealThreeCards() {
        game.dealThreeCards()
        updateDisplay()
    }
    
    private func configureToCardFieldView() {
        let rotationGesture = UIRotationGestureRecognizer(target: cardFieldView, action: #selector(cardFieldView.rotionHandler(sender:)))
        cardFieldView.addGestureRecognizer(rotationGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: cardFieldView, action: #selector(cardFieldView.swipeHandler(sender:)))
        swipeDown.direction = .down
        cardFieldView.addGestureRecognizer(swipeDown)
        
        cardFieldView.cardInitialFrame = view.convert(deckLabel.frame, to: cardFieldView)
        cardFieldView.cardDiscardFrame = view.convert(setsFoundLabel.frame, to: cardFieldView)
    }
}

extension SetGameVC: CardFieldViewDelegate {
    
    func cardTapped(sender: CardView) {
        if let cardViewIndex = cardFieldView.getCardViewIndex(sender) {
            if currentlySelectedCardsIndices.count == 3 {
                currentlySelectedCardsIndices.removeAll()
            }
            if currentlySelectedCardsIndices.contains(cardViewIndex) {
                currentlySelectedCardsIndices = currentlySelectedCardsIndices.filter({
                    cardViewIndex != $0
                })
            } else {
                currentlySelectedCardsIndices.append(cardViewIndex)
            }
            updateDisplay()
        }
    }
    
    func rotationCaptured() {
        game.shuffleCardsInPlay()
        updateDisplay()
    }
    
    func swipeReceived() {
        dealThreeCards()
    }
    
    func layoutNeedsNewDeckLabelFrame() {
        cardFieldView.cardInitialFrame = view.convert(deckLabel.frame, to: cardFieldView)
    }
}
