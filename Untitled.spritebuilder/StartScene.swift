//
//  StartScene.swift
//  Untitled
//
//  Created by Gagandeep Sawhney on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import UIKit
import GameKit
import StoreKit

class StartScene: CCScene, FlurryAdInterstitialDelegate  {
  
  let view: UIViewController = CCDirector.sharedDirector().parentViewController! // Returns a UIView of the cocos2d view controller.
  var interstitialAdView: UIViewController = UIViewController()
  let adInterstitial = FlurryAdInterstitial(space:"WatchForCoins")
  var ads = false
  
  weak var currentScore: CCLabelTTF!
  
  weak var object1: CCSprite!
  weak var object2: CCSprite!
  weak var object3: CCSprite!
  weak var object4: CCSprite!
  weak var object5: CCSprite!
  var objects: [CCSprite] = []
  var objectsInPosition = true

  weak var hand1: CCButton!
  weak var hand2: CCButton!
  
  var currentIndex : Int = 0 {
    didSet{
      if currentIndex >= objects.count{
        currentIndex = objects.count - 1
      } else if currentIndex < 0{
        currentIndex = 0
      }
      
      moveSpritesToPosition()
      
      NSUserDefaults.standardUserDefaults().setInteger(currentIndex, forKey: "objectIndex")

    }
  }
  
  var list = [SKProduct]()
  var p = SKProduct()
  let audio = OALSimpleAudio.sharedInstance()
  var screenWidth = UIScreen.mainScreen().bounds.width
  var screenHeight = UIScreen.mainScreen().bounds.height
  
  func showInterstitial() {
    if FlurryAds.adReadyForSpace("WatchForCoins") {
      FlurryAds.displayAdForSpace("WatchForCoins", onView: CCDirector.sharedDirector().view, viewControllerForPresentation: CCDirector.sharedDirector().parentViewController!)
    }
  }
  
  func adInterstitialVideoDidFinish(interstitialAd: FlurryAdInterstitial!) {
    var coins = NSUserDefaults.standardUserDefaults().integerForKey("Coins") + 50
    NSUserDefaults.standardUserDefaults().setInteger(coins, forKey: "Coins")
  }
  
  func presentInterstitial(){
    //logic so they aren't bombarded with ads every time
    if adInterstitial.ready {
      adInterstitial.presentWithViewController(view)
    } else {
      adInterstitial.fetchAd()
    }
  }
  
  func spaceDidDismiss(adSpace: NSString, interstitial: Bool) {
    if (interstitial) { // Resume app state
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
  
  func didLoadFromCCB() {
    
//    iAdHandler.sharedInstance.loadAds(bannerPosition: .Top)
    
    GameCenterHelper.sharedInstance.authenticationCheck()
    
    iAdHelper.sharedHelper()
    iAdHelper.setBannerPosition(TOP)
    
    objects.append(object1)
    objects.append(object2)
    objects.append(object3)
    objects.append(object4)
    objects.append(object5)
    userInteractionEnabled = true
    
    currentIndex = NSUserDefaults.standardUserDefaults().integerForKey("objectIndex")
    moveSpritesToPosition()
    
  }
  
  override func onEnter() {
    super.onEnter()
    // Set IAPS
    adInterstitial.fetchAd()
    FlurryAds.setAdDelegate(self)
    FlurryAds.fetchAdForSpace("WatchForCoins", frame: CGRectMake((self.contentSize.width/2),(self.contentSize.height/2), self.contentSize.width, self.contentSize.height), size: FULLSCREEN )
    if(SKPaymentQueue.canMakePayments()) {
      println("IAP is enabled, loading")
      var productID:NSSet = NSSet(objects: "com.gunteamstudios.offbalance.removeAds")
      var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
      request.delegate = self
      request.start()
    } else {
      println("please enable IAPS")
    }
  }
  
  func watchForCoins() {
    presentInterstitial()
  }
  
  func right() {
    audio.playEffect("8bits/coin2.wav")
    currentIndex++
  }
  
  func left() {
    audio.playEffect("8bits/coin2.wav")
    currentIndex--
  }
  
  func moveSpritesToPosition(){
    if objectsInPosition{
      for index in 0..<objects.count{
        var object = objects[index]
        var xPos = (0.5 + Float(index - currentIndex))
        var moveObject = CCActionMoveTo(duration: 0.1, position: CGPointMake(CGFloat(xPos), object.position.y))
        object.runAction(moveObject)
      }
      
      objectsInPosition = false
      var delay = CCActionDelay(duration: 0.1)
      var resetBool = CCActionCallBlock(block: {self.objectsInPosition = true})
      runAction(CCActionSequence(array: [delay, resetBool]))
      
    }
    
  }
  
  func iads() {
    for product in list {
      var prodID = product.productIdentifier
      if(prodID == "com.gunteamstudios.offbalance.removeAds") {
        p = product
        
        var alert = UIAlertView()
        alert.title = "\(p.localizedTitle)"
        alert.message = "\(p.localizedDescription)"
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Purchase")
        alert.addButtonWithTitle("Restore Previous Purchase")
        alert.delegate = self
        alert.show()
        
        break;
      }
    }
  }
  
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 1 {
      buyProduct()
    } else if buttonIndex == 2 {
      SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
  }
  
  func play() {
    audio.playEffect("8bits/coin2.wav")
    animationManager.runAnimationsForSequenceNamed("ButtonPress Timeline")
    
    userInteractionEnabled = false
    
    var playScene = CCBReader.loadAsScene("MainScene")
    
    var delay = CCActionDelay(duration: 1.5)
    var presentScene = CCActionCallBlock(block: {CCDirector.sharedDirector().replaceScene(playScene)})
    runAction(CCActionSequence(array: [delay, presentScene]))
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
}

extension StartScene: FlurryAdInterstitialDelegate {
  
}

// Mark: StoreKit
extension StartScene: SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  // 2
  func buyProduct() {
    println("buy " + p.productIdentifier)
    var pay = SKPayment(product: p)
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    
  }
  
  //3
  func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
    println("product request")
    var myProduct = response.products
    
    for product in myProduct {
      println("product added")
      println(product.productIdentifier)
      println(product.localizedTitle)
      println(product.localizedDescription)
      println(product.price)
      
      list.append(product as! SKProduct)
    }
  }
  
  // 4
  func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
    println("transactions restored")
    
    var purchasedItemIDS = []
    for transaction in queue.transactions {
      var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
      
      let prodID = t.payment.productIdentifier as String
      
      switch prodID {
      case "com.gunteamstudios.offbalance.removeAds":
        println("remove ads")
      default:
        println("IAP not setup")
      }
      
    }
  }
  
  // 5
  func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
    println("add payment")
    
    for transaction:AnyObject in transactions {
      var trans = transaction as! SKPaymentTransaction
      println(trans.error)
      
      switch trans.transactionState {
        
      case .Purchased:
        println("buy, ok unlock iap here")
        println(p.productIdentifier)
        
        let prodID = p.productIdentifier as String
        switch prodID {
        case "com.gunteamstudios.offbalance.removeAds":
          println("remove ads")
          
        default:
          println("IAP not setup")
        }
        
        queue.finishTransaction(trans)
        break;
      case .Failed:
        println("buy error")
        queue.finishTransaction(trans)
        break;
      default:
        println("default")
        break;
        
      }
    }
    
    // 6
    func finishTransaction(trans:SKPaymentTransaction)
    {
      println("finish trans")
      SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    
    //7
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
    {
      println("remove trans")
    }
    
  }
}


// MARK: Game Center Handling
extension StartScene: GKGameCenterControllerDelegate {
  
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