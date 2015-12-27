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
    var colorValue: GLubyte = 255
    let view: UIViewController = CCDirector.sharedDirector().parentViewController! // Returns a UIView of the cocos2d view controller.
    var ads = NSUserDefaults.standardUserDefaults().boolForKey("ads")
    weak var playButton: CCButton!
    weak var rightButton: CCButton!
    weak var rightSprite: CCSprite!
    weak var flare: CCParticleSystem!
    weak var currentScore: CCLabelTTF!
    weak var buybutton: CCNode!
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
    
    
    
    override func onExit() {
        super.onExit()
    }
    
    func spaceShouldDisplay(adSpace: NSString, interstitial: Bool) -> Bool{
        if (interstitial) { //pause state
            CCDirector.sharedDirector().pause()
        }
        
        // Continue ad display
        return true
    }
    
    func didLoadFromCCB() {
        GameCenterHelper.sharedInstance.authenticationCheck()
        if !ads {
            iAdHelper.sharedHelper()
            iAdHelper.setBannerPosition(TOP)
            iAdHelper.load()
        }
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
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "com.amansawhney.offbalance.removeAds")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
    }
    
    func watchForCoins() {
    }
    
    func right() {
        audio.playEffect("8bits/coin2.wav")
        if NSUserDefaults.standardUserDefaults().integerForKey("owned") + 1 > currentIndex {
            currentIndex++
        }
    }
    
    func left() {
        audio.playEffect("8bits/coin2.wav")
        currentIndex--
    }
    
    func moveSpritesToPosition(){
        if objectsInPosition{
            for index in 0..<objects.count{
                let object = objects[index]
                let xPos = (0.5 + Float(index - currentIndex))
                let moveObject = CCActionMoveTo(duration: 0.1, position: CGPointMake(CGFloat(xPos), object.position.y))
                object.runAction(moveObject)
            }
            
            objectsInPosition = false
            let delay = CCActionDelay(duration: 0.1)
            let resetBool = CCActionCallBlock(block: {self.objectsInPosition = true})
            runAction(CCActionSequence(array: [delay, resetBool]))
            
        }
        
    }
    
    func iads() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.amansawhney.offbalance.removeAds") {
                p = product
                let alert = UIAlertView()
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
        
        let playScene = CCBReader.loadAsScene("MainScene")
        
        let delay = CCActionDelay(duration: 1.5)
        let presentScene = CCActionCallBlock(block: {CCDirector.sharedDirector().replaceScene(playScene)})
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
    func info() {
        audio.playEffect("8bits/coin2.wav")
    }
    func buy() {
        if currentIndex > NSUserDefaults.standardUserDefaults().integerForKey("owned") && NSUserDefaults.standardUserDefaults().integerForKey("Coins") >= 100 {
            NSUserDefaults.standardUserDefaults().setInteger(NSUserDefaults.standardUserDefaults().integerForKey("Coins")-100, forKey: "Coins")
            NSUserDefaults.standardUserDefaults().setInteger(currentIndex, forKey: "owned")
            flare.visible = true
            audio.playEffect("8bits/buy.wav")
        }
    }
    override func update(delta: CCTime) {
        if currentIndex > NSUserDefaults.standardUserDefaults().integerForKey("owned") {
            if (buybutton.animationManager.runningSequenceName == "GoAway Nil" || buybutton.animationManager.runningSequenceName == "GoAway") && (buybutton.animationManager.runningSequenceName != "Default Nil" && buybutton.animationManager.runningSequenceName != "Default Timeline"){
                buybutton.animationManager.runAnimationsForSequenceNamed("Default Timeline")
                
            }
            if colorValue >= 85 {
                colorValue -= 5
                playButton.background.colorRGBA = CCColor(ccColor3b: ccColor3B(r: colorValue, g: colorValue, b: colorValue))
                playButton.state = .Disabled
                for object in objects {
                    object.colorRGBA = CCColor(ccColor3b: ccColor3B(r: colorValue-50, g: colorValue-50, b: colorValue-50))
                }
                
            }
            if rightSprite != nil {
                if Int(colorValue)-155 > 0 {
                    rightSprite.opacity = CGFloat(Double(Int(colorValue)-155)/100.0)
                }else {
                    rightSprite.opacity = 0.0
                }
            }
            rightButton.state = .Disabled
        }else {
            if (buybutton.animationManager.runningSequenceName == "Default Nil" || buybutton.animationManager.runningSequenceName == "Default Timeline") && (buybutton.animationManager.runningSequenceName != "GoAway Nil" && buybutton.animationManager.runningSequenceName != "GoAway"){
                buybutton.animationManager.runAnimationsForSequenceNamed("GoAway")
            }
            if colorValue <= 250 {
                colorValue += 5
                playButton.background.colorRGBA = CCColor(ccColor3b: ccColor3B(r: colorValue, g: colorValue, b: colorValue))
                playButton.state = .Normal
                for object in objects {
                    object.colorRGBA = CCColor(ccColor3b: ccColor3B(r: colorValue, g: colorValue, b: colorValue))
                }
                
            }
            if rightSprite != nil {
                if Int(colorValue)-155 > 0 {
                    rightSprite.opacity = CGFloat(Double(Int(colorValue)-155)/100.0)
                }else {
                    rightSprite.opacity = 0.0
                }
            }
            rightButton.state = .Normal
        }
    }
}



// Mark: StoreKit
extension StartScene: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // 2
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
        
    }
    
    //3
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product )
        }
    }
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.amansawhney.offbalance.removeAds":
                print("remove ads")
            default:
                print("IAP not setup")
            }
            
        }
    }
    
    // 5
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            var trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.amansawhney.offbalance.removeAds":
                    print("remove ads")
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ads")
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
        
        // 6
        func finishTransaction(trans:SKPaymentTransaction)
        {
            print("finish trans")
            SKPaymentQueue.defaultQueue().finishTransaction(trans)
        }
        
        //7
        func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
        {
            print("remove trans")
        }
        
    }
}


// MARK: Game Center Handling
extension StartScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        
        let viewController = CCDirector.sharedDirector().parentViewController!
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
        
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}