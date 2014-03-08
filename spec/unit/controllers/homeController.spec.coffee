describe "homeController", ->
 Given -> module('app')
 Given inject ($controller, $rootScope) ->
  @scope = $rootScope.$apply()
  @subject = $controller 'homeController', {$scope:@scope}
  
 Then -> expect(@subject).toBeDefined()