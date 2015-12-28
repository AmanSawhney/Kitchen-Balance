//
//  MainScene.swift
//  Untitled
//
//  Created by Aman Sawhney on 12/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit
import StoreKit

var streakMultiplierSorce = 1

class MainScene: CCNode, CCPhysicsCollisionDelegate  {
    weak var compliment: CCLabelTTF!
    let screenSize = UIScreen.mainScreen().bounds
    let view: UIViewController = CCDirector.sharedDirector().parentViewController! // Returns a UIView of the cocos2d view controller.
    weak var fakeHand: CCSprite!
    weak var currentScore: CCLabelTTF!
    weak var highScore: CCLabelTTF!
    weak var scoreNode: ScoreNode!
    weak var coinNode: CoinLabelNode!
    weak var hand: CCNode!
    weak var object: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var scoreLabel: CCLabelTTF!
    weak var levelLabel: LevelLabelNode!
    var currentTouchLocation: CGPoint!
    var pivot: CCPhysicsJoint!
    var score: Double = 0
    var audio = OALSimpleAudio.sharedInstance()
    let scorePerUpdate = 1.0
    
    var level = 1
    var scorePerLevel = 5000
    
    weak var streak1: CCParticleSystem!
    weak var streak2: CCParticleSystem!
    
    var done = false
    
    
    override func onExit() {
        super.onExit()
        
    }
    
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    func didLoadFromCCB() {
        if !touched {
            gamePhysicsNode.gravity = CGPoint(x: 0,y: 0)
            if soundSrc != nil {
                soundSrc!.stop()
            }
            scoreNode.updateScore(0)
            scoreNode.displayRotation(100.1)
        }
        Chartboost.cacheInterstitial(CBLocationGameOver)
        stopStreak()
        
        scoreNode.delegate = self
        
        //hand.visible = true
        //gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        schedule("spawnCoin", interval: 8, `repeat`: UInt(100000), delay: 2)
    }
    
    func reset() {
        compliment.string = ""
        
        if tried {
            let playScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(playScene)
        }else {
            touched = true
        }
    }
    override func onEnter() {
        
        Chartboost.cacheRewardedVideo(CBLocationGameOver)
        super.onEnter()
        animationManager.runAnimationsForSequenceNamed("Untitled Timeline")
        object = CCBReader.load("Objects/\(objectString())") as! CCSprite
        if objectString() == "Sword" {
            object.scale = 0.5
        }
        
        hand = CCBReader.load("Objects/Hand")
        hand.scale = 0.6
        hand.position = ccp(screenWidth/2, 0)
        object.position = ccp(screenWidth/2, hand.contentSizeInPoints.height * CGFloat(hand.scale) * (CGFloat(1) - hand.anchorPoint.y))
        if objectString() == "Gun" {
            object.scale = 0.50
            object.position.y += CGFloat(5)
        }
        hand.zOrder = 2
        object.zOrder = 1
        
        gamePhysicsNode.addChild(hand)
        gamePhysicsNode.addChild(object)
        
        pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(object.contentSize.width/2 * CGFloat(object.scaleX), 0))
        pivot.collideBodies = false
        
        let randomRotation = Double(arc4random_uniform(2)) + 1.0
        object.rotation = Float(arc4random_uniform(2) == 1 ? randomRotation : -randomRotation)
        
    }
    
    
    func retry() {
        audio.playEffect("8bits/coin2.wav")
        animationManager.runAnimationsForSequenceNamed("ButtonPress Timeline")
        
        
        let playScene = CCBReader.loadAsScene("MainScene")
        
        let delay = CCActionDelay(duration: 1.5)
        let presentScene = CCActionCallBlock(block: {CCDirector.sharedDirector().replaceScene(playScene)})
        runAction(CCActionSequence(array: [delay, presentScene]))
        
    }
    func menu() {
        let menu = CCBReader.loadAsScene("Start")
        CCDirector.sharedDirector().replaceScene(menu)
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
    func share() {
        let screenshot = self.takePresentScreenshot()
        
        let objectsToShare = [screenshot]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        if UIDevice.currentDevice().model != "iPad"{
            view.presentViewController(activityVC, animated: true, completion: nil)
        } else {
            
            let popup = UIPopoverController(contentViewController: activityVC)
            popup.presentPopoverFromRect(CGRectMake(screenSize.width/2, screenSize.height/4, 0, 0), inView: CCDirector.sharedDirector().view, permittedArrowDirections: UIPopoverArrowDirection.Unknown, animated: true)
            
        }
        
    }
    func takePresentScreenshot() -> UIImage {
        CCDirector.sharedDirector().nextDeltaTimeZero = true
        
        let size: CGSize = CCDirector.sharedDirector().viewSize()
        let renderTxture: CCRenderTexture = CCRenderTexture(width: Int32(size.width), height: Int32(size.height))
        renderTxture.begin()
        CCDirector.sharedDirector().runningScene.visit()
        renderTxture.end()
        
        return renderTxture.getUIImage()
    }
    func info() {
        audio.playEffect("8bits/coin2.wav")
        
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, object: CCNode!, coin: Coin!) -> Bool {
        if !coin.collected{
            let coins = NSUserDefaults.standardUserDefaults().integerForKey("Coins") + Int(1 * abs(scoreNode.state.rawValue))
            NSUserDefaults.standardUserDefaults().setInteger(coins, forKey: "Coins")
            coinNode.updateLabel(coins)
            coin.collect()
        }
        return false
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touched = true
        tried = false
        currentTouchLocation = touch.locationInWorld()
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if !done{
            hand.position.x = CGFloat(clampf(Float(hand.position.x - (currentTouchLocation.x - touch.locationInWorld().x)), Float(0.0), Float(screenWidth)))
            currentTouchLocation = touch.locationInWorld()
        }
        
    }
    
    
    
    override func update(delta: CCTime) {
        if tried{
            score = tryAgainScore
            scoreNode.updateScore(score)
        }else {
            tryAgainScore = 0
        }
        fakeHand.position.y = 0
        hand.position.y = 0 //DO NOT DELETE THIS LINE. It makes hand a kinematic body and keeps pivot joint in line
        if touched {
            if !done{
                score += scoreNode.state.rawValue * scorePerUpdate
                scoreNode.displayRotation(object.rotation)
                scoreNode.updateScore(score)
                if score % 2 == 1 {
                    if arc4random_uniform(10) + 1 > 5 {
                        object.physicsBody.applyImpulse(ccp(CGFloat(level * 5 * -1),0))
                    }else {
                        object.physicsBody.applyImpulse(ccp(CGFloat(level * 5 * 1),0))
                    }
                }
            }
            
            if abs(object.rotation) > 80 && !done{
                gameOver()
            }
            
            if Int(score) > level * scorePerLevel{
                levelUp()
            }
        }
        if !touched {
            gamePhysicsNode.gravity = CGPoint(x: 0,y: 0)
            if (soundSrc != nil)
            {
                soundSrc!.stop()
            }
            if score < 1{
                scoreNode.updateScore(0)
            }
        }else {
            gamePhysicsNode.gravity = CGPoint(x: 0,y: -800)
        }
        
    }
    func tryAgain() {
        tryAgainScore = score
        tried = true
        Chartboost.showRewardedVideo(CBLocationGameOver)
        if tryAgainScore != 0.0 && score != 0{
            let playScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(playScene)
        }
    }
    
    func no() {
        actualGameOver()
    }
    
    func levelUp() {
        audio.playEffect("8bits/levelUp", volume: 1.0, pitch: 1.0, pan: 0, loop: false)
        if arc4random_uniform(10) + 1 > 5 {
            object.physicsBody.applyImpulse(ccp(CGFloat(200 * -1),0))
        }else {
            object.physicsBody.applyImpulse(ccp(CGFloat(200 * 1),0))
        }
        level++
        gamePhysicsNode.gravity.y -= CGFloat(Double(gamePhysicsNode.gravity.y) * pow(2.0, Double(level)))
        levelLabel.level = level
        levelLabel.animationManager.runAnimationsForSequenceNamed("LevelUp")
    }
    func actualGameOver() {
        touched = false
        if !NSUserDefaults.standardUserDefaults().boolForKey("ads") && CCRANDOM_0_1() <= 0.3 {
            Chartboost.showInterstitial(CBLocationGameOver)
        }
        compliment.string = ""
        audio.stopAllEffects()
        audio.playEffect("8bits/Death.wav", volume: 0.1, pitch: 1.0, pan: 0, loop: false)
        done = true
        unschedule("levelUp")
        unschedule("compliement")
        unschedule("spawnCoin")
        
        AudioServicesPlaySystemSound(1352)
        let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 12)))
        let moveBack = CCActionEaseBounceOut(action: move.reverse())
        let shakeSequence = CCActionSequence(array: [move, moveBack])
        runAction(shakeSequence)
        self.animationManager.runAnimationsForSequenceNamed("GameOver Timeline")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let highScoreNumber = Int(defaults.doubleForKey("highscore"))
        highScore.string = "\(highScoreNumber)"
        currentScore.string = "\(Int(score))"
        hand.visible = false
        
        pivot.invalidate()
        GameCenterHelper.sharedInstance.saveHighScore(score)
    }
    
    func gameOver() -> Double{
        if CCRANDOM_0_1() < 0.3 && Chartboost.hasRewardedVideo(CBLocationGameOver) {
            gamePhysicsNode.gravity = ccp(0,0)
            object.physicsBody.velocity = ccp(0,0)
            object.physicsBody.allowsRotation = false
            object.physicsBody.angularVelocity = 0
            object.physicsBody.force = ccp(0,0)
            object.physicsBody.torque = 0
            touched = false
            animationManager.runAnimationsForSequenceNamed("TryAgain Timeline")
            return 0.0
        }
        touched = false
        if !NSUserDefaults.standardUserDefaults().boolForKey("ads") && CCRANDOM_0_1() <= 0.3 {
            Chartboost.showInterstitial(CBLocationGameOver)
        }
        compliment.string = ""
        audio.stopAllEffects()
        audio.playEffect("8bits/Death.wav", volume: 0.1, pitch: 1.0, pan: 0, loop: false)
        done = true
        unschedule("levelUp")
        unschedule("compliement")
        unschedule("spawnCoin")
        
        AudioServicesPlaySystemSound(1352)
        let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 12)))
        let moveBack = CCActionEaseBounceOut(action: move.reverse())
        let shakeSequence = CCActionSequence(array: [move, moveBack])
        runAction(shakeSequence)
        self.animationManager.runAnimationsForSequenceNamed("GameOver Timeline")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let highScoreNumber = Int(defaults.doubleForKey("highscore"))
        highScore.string = "\(highScoreNumber)"
        currentScore.string = "\(Int(score))"
        hand.visible = false
        
        pivot.invalidate()
        GameCenterHelper.sharedInstance.saveHighScore(score)
        return 0.0
    }
    
    func spawnCoin(){
        if touched {
            let coin = CCBReader.load("Coin")
            let coinPositionXOffset = CGFloat(arc4random_uniform(UInt32(screenWidth / 4)) + UInt32(screenWidth/5))
            let coinPositionX = CGFloat(arc4random_uniform(UInt32(screenWidth/2 + coinPositionXOffset)) + UInt32(screenWidth/2 - coinPositionXOffset))
            let coinPositionY = CGFloat(arc4random_uniform(UInt32(screenHeight * 0.55)) + UInt32(screenHeight * 0.18))
            
            coin.position = ccp(coinPositionX, coinPositionY)
            gamePhysicsNode.addChild(coin)
        }
    }
    
    func restart(){
        let playScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(playScene)
    }
    
    func home(){
        let playScene = CCBReader.loadAsScene("Start")
        CCDirector.sharedDirector().replaceScene(playScene)
    }
    func makeCompliment() {
        let complimentArray = ["almost as good as Aman","amazing","balancing machine", "ur the bombdiggidy", "bang shabang", "ur skill is on fleek", "u dont kno ur beautiful", "this is amazeballs", "razzle dazzling job", "fantastic", "glorious", "bow chica bow wow", "nice as ice", "thats slammin", "hawt dayum", "\n\nSomeone almost got a\n tattoo of your name once,\n but their mom talked\n them out of it.", "great job man", "You are \"the one\nthat got away\".", "Strangers wanna sit\nnext to you on the bus.", "socks + sandals\n+ you = I'm into it.","\nYour principal would call\nyou to the office\njust to look cool.", "Einstein is \"mildly to\nmoderately\" intimidated.", "your photo is the star\nof your parent's mantle.","You are freakishly\n good at thumb wars.", "I will name my child\n and/or goldfish after you."]
        let random = Int(arc4random_uniform(UInt32(complimentArray.count)))
        if random == complimentArray.count {
            compliment.string = complimentArray[Int(complimentArray.count-1)]
            
        }else {
            compliment.string = complimentArray[random]
        }
        
    }
    
    
}

//This should go in a singleton, but will go here for now because it's easiest. This is the function which sets the correct object string based upon the index
extension MainScene{
    func objectString() -> String{
        var saveString : String
        switch NSUserDefaults.standardUserDefaults().integerForKey("objectIndex"){
        case 0:
            saveString = "RollingPin"
        case 1:
            saveString = "Plate"
        case 2:
            saveString = "Pan"
        case 3:
            saveString = "Sword"
        case 4:
            saveString = "Gun"
        default:
            saveString = "RollingPin"
        }
        return saveString
    }
}

extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        let viewController = CCDirector.sharedDirector().parentViewController!
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension MainScene: StreakDelegate{
    func startStreak() {
        streak1.resetSystem()
        streak2.resetSystem()
    }
    
    func stopStreak() {
        streak1.stopSystem()
        streak2.stopSystem()
    }
    func showCompliment(){
        makeCompliment()
        animationManager.runAnimationsForSequenceNamed("ComplimentIn Timeline")
    }
    func doneCompliment() {
        if scoreNode.state == .Streak {
            showCompliment()
        }
    }
    
}







