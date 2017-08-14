#import <Foundation/Foundation.h>
#import "react_native_gtm.h"
#import "TAGDataLayer.h"

@interface react_native_gtm ()<TAGContainerOpenerNotifier>

@property (nonatomic, copy) RCTPromiseResolveBlock resolveBlock;

@end

@implementation react_native_gtm {
	TAGContainer *mTAGContainer;
	TAGManager *mTagManager;
}

RCT_EXPORT_MODULE(ReactNativeGtm);

@synthesize methodQueue = _methodQueue;

RCT_EXPORT_METHOD(openContainerWithId:(NSString *)containerId
				  debug:(BOOL)debug
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (mTAGContainer != nil  && [mTAGContainer.containerId isEqualToString:containerId]) {
        [mTAGContainer refresh];
        reject(@"GTM-openContainerWithId():", nil, RCTErrorWithMessage(@"The container is already open."));
        return;
    }
    
    if (self.resolveBlock) {
        reject(@"GTM-openContainerWithId():", nil, RCTErrorWithMessage(@"The Container is opening."));
        return;
    }
    mTagManager = [TAGManager instance];
	mTagManager.logger.logLevel = debug ? kTAGLoggerLogLevelVerbose : kTAGLoggerLogLevelError;

    self.resolveBlock = resolve;
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
		@try {
			if ([data isKindOfClass:[NSDictionary class]]) {
				[mTagManager.dataLayer push:data];
			} else {
        		reject(@"GTM-push():", nil, RCTErrorWithMessage(@"You can only push an object."));
			}
		}
		@catch(NSException *e) {
        	reject(@"GTM-push():", nil, RCTErrorWithMessage(e.reason));
		}
    } else {
        reject(@"GTM-push():", nil, RCTErrorWithMessage(@"The container has not be opened."));
    }
}

- (void)containerAvailable:(TAGContainer *)container {
    dispatch_async(_methodQueue, ^{
        mTAGContainer = container;
        self.resolveBlock(@YES);
        self.resolveBlock = nil;
    });
}

@end
