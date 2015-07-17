import Foundation

class Hell: CCNode {
  weak var pin: CCSprite!
  weak var hand: CCSprite!
  weak var gamePhysicsNode: CCPhysicsNode!
  weak var currentTouch: CCTouch!
  var hard = false
  var hell = false
  var easy = false
  func didLoadFromCCB() {
    //gamePhysicsNode.debugDraw = true
    userInteractionEnabled = true
  }
  
  override func onEnter() {
    super.onEnter()
    
    var pivot = CCPhysicsJoint(pivotJointWithBodyA: pin.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(0,pin.contentSize.height))
    pivot.collideBodies = false
    pin.physicsBody.applyImpulse(ccp(0,10))
    
    
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    
  }
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    hand.position.x = touch.locationInWorld().x
    currentTouch = touch
  }
  override func update(delta: CCTime) {
    println(Int(pin.rotation))
    if Int(pin.rotation) <= -220 || (Int(pin.rotation) >= 30) {
      var mainScene : CCScene =  CCBReader.loadAsScene("Hell")
      CCDirector.sharedDirector().replaceScene(mainScene)
    }
    if currentTouch != nil {
      var random = arc4random_uniform(300)
      if hand.position.x > CCDirector.sharedDirector().viewSize().width/2 {
        pin.physicsBody.applyImpulse(ccp(-CGFloat(random),0))
      } else if hand.position.x < CCDirector.sharedDirector().viewSize().width/2 {
        pin.physicsBody.applyImpulse(ccp(CGFloat(random),0))
      }
    }
  }
  
}
