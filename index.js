"use strict";

import { NativeModules } from 'react-native';
const RCTGtm = NativeModules.ReactNativeGtm;

const ReactNativeGtm = {
     /**
     * Creating a ContainerHolder Singleton
     * @param {String} containerId
     * @param {Bool} debug
     */
    openContainerWithId : function(containerId, debug = false) {
        return RCTGtm ? RCTGtm.openContainerWithId(containerId, debug) : new Promise((resolve, reject) => {
            reject(new Error('RCTGtm not found'));
        });
    },
    /**
     * <p>This is normally a synchronous call.
     * However, if, while the thread is executing the push, another push happens
     * from the same thread, then that second push is asynchronous (the second push
     * will return before changes have been made to the data layer).  This second
     * push from the same thread can occur, for example, if a data layer push is
     * made in response to a tag firing. However, all updates will be processed
     * before the outermost push returns.
     * <p>If the object contains the key <code>event</code>, rules
     * will be evaluated and matching tags will fire.
     *
     * @param {String}object The object to process
     */
    push : function(object) {
        if (typeof object === 'object' && !Array.isArray(object)) {
            return RCTGtm.push(object);
        } else {
            return Promise.reject("You must push an object, not an array or a primitive.");
      }
    }

}

module.exports = ReactNativeGtm;
