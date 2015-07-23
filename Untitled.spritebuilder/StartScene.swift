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
class StartScene: CCScene  {
    var ads = false
    var swipable = false
    let view: UIViewController = CCDirector.sharedDirector().parentViewController! // Returns a UIView of the cocos2d view controller.
    var interstitialAdView: UIViewController = UIViewController()
    let adInterstitial = FlurryAdInterstitial(space:"FullScreen Ad");
    let watch = FlurryAdInterstitial(space:"WatchForCoins");
    weak var currentScore: CCLabelTTF!
    weak var object1: CCSprite!
    weak var object2: CCSprite!
    weak var object3: CCSprite!
    weak var object4: CCSprite!
    weak var object5: CCSprite!
    var moveright = false
    var objects: [CCSprite] = []
    weak var hand1: CCButton!
    weak var hand2: CCButton!
    var list = [SKProduct]()
    var p = SKProduct()
    var audio = OALSimpleAudio.sharedInstance()
    func didLoadFromCCB() {
        iAdHandler.sharedInstance.loadAds(bannerPosition: .Top)
        
        GameCenterHelper.sharedInstance.authenticationCheck()
        
        iAdHelper.sharedHelper()
        iAdHelper.setBannerPosition(TOP)
        
        objects.append(object1)
        objects.append(object2)
        objects.append(object3)
        objects.append(object4)
        objects.append(object5)
        whichObject = .RollingPin
        userInteractionEnabled = true
    }
    func watchForCoins() {
        FlurryAds.fetchAdForSpace("WatchForCoins", frame: CGRectMake((self.contentSize.width/2),(self.contentSize.height/2), self.contentSize.width, self.contentSize.height), size: FULLSCREEN )
        presentInterstitial()
    }
    override func onEnter() {
        super.onEnter()
        
        FlurryAds.setAdDelegate(self)
        FlurryAds.fetchAdForSpace("WatchForCoins", frame: CGRectMake((self.contentSize.width/2),(self.contentSize.height/2), self.contentSize.width, self.contentSize.height), size: FULLSCREEN )
        FlurryAds.fetchAdForSpace("FullScreen Ad", frame: CGRectMake((self.contentSize.width/2),(self.contentSize.height/2), self.contentSize.width, self.contentSize.height), size: FULLSCREEN )
        adInterstitial.fetchAd()
        watch.fetchAd()
        // Set IAPS
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
    func showInterstitial() {
        if FlurryAds.adReadyForSpace("FullScreen Ad") {
            FlurryAds.displayAdForSpace("FullScreen Ad", onView: CCDirector.sharedDirector().view, viewControllerForPresentation: CCDirector.sharedDirector().parentViewController!)
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
    func presentVideo(){
        //logic so they aren't bombarded with ads every time
        if watch.ready {
            watch.presentWithViewController(view)
        } else {
            watch.fetchAd()
        }
    }

    func right() {
        audio.playEffect("8bits/coin2.wav")
        if whichObject != .Gun {
            for object in objects {
                var move = CCActionMoveTo(duration: 0.2, position: ccp(object.position.x - 1, object.position.y))
                object.runAction(move)
            }
        }
    }
    func left() {
        audio.playEffect("8bits/coin2.wav")
        if whichObject != .RollingPin {
            for object in objects {
                var move = CCActionMoveTo(duration: 0.2, position: ccp(object.position.x + 1, object.position.y))
                object.runAction(move)
            }
        }
    }
    func moveObjects(orginalPostion: CGPoint) {
        
        while object1.position.x < -orginalPostion.x {
            for object in objects {
                object.position.x--
            }
        }
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
        delay(1.5) {
            var playScene = CCBReader.loadAsScene("MainScene")
            CCDirector.sharedDirector().replaceScene(playScene)
        }
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
    override func update(delta: CCTime) {
        
        for object in objects {
            
            if object1.position.x == 0.5{
                whichObject = .RollingPin
                if hand1.animationManager.runningSequenceName != "GoAway Timeline" && hand1.animationManager.runningSequenceName != "Done Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("GoAway Timeline")
                }
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                
            } else if object2.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                whichObject = .Plate
            } else if object3.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                whichObject = .Pan
                
            }else if object4.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                
                if hand2.animationManager.runningSequenceName != "ComeBack Timeline" && hand2.animationManager.runningSequenceName != "Default Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                whichObject = .Sward
            }else if object5.position.x == 0.5 {
                if hand1.animationManager.runningSequenceName != "ComeBack Timeline" && hand1.animationManager.runningSequenceName != "Default Timeline"{
                    hand1.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                }
                if hand2.animationManager.runningSequenceName != "GoAway Timeline" && hand2.animationManager.runningSequenceName != "Done Timeline"{
                    hand2.animationManager.runAnimationsForSequenceNamed("GoAway Timeline")
                }
                whichObject = .Gun
            }
            
            
        }
    }
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
        println("add paymnet")
        
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