#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#if OS_OBJECT_USE_OBJC
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kTappx_ReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    Tappx_NotReachable = 0,
    Tappx_ReachableViaWiFi = 2,
    Tappx_ReachableViaWWAN = 1
};

@class Tappx_Reachability;

typedef void (^NetworkReachable)(Tappx_Reachability * reachabilityTappx);
typedef void (^NetworkUnreachable)(Tappx_Reachability * reachabilityTappx);

@interface Tappx_Reachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlockTappx;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlockTappx;


@property (nonatomic, assign) BOOL reachableOnWWANTappx;

+(Tappx_Reachability*)Tappx_reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(Tappx_Reachability*)Tappx_reachabilityWithHostName:(NSString*)hostname;
+(Tappx_Reachability*)Tappx_reachabilityForInternetConnection;
+(Tappx_Reachability*)Tappx_reachabilityWithAddress:(const struct sockaddr_in*)hostAddress;
+(Tappx_Reachability*)Tappx_reachabilityForLocalWiFi;

-(Tappx_Reachability *)initWithReachabilityRefTappx:(SCNetworkReachabilityRef)ref;

-(BOOL)Tappx_startNotifier;
-(void)Tappx_stopNotifier;

-(BOOL)Tappx_isReachable;
-(BOOL)Tappx_isReachableViaWWAN;
-(BOOL)Tappx_isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)Tappx_isConnectionRequired; // Identical DDG variant.
-(BOOL)Tappx_connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)Tappx_isConnectionOnDemand;
// Is user intervention required?
-(BOOL)Tappx_isInterventionRequired;

-(NetworkStatus)Tappx_currentReachabilityStatus;
-(SCNetworkReachabilityFlags)Tappx_reachabilityFlags;
-(NSString*)Tappx_currentReachabilityString;
-(NSString*)Tappx_currentReachabilityFlags;

@end
