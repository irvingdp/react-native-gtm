#import <Foundation/Foundation.h>
#import "react_native_gtm.h"
#import "TAGContainer.h"
#import "TagContainerOpener.h"
#import "TAGDataLayer.h"

@interface react_native_gtm ()<TAGContainerOpenerNotifier>
@end

@implementation react_native_gtm {
    
}

RCT_EXPORT_MODULE(ReactNativeGtm);

@synthesize methodQueue = _methodQueue;

static TAGContainer *mTAGContainer;
static TAGManager *mTagManager;

RCT_EXPORT_METHOD(openContainerWithId:(NSString *)containerId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (mTAGContainer != nil) {
        reject(@"GTM-openContainerWithId():", nil, RCTErrorWithMessage(@"The container is already open."));
        return;
    }
    
    if (self.isOpeningContainer) {
        reject(@"GTM-openContainerWithId():", nil, RCTErrorWithMessage(@"The Container is opening."));
        return;
    }
    
    if (mTagManager == nil) {
        mTagManager = [TAGManager instance];
    }
    
    self.isOpeningContainer = resolve;
    
    [TAGContainerOpener openContainerWithId:containerId
                                 tagManager:mTagManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:nil
                                   notifier:self];
}

RCT_EXPORT_METHOD(push:(NSDictionary *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (mTagManager != nil) {
        [mTagManager.dataLayer push:data];
    } else {
        reject(@"GTM-push():", nil, RCTErrorWithMessage(@"The container has not be opened."));
    }
}

- (void)containerAvailable:(TAGContainer *)container {
    dispatch_async(_methodQueue, ^{
        mTAGContainer = container;
        self.isOpeningContainer(@YES);
        self.isOpeningContainer = nil;
    });
}

@end
