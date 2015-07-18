import Foundation
enum typeOfObject {
    case RollingPin, Pan, Plate
}
var object: typeOfObject!

class MainScene: CCNode {
    weak var hand: CCNode!
    weak var pin: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var currentTouch: CCTouch!
    var pivot: CCPhysicsJoint!
    var done = false {
        didSet {
            var shitScreen = CCBReader.load("ShitScreen") as! ShitScreen
            shitScreen.position.x = -self.contentSize.width/2
            self.addChild(shitScreen)
        }
    }
    func didLoadFromCCB() {
        if object == .RollingPin {
            hand = CCBReader.load("Hand")
            hand.position = ccp(CGFloat(CCDirector.sharedDirector().viewSize().width / 2 ), CGFloat(-(hand.contentSize.height/2)))
            pin = CCBReader.load("RollingPin")
            pin.position = ccp(CGFloat(CCDirector.sharedDirector().viewSize().width / 2 - pin.contentSize.width),(hand.contentSize.height/2))
            gamePhysicsNode.addChild(pin)
            gamePhysicsNode.addChild(hand)
        }else if object == .Pan {
            hand = CCBReader.load("Hand")
            hand.position = ccp(CGFloat(CCDirector.sharedDirector().viewSize().width / 2 ), CGFloat(-(hand.contentSize.height/2)))
            pin = CCBReader.load("Pan")
            pin.position = ccp(CGFloat(CCDirector.sharedDirector().viewSize().width / 2 - pin.contentSize.width),(hand.contentSize.height/2))
            gamePhysicsNode.addChild(pin)
            gamePhysicsNode.addChild(hand)
        } else if object == .Plate {
            hand = CCBReader.load("Hand")
            hand.position = ccp(CGFloat(CCDirector.sharedDirector().viewSize().width / 2 ), CGFloat(-(hand.contentSize.height/2)))
            pin = CCBReader.load("Plate")
            pin.position = ccp(CGFloat(CCDirector.sharedDirector().viewSize().width / 2 - pin.contentSize.width),(hand.contentSize.height/2))
            gamePhysicsNode.addChild(pin)
            gamePhysicsNode.addChild(hand)
        }
        //gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
    }
    
    override func onEnter() {
        super.onEnter()
        
        pivot = CCPhysicsJoint(pivotJointWithBodyA: pin.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(pin.position.x/4,0))
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
        if Int(pin.rotation) <= -130 || (Int(pin.rotation) >= 110) {
            if !done {
                done = true
                pivot.invalidate()
            }
            //      var mainScene : CCScene =  CCBReader.loadAsScene("Easy")
            //      CCDirector.sharedDirector().replaceScene(mainScene)
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
