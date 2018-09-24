//
//  SetGame.swift
//  CSet
//
//  Created by Cole Saunders on 1/5/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var score = 0
    private(set) var deck = [Card]()
    private(set) var cardsInPlay = [Card]()
    private(set) var setsFound = [[Card]]()
    private let startingDeal = 12
    
    init() {
        score = 0
        
        Shapes.allCases.forEach { shape in
            FillPatterns.allCases.forEach({ pattern in
                NumbersOfShapes.allCases.forEach({ number in
                    ColorsOfShapes.allCases.forEach({ color in
                        let card = Card(shape: shape, fillPattern: pattern, numberOfShapes: number, color: color)
                        deck.append(card)
                    })
                })
            })
        }
        
        deck.shuffle()
        dealCards(quantity: startingDeal)
    }
    
    mutating func findSet() -> [Int]? {
        if let setOfCards = getFirstSetInPlay(from: cardsInPlay) {
            let cardIndices = getCardIndices(setOfCards)
            return cardIndices
        } else {
            return nil
        }
    }
    
    mutating func dealThreeCards() {
        if deck.count >= 3 {
            dealCards(quantity: 3)
        }
    }
    
    mutating func shuffleCardsInPlay() {
        cardsInPlay.shuffle()
    }
    
    mutating func attemptSet(_ indices: [Int]) -> Bool {
        var cards = [Card]()
        indices.forEach { index in
            if index < cardsInPlay.count {
                cards.append(cardsInPlay[index])
            }
        }
        if checkIfSet(selectedCards: cards) {
            score += 5
            removeMatchedCards(cardList: cards)
            return true
        } else {
            score -= 1
           return false
        }
    }
    
    //To determine is a set is found we create some sets and pool all the cards properties and check counts, if there
    //is two of any quantity in any set then there is no cardset
    private func checkIfSet(selectedCards: [Card]) -> Bool {
        if selectedCards.count == 3 {
            var shapeSet = Set<Shapes>()
            var fillPatternSet = Set<FillPatterns>()
            var numberOfShapesSet = Set<NumbersOfShapes>()
            var colorSet = Set<ColorsOfShapes>()
            
            selectedCards.forEach { card in
                shapeSet.insert(card.shape)
                fillPatternSet.insert(card.fillPattern)
                numberOfShapesSet.insert(card.numberOfShapes)
                colorSet.insert(card.color)
            }
            
            if shapeSet.count == 2 || fillPatternSet.count == 2 || numberOfShapesSet.count == 2 || colorSet.count == 2 {
                return false
            }
            return true
        }
        return false
    }
    
    private mutating func dealCards(quantity: Int, position: Int? = nil) {
        for _ in 1...quantity {
            if !deck.isEmpty {
                if let position = position, position < cardsInPlay.count {
                    cardsInPlay.insert(deck.remove(at: 0), at: position)
                } else {
                   cardsInPlay.append(deck.remove(at: 0))
                }
            }
        }
    }
    
    private mutating  func removeMatchedCards(cardList: [Card]) {
        cardList.forEach { card in
            if let index = cardsInPlay.index(of: card) {
                cardsInPlay.remove(at: index)
                if !deck.isEmpty && cardsInPlay.count < 12 {
                    dealCards(quantity: 1, position: index)
                }
            }
        }
    }
    
    private func getFirstSetInPlay(from: [Card], set: [Card] = []) -> [Card]? {
        if set.count == 3 {
            return checkIfSet(selectedCards: set) ? set: nil
        }
        if from.isEmpty || set.count > 3 {return nil}
        var newSet = set
        var newFrom = from
        for index in from.indices {
            newSet.append(newFrom.remove(at: index))
            let remaining = getFirstSetInPlay(from: newFrom, set: newSet)
            if remaining != nil {
                return checkIfSet(selectedCards: remaining!) ? remaining: nil
            }
            if !newSet.isEmpty {
                newFrom.append(newSet.popLast()!)
            }
        }
        return nil
    }
    
    private func getCardIndices(_ cards:[Card]) -> [Int] {
        var foundIndices = [Int]()
        cards.forEach { card in
            if let index = cardsInPlay.index(of: card) {
                foundIndices.append(index)
            }
        }
        return foundIndices
    }
}
