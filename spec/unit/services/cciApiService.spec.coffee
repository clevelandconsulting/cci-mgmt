describe "cciApiService", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, $http, _apiService_) ->
  @mockApiService = _apiService_
  @http = $http
  @injector = $injector
  @expectedObject = new @mockApiService()
  @expectedObject.url = 'https://fms.clevelandconsulting.com/RESTfm/STEVE/'
  @expectedObject.http = @http
  
 When -> @subject = @injector.get 'cciApiService', { $http:@http, apiService:@mockApiService}
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject).toEqual(@expectedObject)
 Then -> expect(@subject.url).toEqual('https://fms.clevelandconsulting.com/RESTfm/STEVE/')
 