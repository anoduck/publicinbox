function DraftController($scope, $location, messages, draft) {
  this.$scope = $scope;
  this.$location = $location;
  this.messages = messages;
  this.draft = draft;

  this.loadContacts();
}

DraftController.$inject = ['$scope', '$location', 'messages', 'draft'];

DraftController.prototype.loadContacts = function loadContacts() {
  var $scope = this.$scope;

  this.messages.load().then(function(messages) {
    $scope.contacts = messages.contacts;
  });
};

DraftController.prototype.addCc = function addCc() {
  this.draft.addCc();
};

DraftController.prototype.sendMessage = function sendMessage(message) {
  if (!message.body) {
    if (!confirm('Really send a message without a body?')) {
      return;
    }

  } else if (!message.subject) {
    if (!confirm('Really send a message without a subject?')) {
      return;
    }
  }

  var $scope = this.$scope,
      $location = this.$location,
      messages = this.messages,
      draft = this.draft;

  this.messages.sendMessage(message).then(
    function(response) {
      $scope.displayNotice('Message successfully sent.');
      messages.addMessage(response);
      $location.path('/ui/mailbox');

      // And now we should clear the draft so it isn't still there when the
      // user clicks on 'Compose' again.
      draft.clear();
    },
    function(response) {
      $scope.displayNotice(response, 'error');
    }
  );
};
