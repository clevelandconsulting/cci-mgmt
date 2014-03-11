class apiService
  constructor: ($http) -> 
   @url = '' 
   @credentials = ''
   @http = $http
   #@http({method: 'GET', url: @url + "?RFMkey=cci-developer"})
   
  setUrl: (@url) ->
  
  setCredentials: (@credentials) ->
  
  clearCredentials: -> @credentials = ''
  
  setHeader: (name,value) ->
   @http.defaults.headers.common[name] = value
  setAuth: ->
   if @credentials != ''
    @setHeader('Authorization', 'Basic ' + @credentials) 
  
  get:(path) ->
   @setAuth()
   path = path || ''
   @http({method: 'GET', url:@url+path})
   
  checkCredentials: (credentials) ->
   @setHeader('Authorization', 'Basic ' + credentials)
   @http({method: 'GET', url: @url})  


angular.module('app').factory 'apiService', -> apiService # ['$http', ($http) -> new apiService($http) ]
