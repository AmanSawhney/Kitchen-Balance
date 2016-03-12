//
//  TAPPXUtilsInterns.h
//  
//  Created by Tappx on 16/10/14.
//
//

#import <Foundation/Foundation.h>

@interface TAPPXUtilsInterns : NSObject

- (void)createInfo;

+ (BOOL)requestUpdate;
+ (BOOL)versionAdmob:(NSString*)p_sdkVersion;
+ (NSArray*)mediationTargeting:(NSMutableDictionary*)mud adUnit:(NSString*)adUnit;

@end
