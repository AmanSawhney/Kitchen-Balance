//
//  StartScene.swift
//  Untitled
//
//  Created by Gagandeep Sawhney on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import UIKit
import GameKit

class StartScene: CCScene {
    var swipable = false
    weak var object1: CCSprite!
    weak var object2: CCSprite!
    weak var object3: CCSprite!
    var moveright = false
    var objects: [CCSprite] = []
    weak var hand1: CCButton!
    weak var hand2: CCButton!
    func didLoadFromCCB() {
        
    
        GameCenterHelper.sharedInstance.authenticationCheck()
        
        iAdHelper.sharedHelper()
        iAdHelper.setBannerPosition(TOP)
        
        objects.append(object1)
        objects.append(object2)
        objects.append(object3)
        whichObject = .RollingPin
        userInteractionEnabled = true
    }
    func right() {
        if whichObject != .Pan {
            for object in objects {
                var move = CCActionMoveTo(duration: 0.2, position: ccp(object.position.x - 1, object.position.y))
                object.runAction(move)
            }
        }
    }
    func left() {
        if whichObject != .RollingPin {
            for object in objects {
                var move = CCActionMoveTo(duration: 0.2, position: ccp(object.position.x + 1, object.position.y))
                object.runAction(move)
            }
        }
    }
    func moveObjects(orginalPostion: CGPoint) {
        while object1.position.x < -orginalPostion.x {
            for object in objects {
                object.position.x--
            }
        }
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    func switchLeft() {
        
    }
    
    func play() {
        animationManager.runAnimationsForSequenceNamed("ButtonPress Timeline")
        delay(1.5) {
            var playScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(playScene)
        }
    }
    func stats() {
        animationManager.runAnimationsForSequenceNamed("Stats Timeline")
    }
    func leaderBoard() {
        //        animationManager.runAnimationsForSequenceNamed("LeaderBoard Timeline")
        showLeaderboard()
    }
    func facebook() {
        SharingHandler.sharedInstance.postToFacebook(postWithScreenshot: false)
    }
    func twitter() {
        
    }
    func info() {
        
    }
    override func update(delta: CCTime) {
        
        for object in objects {
            
            if object1.position.x == 0.5{
                whichObject = .RollingPin
                if hand1.animationManager.runningSequenceName != "GoAway Timeline" && hand1.animationManager.runningSequenceName != "Done Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("GoAway Timeline")
                }
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }

            } else if object2.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }

                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                whichObject = .Plate
            } else if object3.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                if hand2.animationManager.runningSequenceName != "GoAway Timeline" && hand2.animationManager.runningSequenceName != "Done Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("GoAway Timeline")
                }
                whichObject = .Pan
                
            }
        }
        
    }
}

// MARK: Game Center Handling

extension StartScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
        
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}