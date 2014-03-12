angular.module('app').controller 'testController', ['userRepository', 'authorizationService', '$scope', (user, auth, $scope) ->
  $scope.result = 'TESTING'
  username = 'Developer'
  password = 'letmein'
  
  #user.getUser(username).then (response) =>
  # $scope.result = response


  auth.doLogin(username,password).then (response) =>
    user.getUser(username).then (response) =>
     $scope.result = response

  
  
]