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
        object = .RollingPin
        var mainScene : CCScene =  CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
        
    }
    func hard() {
        object = .Pan
        var mainScene : CCScene =  CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
    func hell() {
        object = .Plate
        var mainScene : CCScene =  CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
}
