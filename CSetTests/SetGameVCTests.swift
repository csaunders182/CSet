//
//  SetGameVCTests.swift
//  CSetTests
//
//  Created by Cole Saunders on 1/6/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import XCTest
@testable import CSet

class SetGameVCTests: XCTestCase {
    
    var sut: SetGameVC!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "SetGameVC") as! SetGameVC
        sut.loadViewIfNeeded()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasSetGame() {
        XCTAssertNotNil(sut.game)
    }
    
}
