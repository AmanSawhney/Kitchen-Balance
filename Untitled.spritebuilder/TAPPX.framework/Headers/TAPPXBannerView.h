//
//  TAPPXBannerView.h
//
//  Created by Tappx on 27/12/13.
//
//

#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADBannerViewDelegate.h>

@interface TAPPXBannerView : GADBannerView<GADBannerViewDelegate>

@property (nonatomic, strong) NSTimer *durationTimer; //Minimum 15 seconds
@property (nonatomic, strong) GADBannerView *gadBanner;
@property (nonatomic, strong) id del;
@property bool animation;

@end
