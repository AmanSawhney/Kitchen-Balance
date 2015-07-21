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
    weak var object4: CCSprite!
    weak var object5: CCSprite!
    var moveright = false
    var objects: [CCSprite] = []
    weak var hand1: CCButton!
    weak var hand2: CCButton!
    var audio = OALSimpleAudio.sharedInstance()
    func didLoadFromCCB() {
        
        
        GameCenterHelper.sharedInstance.authenticationCheck()
        
        iAdHelper.sharedHelper()
        iAdHelper.setBannerPosition(TOP)
        
        objects.append(object1)
        objects.append(object2)
        objects.append(object3)
        objects.append(object4)
        objects.append(object5)
        whichObject = .RollingPin
        userInteractionEnabled = true
    }
    func right() {
        audio.playEffect("8bits/coin2.wav")
        if whichObject != .Gun {
            for object in objects {
                var move = CCActionMoveTo(duration: 0.2, position: ccp(object.position.x - 1, object.position.y))
                object.runAction(move)
            }
        }
    }
    func left() {
        audio.playEffect("8bits/coin2.wav")
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
    
    func play() {
        audio.playEffect("8bits/coin2.wav")
        animationManager.runAnimationsForSequenceNamed("ButtonPress Timeline")
        delay(1.5) {
            var playScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(playScene)
        }
    }
    func stats() {
        audio.playEffect("8bits/coin2.wav")
        animationManager.runAnimationsForSequenceNamed("Stats Timeline")
    }
    func leaderBoard() {
        audio.playEffect("8bits/coin2.wav")
        //        animationManager.runAnimationsForSequenceNamed("LeaderBoard Timeline")
        showLeaderboard()
    }
    func facebook() {
        audio.playEffect("8bits/coin2.wav")
        SharingHandler.sharedInstance.postToFacebook(postWithScreenshot: true)
    }
    func twitter() {
        audio.playEffect("8bits/coin2.wav")
        SharingHandler.sharedInstance.postToTwitter(stringToPost: "", postWithScreenshot: false)
    }
    func info() {
        audio.playEffect("8bits/coin2.wav")
        
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
                
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                whichObject = .Pan
                
            }else if object4.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                whichObject = .Sward
            }else if object5.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                if hand2.animationManager.runningSequenceName != "GoAway Timeline" && hand2.animationManager.runningSequenceName != "Done Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("GoAway Timeline")
                }
                whichObject = .Gun
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