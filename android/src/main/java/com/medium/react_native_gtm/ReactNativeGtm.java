package com.medium.react_native_gtm;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.tagmanager.ContainerHolder;
import com.google.android.gms.tagmanager.TagManager;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

public class ReactNativeGtm extends ReactContextBaseJavaModule{

    private static TagManager mTagManager;
    private static ContainerHolder mContainerHolder;
    private Boolean isOpeningContainer = false;

    public ReactNativeGtm(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ReactNativeGtm";
    }

    @ReactMethod
    public void openContainerWithId(final String containerId, final boolean debug, final Promise promise){
        if (this.mContainerHolder != null && this.mContainerHolder.getContainer().getContainerId().equals(containerId)) {
            promise.reject("GTM-openContainerWithId():", new Throwable("The container is already open."));
            return;
        }

        if (isOpeningContainer) {
            promise.reject("GTM-openContainerWithId():", new Throwable("The Container is opening."));
            return;
        }

        mTagManager = TagManager.getInstance(getReactApplicationContext());
		mTagManager.setVerboseLoggingEnabled(debug);

        isOpeningContainer = true;
        PendingResult<ContainerHolder> pending = mTagManager.loadContainerPreferFresh(containerId, -1);
        pending.setResultCallback(new ResultCallback<ContainerHolder>() {
            @Override
            public void onResult(ContainerHolder containerHolder) {
                if (containerHolder != null && containerHolder.getStatus().isSuccess()) {
                    mContainerHolder = containerHolder;
                    promise.resolve(true);
                } else {
                    promise.reject("GTM-openContainerWithId():", new Throwable(String.format("Failed to open container id:", containerId)));
                }
                isOpeningContainer = false;
            }
        }, 2000, TimeUnit.MILLISECONDS);
    }

    @ReactMethod
    public void push(ReadableMap values, final Promise promise){
        if (this.mTagManager != null && this.mTagManager.getDataLayer() != null) {
			if (values instanceof ReadableNativeMap) {
				ReadableNativeMap nativeMap = (ReadableNativeMap) values;
            	this.mTagManager.getDataLayer().push(nativeMap.toHashMap());
            	promise.resolve("success");
			} else {
            	promise.reject("GTM-push():", new Throwable("You can only push objects."));
			}
        }else{
            promise.reject("GTM-push():", new Throwable("The container has not be opened."));
        }
    }
}
