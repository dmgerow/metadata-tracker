({
    doSubmitFeedback: function (component) {
        component.set("v.buttonDisabled", true);
        var action = component.get("c.sendFeedback");
        var requestModel = {
            "body": component.get("v.body")
        };
        var requestString = JSON.stringify(requestModel);
        console.log(requestString);
        action.setParams({
            "request": requestString
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.doFireToastEvent('Feedback submitted', 'success');
                this.doCloseFeedback(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        this.doFireToastEvent(errors[0].message, 'error');
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.buttonDisabled", false);
        });
        $A.enqueueAction(action);
    },
    doFireToastEvent: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type,
            mode: 'dismissible',
            message: message
        });
        toastEvent.fire();
    },
    doCloseFeedback: function (component) {
        var closeEvent = component.getEvent("closeFeedback");
        closeEvent.fire();
    }
})
