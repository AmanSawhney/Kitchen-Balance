//
//  TAPPXNativeAds.h
//
//  Created by Tappx on 29/07/14.
//
//

#import <Foundation/Foundation.h>
#import "TAPPXRequestError.h"
#import <GoogleMobileAds/GADAppEventDelegate.h>
#import <GoogleMobileAds/DFPBannerView.h>
#import <GoogleMobileAds/GADBannerViewDelegate.h>

@protocol TAPPXNativeAdsDelegate;

@interface TAPPXNativeAds : UIViewController <GADBannerViewDelegate,GADAppEventDelegate>

- (TAPPXNativeAds*)requestNativeAds:(id <TAPPXNativeAdsDelegate> )theDelegate;
-(NSString*)getTitle;
-(UIImage*)getIcon;
-(UIImage*)getImageRate;
-(NSString*)getDescription;
-(float)getRate;
-(void)clickNativeAd;

@end

@protocol TAPPXNativeAdsDelegate

-(UIViewController*)presentViewController;

-(void)tappxDidFailToReceiveNativeAdWithError:(TAPPXRequestError *)error;

-(void)tappxDidReceiveNativeAd;
@end