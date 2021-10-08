({
  doCloseFeedback: function (component) {
    var closeEvent = component.getEvent("closeFeedback");
    closeEvent.fire();
  }
});
