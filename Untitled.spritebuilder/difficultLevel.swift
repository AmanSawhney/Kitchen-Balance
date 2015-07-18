//
//  difficultLevel.swift
//  Untitled
//
//  Created by Gagandeep Sawhney on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class DifficultLevel: CCScene {
    func didLoadFromCCB() {
    }
    func easy() {
        whichObject = .RollingPin
        var mainScene : CCScene =  CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
        
    }
    func hard() {
        whichObject = .Pan
        var mainScene : CCScene =  CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
    func hell() {
        whichObject = .Plate
        var mainScene : CCScene =  CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
}
