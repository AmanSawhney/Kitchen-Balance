//
//  ScoreNode.swift
//  Untitled
//
//  Created by Aman Sawhney on 12/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ScoreNode: CCNode {
    
    enum displayState: Double{
        case Streak = 20.0, Perfect = 5.0, Good = 3.0, Fair = 1.0, Poor = 0.75
    }
    
    weak var scoreLabel: CCLabelTTF!
    weak var rotationLabel: CCLabelTTF!
    var delegate: StreakDelegate?
    var soundSrc: ALSoundSource?
    var booSoundSrc: ALSoundSource?
    var awesome: ALSoundSource?
    var state : displayState = .Perfect {
        didSet{
            if (soundSrc != nil)
            {
                soundSrc!.stop()
            }
            switch state{
            case .Streak:
                delegate?.startStreak()
                color = CCColor(ccColor3b: ccColor3B(r: 104, g: 0, b: 186))
                soundSrc = OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", volume: 0.1, pitch: 1.0, pan: 0, loop: true)
                rotationLabel.string = "Streak x20"
                break
            case .Perfect:
                delegate?.stopStreak()
                color = CCColor(ccColor3b: ccColor3B(r: 49, g: 203, b: 0))
                soundSrc = OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", volume: 0.1, pitch: 1.0, pan: 0, loop: true)
                rotationLabel.string = "Perfect x5"
                break
            case .Good:
                delegate?.stopStreak()
                color = CCColor(ccColor3b: ccColor3B(r: 1, g: 23, b: 104))
                soundSrc = OALSimpleAudio.sharedInstance().playEffect("8bits/goodSound.mp3", volume: 0.1, pitch: 1.0, pan: 0, loop: true)
                rotationLabel.string = "Good x3"
                break
            case .Fair:
                delegate?.stopStreak()
                color = CCColor(ccColor3b: ccColor3B(r: 0, g: 166, b: 237))
                soundSrc = OALSimpleAudio.sharedInstance().playEffect("8bits/Retro Game FX 3.mp3", volume: 0.05, pitch: 1.0, pan: 0, loop: true)
                rotationLabel.string = "Ok x1"
                break
            case .Poor:
                delegate?.stopStreak()
                color = CCColor(ccColor3b: ccColor3B(r: 246, g: 81, b: 29))
                soundSrc = OALSimpleAudio.sharedInstance().playEffect("8bits/Retro Game FX 3.mp3", volume: 0.05, pitch: 1.0, pan: 0, loop: true)
                rotationLabel.string = "Uh-oh! x0.75"
                break
            }
        }
    }
    
    
    var streakCounter = 0 {
        didSet{
            if streakCounter >= 50 && state != .Streak{
                state = .Streak
                delegate?.showCompliment()
            }
        }
    }
    
    func didLoadFromCCB(){
        cascadeColorEnabled = true
        state = .Perfect
    }
    
    func displayRotation(rotation: Float){
        if abs(rotation) < 4.5{
            streakCounter++
            if state == .Streak{
                
            } else if abs(rotation) < 1.5 {
                if state != .Perfect{
                    state = .Perfect
                }
            } else {
                if state != .Good{
                    state = .Good
                }
            }
            //handle streak, good, and perfect
        } else if abs(rotation) >= 4.5 && abs(rotation) < 8{
            if state != .Fair{
                state = .Fair
            }
            streakCounter = 0
        } else if abs(rotation) >= 9 {
            if state != .Poor{
                state = .Poor
            }
            streakCounter = 0
        }
        
    }
    
    func updateScore(score: Double){
        scoreLabel.string = "\(Int(score))"
        let defaults = NSUserDefaults.standardUserDefaults()
        if score > defaults.doubleForKey("highscore") {
            defaults.setDouble(score, forKey: "highscore")
        }
    }
    
}

protocol StreakDelegate{
    func startStreak()
    func stopStreak()
    func showCompliment()
}
