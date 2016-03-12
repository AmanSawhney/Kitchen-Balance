//
//  TAPPXMediationBannerAd.h
//
//  Created by Tappx on 28/05/15.
//
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "TAPPXBanner.h"

@interface TAPPXMediationBannerAd : NSObject<GADCustomEventBanner, TAPPXBannerDelegate>

@property (nonatomic, strong) TAPPXBannerView *tappxBanner;
@property (nonatomic, strong) id del;

@end
