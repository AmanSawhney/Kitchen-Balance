
import Foundation

enum typeOfObject {
    case RollingPin, Pan, Plate, Sward, Gun
}
var whichObject: typeOfObject!

class MainScene: CCNode, CCPhysicsCollisionDelegate {
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
    let scorePerUpdate = 1.0
    var level = 0
    var done = false {
        didSet {
            var shitScreen = CCBReader.load("ShitScreen", owner:self) as! ShitScreen
            shitScreen.position.x = -self.contentSize.width
            self.addChild(shitScreen)
        }
    }
    
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    func didLoadFromCCB() {
        //gamePhysicsNode.debugDraw = true
        levelUp()
        schedule("levelUp", interval: 10)
        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        schedule("compliement", interval: 3)
        schedule("spawnCoin", interval: 8, repeat: UInt(100000), delay: 2)
    }
    
    override func onEnter() {
        super.onEnter()
        
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
            score += scoreNode.state.rawValue * scorePerUpdate
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
