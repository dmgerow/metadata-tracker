({
  doSetColumns: function (component) {
    component.set("v.columns", [
      {
        label: "Add",
        sortable: false,
        initialWidth: 50,
        type: "button-icon",
        typeAttributes: {
          name: "track",
          title: "track",
          disabled: { fieldName: "trackDisabled" },
          value: "track",
          iconName: { fieldName: "trackIcon" },
          variant: "bare"
        }
      },
      {
        label: "Rem",
        sortable: false,
        initialWidth: 50,
        type: "button-icon",
        typeAttributes: {
          name: "untrack",
          title: "untrack",
          disabled: { fieldName: "untrackDisabled" },
          value: "untrack",
          iconName: "utility:close",
          variant: "bare"
        }
      },
      { label: "Name", fieldName: "name", type: "text", sortable: true },
      {
        label: "Del",
        sortable: false,
        initialWidth: 50,
        type: "button-icon",
        typeAttributes: {
          name: "destroy",
          title: "destroy",
          disabled: { fieldName: "destroyDisabled" },
          value: "destroy",
          iconName: "utility:delete",
          variant: "bare"
        }
      }
    ]);
  },
  doDescribeSingle: function (component, data) {
    this.doSetSpinner(component, true);
    var action = component.get("c.describeSingle");
    console.log(data);
    action.setParams({ filePropertyString: data });
    if (component.find("search-bar")) {
      component.find("search-bar").set("v.value", "");
    }
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var reponseObject = JSON.parse(response.getReturnValue());
        reponseObject.files.sort(this.doSortBy("name", 0));
        component.set("v.metadataFiles", reponseObject.files);
        component.set("v.totalResultLength", reponseObject.files.length);
        component.set(
          "v.filteredFiles",
          reponseObject.files.slice(0, component.get("v.maxResultLength"))
        );
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log(errors[0].message);
            this.doFireToastEvent(errors[0].message, "error");
            component.set("v.metadataFiles", []);
            component.set("v.filteredFiles", []);
          }
        } else {
          console.log("Unknown error");
        }
      }
      this.doSetSpinner(component, false);
    });

    $A.enqueueAction(action);
  },
  doListSingle: function (component, data) {
    this.doSetSpinner(component, true);
    if (component.find("search-bar")) {
      component.find("search-bar").set("v.value", "");
    }
    var reponseObject = JSON.parse(data);
    for (var i = 0; i < reponseObject.length; i++) {
      reponseObject[i]["name"] = reponseObject[i].fullName;
      reponseObject[i]["externalKey"] =
        reponseObject[i].type + "|" + reponseObject[i].fullName;
      reponseObject[i]["trackDisabled"] = false;
      reponseObject[i]["trackIcon"] = "utility:add";
      reponseObject[i]["untrackDisabled"] = false;
      reponseObject[i]["destroyDisabled"] = false;
    }
    reponseObject.sort(this.doSortBy("name", 0));
    component.set("v.metadataFiles", reponseObject);
    component.set("v.totalResultLength", reponseObject.length);
    component.set(
      "v.filteredFiles",
      reponseObject.slice(0, component.get("v.maxResultLength"))
    );
    this.doSetSpinner(component, false);
  },
  doUpdateTrackedMetadata: function (component, eventRow, type) {
    var action = component.get("c.updateTrackedMetadata");
    action.setParams({
      fileString: JSON.stringify(eventRow),
      type: type
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        switch (type) {
          case "track":
            this.doSetButtons(
              eventRow,
              component,
              false,
              false,
              false,
              "utility:check"
            );
            break;
          case "untrack":
            this.doSetButtons(
              eventRow,
              component,
              false,
              true,
              false,
              "utility:add"
            );
            break;
          case "destroy":
            this.doSetButtons(
              eventRow,
              component,
              false,
              false,
              true,
              "utility:add"
            );
            break;
        }
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
    $A.enqueueAction(action);
  },
  doSetSpinner: function (component, enabled) {
    component.set("v.loading", enabled);
  },
  doSortData: function (component, fieldName, sortDirection) {
    var data = component.get("v.filteredFiles");
    var reverse = sortDirection !== "asc";
    data.sort(this.doSortBy(fieldName, reverse));
    component.set("v.filteredFiles", data);
  },
  doSortBy: function (field, reverse, primer) {
    var key = primer
      ? function (x) {
          return primer(x[field]);
        }
      : function (x) {
          return x[field];
        };
    reverse = !reverse ? 1 : -1;
    return function (a, b) {
      return (a = key(a)), (b = key(b)), reverse * ((a > b) - (b > a));
    };
  },
  doSearch: function (component) {
    this.doSetSpinner(component, true);
    var rows = component.get("v.metadataFiles");
    var searchTerm = component.find("search-bar").get("v.value");
    var filteredRows = rows;
    if (searchTerm) {
      var options = {
        shouldSort: true,
        threshold: 0.6,
        location: 0,
        distance: 100,
        maxPatternLength: 32,
        minMatchCharLength: 1,
        keys: ["name"]
      };
      var fuse = new Fuse(rows, options); // "list" is the item array
      filteredRows = fuse.search(searchTerm);
    }
    component.set("v.totalResultLength", filteredRows.length);
    component.set(
      "v.filteredFiles",
      filteredRows.slice(0, component.get("v.maxResultLength"))
    );
    this.doSetSpinner(component, false);
  },
  doSetButtons: function (
    eventRow,
    component,
    trackDisabled,
    untrackDisabled,
    destroyDisabled,
    trackIcon
  ) {
    var rows = component.get("v.filteredFiles");
    var rowIndex = this.doGetIndexOf(rows, eventRow, "name");
    console.log("Setting buttons on row", rowIndex);
    if (rowIndex > -1) {
      rows[rowIndex]["trackDisabled"] = trackDisabled;
      rows[rowIndex]["trackIcon"] = trackIcon;
      rows[rowIndex]["untrackDisabled"] = untrackDisabled;
      rows[rowIndex]["destroyDisabled"] = destroyDisabled;
    } else {
      console.error("Matching row not found in doSetButtons.");
    }
    component.set("v.filteredFiles", rows);
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
  doGetIndexOf: function (array, object, property) {
    for (var i = 0; i < array.length; i++) {
      if (array[i][property] == object[property]) {
        return i;
      }
    }
    return -1;
  }
});
