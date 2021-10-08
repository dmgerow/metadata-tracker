({
  doGeneratePackageXml: function (component) {
    component.set("v.buttonDisabled", true);
    var action = component.get("c.generatePackageXml");
    var requestModel = {
      lowerBound: component.get("v.lowerBound"),
      upperBound: component.get("v.upperBound"),
      context: component.get("v.context")
    };
    var requestString = JSON.stringify(requestModel);
    console.log(requestString);
    action.setParams({
      request: requestString
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        this.doFireToastEvent("Package generated", "success");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          url:
            "/sfc/servlet.shepherd/version/download/" +
            response.getReturnValue()
        });
        urlEvent.fire();
        this.doClosePackageGenerator(component);
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log(errors[0].message);
            this.doFireToastEvent(errors[0].message, "error");
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
      mode: "dismissible",
      message: message
    });
    toastEvent.fire();
  },
  doClosePackageGenerator: function (component) {
    var closeEvent = component.getEvent("closePackageGeneratorEvent");
    closeEvent.fire();
  }
});
