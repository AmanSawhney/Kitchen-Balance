
import Foundation
import GameKit
import StoreKit

var streakMultiplierSorce = 1

class MainScene: CCNode, CCPhysicsCollisionDelegate, FlurryAdInterstitialDelegate  {
  
  let view: UIViewController = CCDirector.sharedDirector().parentViewController! // Returns a UIView of the cocos2d view controller.
  var interstitialAdView: UIViewController = UIViewController()
  let adInterstitial = FlurryAdInterstitial(space:"FullScreen Ad Babay Balance")
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
  let scorePerLevel = 1000
  
  weak var streak1: CCParticleSystem!
  weak var streak2: CCParticleSystem!
  
  var done = false
  
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
      CCDirector.sharedDirector().pause()
    }
    // Continue ad display
    return true
  }
  
  var screenWidth = UIScreen.mainScreen().bounds.width
  var screenHeight = UIScreen.mainScreen().bounds.height
  
  func didLoadFromCCB() {
    
    stopStreak()
    
    scoreNode.delegate = self
    
    //hand.visible = true
    //gamePhysicsNode.debugDraw = true
    gamePhysicsNode.collisionDelegate = self
    userInteractionEnabled = true
    schedule("spawnCoin", interval: 8, repeat: UInt(100000), delay: 2)
  }
  
  func adInterstitialVideoDidFinish(interstitialAd: FlurryAdInterstitial!) {
    
  }
  
  func showInterstitial() {
    if FlurryAds.adReadyForSpace("FullScreen Ad Babay Balance") {
      FlurryAds.displayAdForSpace("FullScreen Ad Babay Balance", onView: CCDirector.sharedDirector().view, viewControllerForPresentation: CCDirector.sharedDirector().parentViewController!)
    }
  }
  
  func presentInterstitial(){
    //logic so they aren't bombarded with ads every time
    if adInterstitial.ready {
      adInterstitial.presentWithViewController(view)
    } else {
      adInterstitial.fetchAd()
    }
  }
  

  override func onEnter() {
    super.onEnter()
    adInterstitial.fetchAd()
    FlurryAds.setAdDelegate(self)
    FlurryAds.fetchAdForSpace("FullScreen Ad", frame: CGRectMake((self.contentSize.width/2),(self.contentSize.height/2), self.contentSize.width, self.contentSize.height), size: FULLSCREEN )
    
    object = CCBReader.load(ObjectSingleton.sharedInstance.getCurrentObject().ccbPath) as! CCSprite
    
    hand = CCBReader.load("Objects/Hand")
    hand.scale = 0.6
    hand.position = ccp(screenWidth/2, 0)
    object.position = ccp(screenWidth/2, hand.contentSizeInPoints.height * CGFloat(hand.scale) * (CGFloat(1) - hand.anchorPoint.y))
    
    hand.zOrder = 2
    object.zOrder = 1
    
    gamePhysicsNode.addChild(hand)
    gamePhysicsNode.addChild(object)
    
    pivot = CCPhysicsJoint(pivotJointWithBodyA: object.physicsBody, bodyB: hand.physicsBody, anchorA: ccp(object.contentSize.width/2 * CGFloat(object.scaleX), 0))
    pivot.collideBodies = false
    
    OALSimpleAudio.sharedInstance().playEffect("scoreMoving.wav", loop: true)
    
    var randomRotation = Double(arc4random_uniform(2)) + 1.0
    object.rotation = Float(arc4random_uniform(2) == 1 ? randomRotation : -randomRotation)
    
  }

  func retry() {
    audio.playEffect("8bits/coin2.wav")
    animationManager.runAnimationsForSequenceNamed("ButtonPress Timeline")
    
    
    var playScene = CCBReader.loadAsScene("MainScene")
    
    var delay = CCActionDelay(duration: 1.5)
    var presentScene = CCActionCallBlock(block: {CCDirector.sharedDirector().replaceScene(playScene)})
    runAction(CCActionSequence(array: [delay, presentScene]))
    
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
      score += scoreNode.state.rawValue * scorePerUpdate
      scoreNode.displayRotation(object.rotation)
      scoreNode.updateScore(score)
    }
    
    if abs(object.rotation) > 80 && !done{
        gameOver()
    }
    
    if Int(score) > level * scorePerLevel{
      levelUp()
    }
    
  }
  
  func levelUp() {
    OALSimpleAudio.sharedInstance().playEffect("levelUp.wav")
    object.physicsBody.applyAngularImpulse(10)//knock the object loose if at rest
    level++
    gamePhysicsNode.gravity.y -= CGFloat(100)
    levelLabel.level = level
    levelLabel.animationManager.runAnimationsForSequenceNamed("LevelUp")
  }
  
  func adInterstitial(interstitialAd: FlurryAdInterstitial!, adError: FlurryAdError, errorDescription: NSError!) {
    println(errorDescription)
  }
  
  func gameOver(){
    
    OALSimpleAudio.sharedInstance().stopAllEffects()

    OALSimpleAudio.sharedInstance().playEffect("itemDrop.wav")
    
    done = true
    presentInterstitial()
    unschedule("spawnCoin")
    
    AudioServicesPlaySystemSound(1352)
    let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 12)))
    let moveBack = CCActionEaseBounceOut(action: move.reverse())
    let shakeSequence = CCActionSequence(array: [move, moveBack])
    runAction(shakeSequence)
    self.animationManager.runAnimationsForSequenceNamed("GameOver Timeline")
    
    ObjectSingleton.sharedInstance.recordDrop(score)
    
    highScore.string = "\(Int(ObjectSingleton.sharedInstance.getCurrentObject().highScore))"
    currentScore.string = "\(Int(score))"
    hand.visible = false
    
    pivot.invalidate()
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

extension MainScene: StreakDelegate{
  
  func startStreak() {
    OALSimpleAudio.sharedInstance().playEffect("achievement.wav")
    streak1.resetSystem()
    streak2.resetSystem()
  }
  
  func stopStreak() {
    streak1.stopSystem()
    streak2.stopSystem()
  }
  
}






