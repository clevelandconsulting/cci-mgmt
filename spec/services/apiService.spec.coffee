describe "apiService", ->
 Given -> module('app')
 Given ->
  @url = "https://fms.clevelandconsulting.com/RESTfm/"
  @username = "Developer"
  @password = ""
  
 Given inject ($injector, $http, $httpBackend) ->
  @http = $http
  @httpBackend = $httpBackend;
  
 When ->
  @http.defaults.headers.common = {
   "Access-Control-Request-Headers": "accept, origin, authorization"};
  @http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode @username + ':' + @password
  
  @http({method: 'GET', url: @url}).
   success (data, status, headers, config) =>
    @result = data
    console.log data
   .error (data, status, headers, config) =>
    console.log data
  
  #@httpBackend.flush()
  
 Then -> expect(@result).toEqual({})