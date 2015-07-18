//
//  ShitScreen.swift
//  Untitled
//
//  Created by Gagandeep Sawhney on 7/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ShitScreen: CCNode {
    weak var lable: CCLabelTTF!
    var cuses = ["#@!%","@#!%","##@!","@*&%","&@%$"]
    func didLoadFromCCB() {
        var random = arc4random_uniform(UInt32(cuses.count - 1))
        lable.string = "\(cuses[Int(random)])"
    }
}
