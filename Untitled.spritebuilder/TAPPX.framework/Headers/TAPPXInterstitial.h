//
//  TAPPXIntersitial.h
//
//  Created by Tappx on 27/12/13.
//
//

#import <Foundation/Foundation.h>
#import "TAPPXInterstitialView.h"
#import "TAPPXRequestError.h"
#import <GoogleMobileAds/GADInterstitialDelegate.h>

@protocol TAPPXInterstitialDelegate;

@interface TAPPXInterstitial : TAPPXInterstitialView<GADInterstitialDelegate>

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) TAPPXInterstitialView* TappxInterstitial;

-(TAPPXInterstitialView*)createInterstitial:(id <TAPPXInterstitialDelegate> )theDelegate;

@end

@protocol TAPPXInterstitialDelegate <GADInterstitialDelegate>

-(UIViewController*)presentViewController;

@optional

- (void)tappxInterstitialDidReceiveAd:(TAPPXInterstitialView *)ad;
- (void)tappxInterstitial:(TAPPXInterstitialView *)ad didFailToReceiveAdWithError:(TAPPXRequestError *)error;
- (void)tappxInterstitialWillPresentScreen:(TAPPXInterstitialView *)ad;
- (void)tappxInterstitialWillDismissScreen:(TAPPXInterstitialView *)ad;
- (void)tappxInterstitialDidDismissScreen:(TAPPXInterstitialView *)ad;
- (void)tappxInterstitialWillLeaveApplication:(TAPPXInterstitialView *)ad;

@end
