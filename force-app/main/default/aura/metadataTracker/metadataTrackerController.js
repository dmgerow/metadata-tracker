({
  doInit: function (component, event, helper) {
    helper.doSetSpinner(component, true);
    helper.doSetColumns(component);

    var action = component.get("c.getSettings");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var settings = JSON.parse(response.getReturnValue());
        component.set("v.settings", settings);
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
    });

    window.addEventListener(
      "message",
      function (event) {
        var settings = component.get("v.settings");
        if (event.data.type == "global") {
          var responseObject = event.data.data;
          component.set("v.metadataTypes", responseObject.sort());
          helper.doSetSpinner(component, false);
        } else if (event.data.type == "single") {
          if (
            settings &&
            event.data.data &&
            event.data.data.length > settings.MaxResultSize__c
          ) {
            console.log(
              "Request too large to send to controller: " +
                event.data.data.length
            );
            component.set("v.sizeLimitReached", true);
            helper.doListSingle(component, JSON.stringify(event.data.data));
          } else {
            helper.doDescribeSingle(component, JSON.stringify(event.data.data));
          }
        }
      },
      false
    );

    $A.enqueueAction(action);
  },
  doDescribeSingle: function (component, event, helper) {
    component.set("v.sizeLimitReached", false);
    helper.doSetSpinner(component, true);
    var metadataTypes = component.get("v.metadataTypes");
    component.set(
      "v.metadataTypes",
      metadataTypes.filter((type) => type !== "--Select Metadata Type--")
    );
    var message = component.get("v.selectedMetadataType");
    var vfWindow = component.find("vfFrame").getElement().contentWindow;
    vfWindow.postMessage(message, "*");
  },
  handleRowAction: function (component, event, helper) {
    var action = event.getParam("action");
    var row = event.getParam("row");
    switch (action.name) {
      case "track":
      case "untrack":
      case "destroy":
        helper.doUpdateTrackedMetadata(component, row, action.name);
        break;
    }
  },
  doSearch: function (component, event, helper) {
    if (event.keyCode === 13 || !component.find("search-bar").get("v.value")) {
      helper.doSearch(component);
    }
  },
  doUpdateColumnSorting: function (component, event, helper) {
    var fieldName = event.getParam("fieldName");
    var sortDirection = event.getParam("sortDirection");
    component.set("v.sortedBy", fieldName);
    component.set("v.sortedDirection", sortDirection);
    helper.doSortData(component, fieldName, sortDirection);
  },
  doShowPackageGenerator: function (component, event, helper) {
    component.set("v.showPackageGenerator", true);
  },
  doClosePackageGenerator: function (component, event, helper) {
    component.set("v.showPackageGenerator", false);
  },
  doShowFeedback: function (component, event, helper) {
    component.set("v.showFeedback", true);
  },
  doCloseFeedback: function (component, event, helper) {
    component.set("v.showFeedback", false);
  }
});
