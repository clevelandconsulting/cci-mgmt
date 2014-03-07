angular.module('app').controller 'testController', ['apiService', 'restFMAuthorization', '$scope', (apiService, auth, $scope) ->
  $scope.result = 'TESTING'
  username = 'Developer'
  password = 'letmein'

  fails = (data) =>
   auth.doLogin(username,password).then (response) =>
    $scope.result = "logged in: " + response
  passes = (response) =>
    $scope.result = response
  
  auth.allowedAccess().then passes, fails 
  
  
  
]