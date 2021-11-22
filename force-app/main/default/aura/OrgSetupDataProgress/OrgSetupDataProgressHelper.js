({

    executeAction: function(component, event, helper) {
    
        component.set('v.showSpinner', true);
        
        var action = component.get('c.executeAction'); 
        action.setParams({
            "requestMethod" : component.get('v.requestMethod'),
            "staticResourceName" : component.get('v.staticResourceName'),
            "staticResourceDateTime" : component.get('v.staticResourceDateTime'),
            "objectName" : component.get('v.objectName'),
            "fileName" : component.get('v.fileName')
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    subscribe: function (component, event, helper) {
        console.log('subscribe');
        
        const empApi = component.find('empApi');
        const channel = component.get('v.channel');
        const replayId = -1;

        const callback = function (message) {
            console.log('subscribe callback');
            helper.onReceiveNotification(component, event, helper, message);
        };

        empApi.subscribe(channel, replayId, $A.getCallback(callback)).then($A.getCallback(function (newSubscription) {
            console.log('Subscribed to channel ' + channel);
            component.set('v.subscription', newSubscription);
        }));
    },

    unsubscribe: function (component, event, helper) {
        console.log('unsubscribe');
        
        const empApi = component.find('empApi');
        const channel = component.get('v.subscription').channel;
        const callback = function (message) {
            console.log('unsubscribe callback');
        };
        empApi.unsubscribe(component.get('v.subscription'), $A.getCallback(callback));
    },

    onReceiveNotification: function (component, event, helper, message) {
        console.log('onReceiveNotification');
        console.log(message);
        
        if (message.data.payload.Request_Method__c == component.get('v.requestMethod') 
            	&& message.data.payload.Object__c == component.get('v.objectName')) {
        	helper.addMessage(component, event, helper, message.data.payload.Message__c);
            if (message.data.payload.Complete__c == true) {
                component.set('v.showSpinner', false);
            }
        }
    },

    addMessage: function(component, event, helper, message) {
        console.log('addMessage');
        
        const messages = component.get('v.messages');
        messages.push(message);
        component.set('v.message', messages.join('\r\n'));
        console.log(messages.join('\r\n'));
    }
    
})