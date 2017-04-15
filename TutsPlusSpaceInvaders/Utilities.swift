//
//  Utilities.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 3/23/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
