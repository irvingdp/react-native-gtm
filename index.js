"use strict";

import { NativeModules } from 'react-native';

var RCTGtm = NativeModules.ReactNativeGtm;

var ReactNativeGtm = {
     /**
     * Creating a ContainerHolder Singleton
     * @param {String} containerId
     */
    openContainerWithId : function(containerId) {
        return RCTGtm.openContainerWithId(containerId);
    },
    /**
     * Merges the given <code>json</code> object into the existing data model,
     * calling any listeners with the json (after the merge occurs).
     *
     * <p>It's valid for values in the dictionary (or embedded Arrays) to be
     * of type <code>null</code>.
     *
     * <p>This is normally a synchronous call.
     * However, if, while the thread is executing the push, another push happens
     * from the same thread, then that second push is asynchronous (the second push
     * will return before changes have been made to the data layer).  This second
     * push from the same thread can occur, for example, if a data layer push is
     * made in response to a tag firing. However, all updates will be processed
     * before the outermost push returns.
     * <p>If the <code>json</code> contains the key <code>event</code>, rules
     * will be evaluated and matching tags will fire.
     *
     * @param {String}json The json object to process
     */
    push : function(json) {
        return RCTGtm.push(json);
    }

}

module.exports = ReactNativeGtm;
