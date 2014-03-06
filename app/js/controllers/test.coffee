angular.module('app').controller 'testController', ['apiService', '$scope', (apiService, $scope) ->
  $scope.result = apiService.result
]