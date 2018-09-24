//
//  SetGestures.swift
//  CSet
//
//  Created by Cole Saunders on 1/12/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import Foundation

//protocol for handling gestures that take place on the card field
protocol CardFieldViewDelegate: class {
    func cardTapped(sender: CardView)
    func rotationCaptured()
    func swipeReceived()
    func layoutNeedsNewDeckLabelFrame()
}
