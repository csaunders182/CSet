//
//  CardTests.swift
//  CSetTests
//
//  Created by Cole Saunders on 1/5/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import XCTest
@testable import CSet

class CardTests: XCTestCase {
    
    var card: Card!
    
    override func setUp() {
        super.setUp()
        
        card =  Card(shape: .diamond, fillpattern: .striped, numberOfShapes: .one, colorOfShapes: . blue)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasShape() {
        XCTAssertNotNil(card.shape)
    }
    
    func test_HasfillPattern() {
        XCTAssertNotNil(card.fillPattern)
    }
    
    func test_HasNumberOfShapes() {
        XCTAssertNotNil(card.numberOfShapes)
    }
    
    func test_HasColor() {
        XCTAssertNotNil(card.color)
    }
    
    func test_isEquatable() {
        let newSameCard = card
        
        XCTAssertEqual(card, newSameCard)
        
        let differentCard = Card(shape: .squiggle, fillpattern: .solid, numberOfShapes: .two, colorOfShapes: .green)
        
        XCTAssertNotEqual(card, differentCard)
    }
    
    
}
