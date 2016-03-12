//
//  TAPPXIntersitialView.h
//
//  Created by Tappx on 27/12/13.
//
//

#import <GoogleMobileAds/GADInterstitial.h>

@interface TAPPXInterstitialView : GADInterstitial<GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *dfpInters;
@property (nonatomic, strong) id del;
@property (nonatomic, strong) UIViewController* vc;

-(BOOL)interstitialShow:(TAPPXInterstitialView*)interstitialView delegate:(id <GADInterstitialDelegate> )theDelegate;

@end
