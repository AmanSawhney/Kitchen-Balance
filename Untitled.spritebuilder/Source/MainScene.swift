
import Foundation

enum typeOfObject {
  case RollingPin, Pan, Plate
}
var whichObject: typeOfObject!

class MainScene: CCNode {
  weak var hand: CCNode!
  weak var object: CCSprite!
  weak var gamePhysicsNode: CCPhysicsNode!
  var currentTouchLocation: CGPoint!
  var pivot: CCPhysicsJoint!
  var done = false {
    didSet {
      var shitScreen = CCBReader.load("ShitScreen") as! ShitScreen
      shitScreen.position.x = -self.contentSize.width
      self.addChild(shitScreen)
    }
  }
  
  
  var screenWidth = UIScreen.mainScreen().bounds.width
  var screenHeight = UIScreen.mainScreen().bounds.height
  
  func didLoadFromCCB() {
    
    gamePhysicsNode.debugDraw = true
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

    gamePhysicsNode.addChild(object)
    gamePhysicsNode.addChild(hand)
    pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(30, 0))
    pivot.collideBodies = false
    object.physicsBody.applyImpulse(ccp(0,10))
    
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    currentTouchLocation = touch.locationInWorld()
  }
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    hand.position.x = hand.position.x - (currentTouchLocation.x - touch.locationInWorld().x)
    println(currentTouchLocation == touch.locationInWorld())
    println("This touch Location = \(touch.locationInWorld().x)")
    println("Previous touch Location = \(currentTouchLocation.x)")

    currentTouchLocation = touch.locationInWorld()
  }
  override func update(delta: CCTime) {
    //        println(Int(pin.rotation))
    if Int(object.rotation) <= -130 || (Int(object.rotation) >= 110) {
      if !done {
        done = true
        pivot.invalidate()
      }
      //      var mainScene : CCScene =  CCBReader.loadAsScene("Easy")
      //      CCDirector.sharedDirector().replaceScene(mainScene)
    }
    if currentTouchLocation != nil {
      var random = arc4random_uniform(300)
      if hand.position.x > CCDirector.sharedDirector().viewSize().width/2 {
        object.physicsBody.applyImpulse(ccp(-CGFloat(random),0))
      } else if hand.position.x < CCDirector.sharedDirector().viewSize().width/2 {
        object.physicsBody.applyImpulse(ccp(CGFloat(random),0))
      }
    }
  }
  
}
