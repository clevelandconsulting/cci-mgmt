angular.module('app').controller 'testController', ['apiService', '$scope', (apiService, $scope) ->
  $scope.result = 'TESTING'
  apiService.setUrl('https://fms.clevelandconsulting.com/RESTfm/CCI_Mgmt/')
  username = 'Developer'
  password = 'letmein'
  credentials = Base64.encode username + ':' + password
  
  apiService.checkCredentials(credentials).success (data, status, headers, config) =>
    $scope.result = data.data
    console.log data
   .error (data, status, headers, config) =>
    $scope.result = data
    console.log data
]