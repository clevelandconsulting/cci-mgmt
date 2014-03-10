describe "restFmAuthorization", ->
 Given -> module('app')
 
 Given angular.mock.inject (authorizationService) ->
  @mockAuthorizationService = authorizationService
 
 Given inject ($injector) ->
  @subject = $injector.get 'restFMAuthorization', {authorizationService:@mockAuthorizationService}
  
 Then -> expect(@subject).toBeDefined()