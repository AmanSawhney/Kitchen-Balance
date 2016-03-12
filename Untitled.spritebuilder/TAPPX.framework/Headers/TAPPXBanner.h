//
//  TAPPXBanner.h
//
//  Created by Tappx on 24/12/13.
//
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADBannerViewDelegate.h>
#import "TAPPXBannerView.h"
#import "TAPPXRequestError.h"

@protocol TAPPXBannerDelegate;

@interface TAPPXBanner : TAPPXBannerView<GADBannerViewDelegate>

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) TAPPXBannerView* TappxBanner;
@property float timer;

-(TAPPXBannerView*)createBanner:(id <TAPPXBannerDelegate> )theDelegate positionBanner:(CGPoint)position;
-(TAPPXBannerView*)createBanner:(id <TAPPXBannerDelegate> )theDelegate positionBanner:(CGPoint)position timer:(float)timer;

-(TAPPXBannerView*)createCustom:(id <TAPPXBannerDelegate> )theDelegate;

@end

@protocol TAPPXBannerDelegate <GADBannerViewDelegate>

-(UIViewController*)presentViewController;

@optional

- (UIView*)presentView;

- (void)tappxViewDidReceiveAd:(TAPPXBannerView *)view;

- (void)tappxView:(TAPPXBannerView *)view didFailToReceiveAdWithError:(TAPPXRequestError *)error;

- (void)tappxBannerDisappear:(TAPPXBannerView*)tappxBanner;

- (void)tappxViewWillPresentScreen:(TAPPXBannerView *)adView;

- (void)tappxViewWillDismissScreen:(TAPPXBannerView *)adView;

- (void)tappxViewDidDismissScreen:(TAPPXBannerView *)adView;

- (void)tappxViewWillLeaveApplication:(TAPPXBannerView *)adView;

@end