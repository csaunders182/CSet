//  These Enums are used to provide a disscrete list of set cards
//  Card Enums.swift
//  CSet
//
//  Created by Cole Saunders on 1/4/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import UIKit

enum Shapes: String, CaseIterable {
    case squiggle, diamond, oval
}

enum FillPatterns: CaseIterable {
    case striped, outline, solid
}

enum NumbersOfShapes: Int, CaseIterable {
    case one = 1, two, three
}

enum ColorsOfShapes: CaseIterable {
    case blue, green, red
    
    var color: UIColor {
        switch self {
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        case .red :
            return UIColor.red
        }
    }
}
