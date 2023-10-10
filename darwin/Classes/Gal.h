//
//  Gal.h
//  gal
//
//  Created by liyuanbo on 2023/10/10.
//

#if TARGET_OS_IOS
#import <Flutter/Flutter.h>
#else
#import <FlutterMacOS/FlutterMacOS.h>
#endif

@interface Gal : NSObject <FlutterPlugin>

@end

