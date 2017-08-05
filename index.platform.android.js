const ReactNativeGtmAndroid = {
    openContainerWithId : function(Module, containerId, debug = false, defaultContainerName = '') {
        return Module.openContainerWithId(containerId, defaultContainerName, debug);
    },
}

export default ReactNativeGtmAndroid;
