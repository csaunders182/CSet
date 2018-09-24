//
//  CGPointExtensions.swift
//  CSet
//
//  Created by Cole Saunders on 9/23/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
    
    func halfWayPoint(to: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x + to.x)/2, y: (self.y + to.y)/2)
    }
}
