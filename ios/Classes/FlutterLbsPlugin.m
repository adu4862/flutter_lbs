#import "FlutterLbsPlugin.h"
#if __has_include(<flutter_lbs/flutter_lbs-Swift.h>)
#import <flutter_lbs/flutter_lbs-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_lbs-Swift.h"
#endif

@implementation FlutterLbsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLbsPlugin registerWithRegistrar:registrar];
}
@end
