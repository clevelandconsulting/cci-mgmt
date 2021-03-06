class apiService
  constructor: ($http, @q) -> 
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
    @setHeader('Authorization', 'Basic ' + @credentials.auth) 
  
  isAvailable: ->
   d = @q.defer()
   @get()
   .then (response) =>
    #console.log 'get response', response
    d.resolve true
   .catch (response) =>
    #console.log 'get catch', response
    if response.data.data? && response.data.info && response.data.meta
     d.resolve true
    else
     d.reject response
     
   d.promise
  
  prepCall: (path)->
   @setAuth()
   path = path || ''
   path
  
  get:(path) ->
   path = @prepCall path
   @http({method: 'GET', url:@url+path})
   
  checkCredentials: (credentials) ->
   @setHeader('Authorization', 'Basic ' + credentials.auth)
   @http({method: 'GET', url: @url})  
   
  put:(path,object) ->
   path = @prepCall path
   @http({method: 'PUT', url:@url+path, data:object})
   
  post:(path,object) ->
   path = @prepCall path
   @http({method: 'POST', url:@url+path, data:object})
   
  delete:(path) ->
   path = @prepCall path
   @http({method: 'DELETE',url:@url+path})


angular.module('app').factory 'apiService', -> apiService # ['$http', ($http) -> new apiService($http) ]
