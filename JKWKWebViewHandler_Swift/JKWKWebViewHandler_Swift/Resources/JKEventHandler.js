var JKEventHandler ={

exec:function(plugin,funcName,params,successCallBack,failureCallBack){
    var message;
    var successCallBackID = plugin + '_' + funcName + '_' + 'successCallBack';
    var failureCallBackID = plugin + '_' + funcName + '_' + 'failureCallBack';
    if (successCallBack){
        if(!JKBridgeEvent._listeners[successCallBackID]){
            JKBridgeEvent.addEvent(successCallBackID, function(data){
                                   
                                   successCallBack(data);
                                   
                                   });
        }
    }
    
    if (failureCallBack){
        if(!JKBridgeEvent._listeners[failureCallBackID]){
            JKBridgeEvent.addEvent(failureCallBackID, function(data){
                                   
                                   failureCallBack(data);
                                   
                                   });
        }
    }
    
    if(successCallBack && failureCallBack){
        message = {'plugin':plugin,'func':funcName,'params':params,'successCallBackID':successCallBackID,'failureCallBackID':failureCallBackID};
        
    }else if(successCallBack && !failureCallBack){
        message = {'plugin':plugin,'func':funcName,'params':params,'successCallBackID':successCallBackID};
    }else if(failureCallBack && !successCallBack){
        message = {'plugin':plugin,'func':funcName,'params':params,'failureCallBackID':failureCallBackID};
    }
    else{
        message = {'plugin':plugin,'func':funcName,'params':params};
        
    }
    window.webkit.messageHandlers.JKEventHandler.postMessage(message);
},
    
callBack:function(callBackID,data){
    
    JKBridgeEvent.fireEvent(callBackID,data);
    
},
    
removeAllCallBacks:function(data){
    JKBridgeEvent._listeners ={};
}
    
};



var JKBridgeEvent = {
    
_listeners: {},
    
    
addEvent: function(type, fn) {
    if (typeof this._listeners[type] === "undefined") {
        this._listeners[type] = [];
    }
    if (typeof fn === "function") {
        this._listeners[type].push(fn);
    }
    
    return this;
},
    
    
fireEvent: function(type,param) {
    var arrayEvent = this._listeners[type];
    if (arrayEvent instanceof Array) {
        for (var i=0, length=arrayEvent.length; i<length; i+=1) {
            if (typeof arrayEvent[i] === "function") {
                arrayEvent[i](param);
            }
        }
    }
    
    return this;
},
    
removeEvent: function(type, fn) {
    var arrayEvent = this._listeners[type];
    if (typeof type === "string" && arrayEvent instanceof Array) {
        if (typeof fn === "function") {
            for (var i=0, length=arrayEvent.length; i<length; i+=1){
                if (arrayEvent[i] === fn){
                    this._listeners[type].splice(i, 1);
                    break;
                }
            }
        } else {
            delete this._listeners[type];
        }
    }
    
    return this;
}
};


