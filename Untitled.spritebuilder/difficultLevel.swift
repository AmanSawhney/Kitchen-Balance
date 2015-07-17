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
        
        var mainScene : CCScene =  CCBReader.loadAsScene("Easy")
        CCDirector.sharedDirector().replaceScene(mainScene)
        
    }
    func hard() {
        
        var mainScene : CCScene =  CCBReader.loadAsScene("Hard")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
    func hell() {
        
        var mainScene : CCScene =  CCBReader.loadAsScene("Hell")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
}
