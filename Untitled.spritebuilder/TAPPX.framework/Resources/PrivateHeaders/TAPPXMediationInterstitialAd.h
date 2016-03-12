//
//  TAPPXMediationInterstitialAd.h
//
//  Created by Tappx on 28/05/15.
//
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "TAPPXInterstitial.h"

@interface TAPPXMediationInterstitialAd : NSObject<GADCustomEventInterstitial, TAPPXInterstitialDelegate>

@property (nonatomic, strong) TAPPXInterstitialView *tappxInterstitial;
@property (nonatomic, strong) id del;

@end
