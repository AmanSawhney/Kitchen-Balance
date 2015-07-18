
import Foundation

enum typeOfObject {
  case RollingPin, Pan, Plate
}
var whichObject: typeOfObject!

class MainScene: CCNode, CCPhysicsCollisionDelegate {
  weak var coinNode: CoinLabelNode!
  weak var hand: CCNode!
  weak var object: CCSprite!
  weak var gamePhysicsNode: CCPhysicsNode!
  weak var scoreLabel: CCLabelTTF!
  var currentTouchLocation: CGPoint!
  var pivot: CCPhysicsJoint!
  var score: Double = 0 {
    didSet{
      scoreLabel.string = "\(Int(score))"
    }
  }
  let scorePerUpdate = 31.0
//  var 
  var rotationMultiplier: Double = 1
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
    gamePhysicsNode.collisionDelegate = self
    userInteractionEnabled = true
  }
  
  override func onEnter() {
    super.onEnter()
    
    if let whichObject = whichObject{
      
      switch whichObject{
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
      object = CCBReader.load("Objects/RollingPin") as! CCSprite

    }

    hand = CCBReader.load("Objects/Hand")
    hand.scale = 0.6
    hand.position = ccp(screenWidth/2, 0)
    object.position = ccp(screenWidth/2, hand.contentSizeInPoints.height * CGFloat(hand.scale) * (CGFloat(1) - hand.anchorPoint.y))
    
    hand.zOrder = 2
    object.zOrder = 1
    
    gamePhysicsNode.addChild(hand)
    gamePhysicsNode.addChild(object)
    
    pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(20, 0))
    pivot.collideBodies = false
    
    var randomRotation = Double(arc4random_uniform(2)) + 1.0
    object.rotation = Float(arc4random_uniform(2) == 1 ? randomRotation : -randomRotation)
//    println(object.rotation)
    
  }
  
  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, object: CCNode!, coin: Coin!) -> Bool {
    if !coin.collected{
      coinNode.updateLabel(1)
      coin.collect()
    }
    return false
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    currentTouchLocation = touch.locationInWorld()
  }
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    hand.position.x = CGFloat(clampf(Float(hand.position.x - (currentTouchLocation.x - touch.locationInWorld().x)), Float(0.0), Float(screenWidth)))
    currentTouchLocation = touch.locationInWorld()
  }
  override func update(delta: CCTime) {
    hand.position.y = 0 //DO NOT DELETE THIS LINE. It makes hand a kinematic body and keeps pivot joint in line
    
    if !done{
      score += rotationMultiplier * scorePerUpdate
    }
    
    if abs(object.rotation) > 80 {
      if !done {
        done = true
        pivot.invalidate()
      }
    }

  }
  
  func restart(){
    var playScene = CCBReader.loadAsScene("MainScene")
    CCDirector.sharedDirector().replaceScene(playScene)
  }
  
}
