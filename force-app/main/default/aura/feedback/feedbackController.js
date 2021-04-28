({
    doSubmitFeedback: function (component, event, helper) {
        helper.doSubmitFeedback(component);
    },
    doCloseFeedback: function (component, event, helper) {
        helper.doCloseFeedback(component);
    },
    doValidateBody: function (component, event, helper) {
        if (component.get("v.body")) {
            component.set("v.buttonDisabled",false);
        } else {
            component.set("v.buttonDisabled", true);
        }
    }
})
