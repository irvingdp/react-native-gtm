#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "TAGContainer.h"
#import "TagContainerOpener.h"
#import "TAGManager.h"
#import "RCTUtils.h"

@interface react_native_gtm : NSObject <RCTBridgeModule>

@property (nonatomic, copy) RCTPromiseResolveBlock isOpeningContainer;

@end
