import Foundation

class MainScene: CCNode {
    weak var pin: CCSprite!
    weak var hand: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    func didLoadFromCCB() {
        gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
    }
    override func update(delta: CCTime) {
        print(pin.position)
    }
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        hand.position.x = touch.locationInWorld().x
    }
    
}
