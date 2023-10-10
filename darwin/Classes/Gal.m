//
//  Gal.m
//  gal
//
//  Created by liyuanbo on 2023/10/10.
//

#import "Gal.h"

#if __has_include(<Gal/Gal-Swift.h>)
#import <Gal/Gal-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gal-Swift.h"
#endif

@implementation Gal

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    [GalPlugin registerWithRegistrar:registrar];
}

@end
