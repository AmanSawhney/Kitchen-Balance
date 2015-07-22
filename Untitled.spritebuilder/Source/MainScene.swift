
import Foundation
import GameKit
import StoreKit

enum typeOfObject {
    case RollingPin, Pan, Plate, Sward, Gun
}

var whichObject: typeOfObject!
var streakMultiplierSorce = 1
class MainScene: CCNode, CCPhysicsCollisionDelegate, FlurryAdInterstitialDelegate  {
    let view: UIViewController = CCDirector.sharedDirector().parentViewController! // Returns a UIView of the cocos2d view controller.
    var interstitialAdView: UIViewController = UIViewController()
    let adInterstitial = FlurryAdInterstitial(space:"FullScreen Ad");
    weak var currentScore: CCLabelTTF!
    weak var highScore: CCLabelTTF!
    weak var scoreNode: ScoreNode!
    weak var coinNode: CoinLabelNode!
    weak var hand: CCNode!
    weak var object: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var scoreLabel: CCLabelTTF!
    weak var levelUpLabel: CCLabelTTF!
    var complements = ["Much Wow", "Such Skill", "You're \n Beautiful", "So balance!", "Lookin' Good", "Chicken fries \n are back \n :D", "You Make \n Aman Proud", "Strong finger!", "Soft touch"]
    var currentTouchLocation: CGPoint!
    var pivot: CCPhysicsJoint!
    var score: Double = 0
    var audio = OALSimpleAudio.sharedInstance()
    let scorePerUpdate = 1.0
    var level = 0
    var done = false {
        didSet {
            //showInterstitial()
            if adInterstitial.ready {
                adInterstitial.presentWithViewController(view)
            } else {
                adInterstitial.fetchAd()
            }
            AudioServicesPlaySystemSound(1352)
            var shitScreen = CCBReader.load("ShitScreen", owner:self) as! ShitScreen
            shitScreen.position.x = -self.contentSize.width
            self.addChild(shitScreen)
            delay(1){
                self.animationManager.runAnimationsForSequenceNamed("GameOver Timeline")
            }
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var highScoreNumber = Int(defaults.doubleForKey("highscore"))
            highScore.string = "\(highScoreNumber)"
            currentScore.string = "\(Int(score))"
            hand.visible = false
            
        }
    }
    
    func spaceDidDismiss(adSpace: NSString, interstitial: Bool) {
        if (interstitial) { // Resume app state
            // [[SimpleAudioEngine sharedEngine] resume];
            CCDirector.sharedDirector().resume()
        }
        
    }
    override func onExit() {
        super.onExit()
        FlurryAds.setAdDelegate(nil)
    }
    
    
    func spaceShouldDisplay(adSpace: NSString, interstitial: Bool) -> Bool{
        if (interstitial) { //pause state
            // [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
            CCDirector.sharedDirector().pause()
        }
        // Continue ad display
        return true
    }
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    func didLoadFromCCB() {
        
        //hand.visible = true
        //gamePhysicsNode.debugDraw = true
        streakMultiplierSorce = 1
        levelUp()
        schedule("levelUp", interval: 10)
        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        schedule("compliement", interval: 5)
        schedule("spawnCoin", interval: 8, repeat: UInt(100000), delay: 2)
    }
    func showInterstitial() {
        if FlurryAds.adReadyForSpace("FullScreen Ad") {
            FlurryAds.displayAdForSpace("FullScreen Ad", onView: CCDirector.sharedDirector().view, viewControllerForPresentation: CCDirector.sharedDirector().parentViewController!)
        }
    }
    override func onEnter() {
        super.onEnter()
        adInterstitial.fetchAd();
        FlurryAds.setAdDelegate(self)
        FlurryAds.fetchAdForSpace("ADSPACE", frame: CGRectMake((self.contentSize.width/2),(self.contentSize.height/2), self.contentSize.width, self.contentSize.height), size: FULLSCREEN )
        if let whichObject = whichObject{
            
            switch whichObject{
            case .Gun:
                object = CCBReader.load("Objects/Gun") as! CCSprite
                object.scale = 0.5
            case .Sward:
                object = CCBReader.load("Objects/Sward") as! CCSprite
                object.scale = 0.4
                
            case .RollingPin:
                object = CCBReader.load("Objects/RollingPin") as! CCSprite
            case .Plate:
                object = CCBReader.load("Objects/Plate") as! CCSprite
            case .Pan:
                object = CCBReader.load("Objects/Pan") as! CCSprite
            default:
                object = CCBReader.load("Objects/RollingPin") as! CCSprite
            }
        } else {
            object = CCBReader.load("Objects/Plate") as! CCSprite
            
        }
        
        hand = CCBReader.load("Objects/Hand")
        hand.scale = 0.6
        hand.position = ccp(screenWidth/2, 0)
        object.position = ccp(screenWidth/2, hand.contentSizeInPoints.height * CGFloat(hand.scale) * (CGFloat(1) - hand.anchorPoint.y))
        
        hand.zOrder = 2
        object.zOrder = 1
        
        gamePhysicsNode.addChild(hand)
        gamePhysicsNode.addChild(object)
        if whichObject != .Gun {
            pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(object.contentSize.width/2 * CGFloat(object.scaleX), 0))
        } else {
            pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(object.position.x/2, 0))
        }
        pivot.collideBodies = false
        
        var randomRotation = Double(arc4random_uniform(2)) + 1.0
        object.rotation = Float(arc4random_uniform(2) == 1 ? randomRotation : -randomRotation)
        
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    func retry() {
        audio.playEffect("8bits/coin2.wav")
        animationManager.runAnimationsForSequenceNamed("ButtonPress Timeline")
        delay(1.5) {
            var playScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(playScene)
        }
    }
    func menu() {
        var menu = CCBReader.loadAsScene("Start")
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
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, object: CCNode!, coin: Coin!) -> Bool {
        if !coin.collected{
            var coins = NSUserDefaults.standardUserDefaults().integerForKey("Coins") + 1
            NSUserDefaults.standardUserDefaults().setInteger(coins, forKey: "Coins")
            coinNode.updateLabel(coins)
            coin.collect()
        }
        return false
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        currentTouchLocation = touch.locationInWorld()
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if !done{
            hand.position.x = CGFloat(clampf(Float(hand.position.x - (currentTouchLocation.x - touch.locationInWorld().x)), Float(0.0), Float(screenWidth)))
            currentTouchLocation = touch.locationInWorld()
        }
        
    }
    
    override func update(delta: CCTime) {
        
        
        hand.position.y = 0 //DO NOT DELETE THIS LINE. It makes hand a kinematic body and keeps pivot joint in line
        
        if !done{
            score += scoreNode.state.rawValue * scorePerUpdate * Double(streakMultiplierSorce)
            scoreNode.displayRotation(object.rotation)
            scoreNode.updateScore(score)
            
        }
        
        if abs(object.rotation) > 80 {
            if !done {
                gameOver()
            }
        }
        
    }
    func compliement() {
        var random = Int(arc4random_uniform(UInt32(complements.count - 1)))
        levelUpLabel.string = "\(complements[random])"
        self.animationManager.runAnimationsForSequenceNamed("LevelUp Timeline")
        
    }
    
    func levelUp() {
        level++
        if level != 1 {
            gamePhysicsNode.gravity.y -= CGFloat(300)
        }
        levelUpLabel.string = "Level \(level)"
        self.animationManager.runAnimationsForSequenceNamed("LevelUp Timeline")
        
    }
    
    func gameOver(){
        
        unschedule("levelUp")
        unschedule("compliement")
        
        done = true
        pivot.invalidate()
        unschedule("spawnCoin")
        GameCenterHelper.sharedInstance.saveHighScore(score)
    }
    
    func spawnCoin(){
        var coin = CCBReader.load("Coin")
        var coinPositionXOffset = CGFloat(arc4random_uniform(UInt32(screenWidth / 4)) + UInt32(screenWidth/5))
        let coinPositionX = CGFloat(arc4random_uniform(2) == 1 ? screenWidth/2 + coinPositionXOffset : screenWidth/2 - coinPositionXOffset)
        let coinPositionY = CGFloat(arc4random_uniform(UInt32(screenHeight * 0.55)) + UInt32(screenHeight * 0.18))
        
        coin.position = ccp(coinPositionX, coinPositionY)
        gamePhysicsNode.addChild(coin)
    }
    
    
    func restart(){
        var playScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(playScene)
    }
    
    func home(){
        var playScene = CCBReader.loadAsScene("Start")
        CCDirector.sharedDirector().replaceScene(playScene)
    }
    
}
extension MainScene: GKGameCenterControllerDelegate {
    
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
