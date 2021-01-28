var JKEventHandler ={

exec:function(plugin,funcName,params,successCallBack,failureCallBack){
    var message;
    var timeStamp = new Date().getTime();
    var successCallBackID = plugin + '_' + funcName + '_' + timeStamp + '_' + 'successCallBack';
    var failureCallBackID = plugin + '_' + funcName + '_' + timeStamp + '_' + 'failureCallBack';
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
    JKBridgeEvent.removeEvent(callBackID);
},
    
removeAllCallBacks:function(data){
    JKBridgeEvent._listeners ={};
}
    
};




var JKBridgeEvent = {
    
_listeners: {},
    
addEvent: function(callBackID, fn) {
    this._listeners[callBackID] = fn;
    return this;
},
    
    
fireEvent: function(callBackID,param) {
    var fn = this._listeners[callBackID];
    if (typeof callBackID === "string" && typeof fn === "function") {
        fn(param);
    } else {
       delete this._listeners[callBackID];
    }
    return this;
},
    
removeEvent: function(callBackID) {
   delete this._listeners[callBackID];
    return this;
}
};


