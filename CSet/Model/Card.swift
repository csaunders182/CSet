//
//  Card.swift
//  CSet
//
//  Created by Cole Saunders on 1/4/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import Foundation

struct Card: Hashable {
    let shape: Shapes
    let fillPattern: FillPatterns
    let numberOfShapes: NumbersOfShapes
    let color: ColorsOfShapes
}

extension Card: CustomStringConvertible {
    var description: String {
        return "Card\(hashValue): \(numberOfShapes), \(shape), \(fillPattern), \(color)"
    }
}

