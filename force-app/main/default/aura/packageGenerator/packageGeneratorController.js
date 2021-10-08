({
  doGeneratePackageXml: function (component, event, helper) {
    helper.doGeneratePackageXml(component);
  },
  doClosePackageGenerator: function (component, event, helper) {
    helper.doClosePackageGenerator(component);
  },
  doValidateInputs: function (component, event, helper) {
    var buttonDisabled = false;
    switch (component.get("v.context")) {
      case "all":
        buttonDisabled = false;
        break;
      case "date":
        if (!(component.get("v.lowerBound") && component.get("v.upperBound"))) {
          buttonDisabled = true;
        }
        break;
    }
    component.set("v.buttonDisabled", buttonDisabled);
  }
});
