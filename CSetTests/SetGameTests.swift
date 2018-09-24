//
//  SetTests.swift
//  CSetTests
//
//  Created by Cole Saunders on 1/5/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import XCTest
@testable import CSet

class SetGameTests: XCTestCase {
    
    var set: SetGame!
    
    override func setUp() {
        super.setUp()
        
        set = SetGame()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasDeck() {
        XCTAssertNotNil(set.deck)
    }
    
    func test_hasSelectedCards() {
        XCTAssertNotNil(set.selectedCards)
    }
    
    func test_hasCardsInPlay() {
        XCTAssertNotNil(set.cardsInPlay)
    }
    
    func test_SetGame_InitsWith12CardsDealt() {
        XCTAssertEqual(set.deck.count, 69)
        XCTAssertEqual(set.cardsInPlay.count, 12)
    }
    
    func test_dealThreeCards_MovesThreeCardsFromDeckToCardsInPlay() {
        set.dealThreeCards()
        XCTAssertEqual(set.deck.count, 66)
        XCTAssertEqual(set.cardsInPlay.count, 15)
        
        set.dealThreeCards()
        XCTAssertEqual(set.deck.count, 63)
        XCTAssertEqual(set.cardsInPlay.count, 18)
    }
    
    func test_SelectCard_MovesUpToThreeCards() {
        set.selectCard(forCardsInPlay: 0)
        XCTAssertEqual(set.cardsInPlay[0], set.selectedCards[0])
        
        set.selectCard(forCardsInPlay: 1)
        XCTAssertEqual(set.cardsInPlay[1], set.selectedCards[1])
        
        set.selectCard(forCardsInPlay: 2)
        XCTAssertEqual(set.cardsInPlay[2], set.selectedCards[2])
        
        set.selectCard(forCardsInPlay: 3)
        XCTAssertEqual(set.selectedCards.count, 1)
    }
    
    func test_DeselectCard_OneSelectedCardDeselects() {
        set.selectCard(forCardsInPlay: 0)
        
        XCTAssertEqual(set.cardsInPlay[0], set.selectedCards[0])
        
        set.deselectCard(cardInPlay: 0)
        
        XCTAssertEqual(set.selectedCards.count, 0)
    }
    
    func test_DeselectCard_TwoCardsSelectedDeselects() {
        set.selectCard(forCardsInPlay: 0)
        set.selectCard(forCardsInPlay: 1)
        
        XCTAssertEqual(set.selectedCards.count, 2)
        
        set.deselectCard(cardInPlay: 0)
        
        XCTAssertEqual(set.selectedCards.count, 1)
        XCTAssertEqual(set.cardsInPlay[1], set.selectedCards[0])
    }
    
    func test_DeselectCard_ThreeCardsDoesNotDeselect() {
        set.selectCard(forCardsInPlay: 0)
        set.selectCard(forCardsInPlay: 1)
        set.selectCard(forCardsInPlay: 2)
        
        set.deselectCard(cardInPlay: 1)
        XCTAssertEqual(set.selectedCards.count, 0)
    }
}
