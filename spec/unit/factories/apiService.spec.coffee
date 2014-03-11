describe "apiService", ->

 Given -> module('app')

 Given inject ($injector, $http, $httpBackend, $rootScope) ->
  @url = "https://fms.clevelandconsulting.com/RESTfm/"
  @http = $http
  @httpBackend = $httpBackend
  @rootScope = $rootScope
  @api = $injector.get 'apiService'
  @subject = new @api($http)
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.credentials).toBe('')
 
 describe "clearCredentials() with some credentials", ->
  Given -> @subject.credentials = 'something'
  When -> @subject.clearCredentials()
  Then -> expect(@subject.credentials).toBe('')
 
 describe "clearCredentials() with no credentials", ->
  Given -> @subject.credentials = ''
  When -> @subject.clearCredentials()
  Then -> expect(@subject.credentials).toBe('')
 
 
 describe "setUrl()", ->
  When -> @subject.setUrl(@url)
  Then -> expect(@subject.url).toBe(@url)
  
 describe "setHeader()", ->
  When -> @subject.setHeader('Authorization', 'foo')
  Then -> expect(@http.defaults.headers.common['Authorization']).toBe 'foo'
 
 describe "get()", ->
  Given -> 
   @url = 'http://someurl/'
   @subject.url = @url
   
   
  describe "with no path provided", ->
   Given -> 
    @httpBackend.whenGET(@url).respond('foo')

   When ->   
    @subject.get()
    @httpBackend.flush()
    
   Then -> @httpBackend.expectGET(@url) 

  describe "with a path provided", ->
   Given ->
    @path = 'foo/'
    @httpBackend.whenGET(@url+@path).respond('foo') 
  
   describe "with no credentials" , ->
   
    When -> 
     @subject.get(@path)
     @httpBackend.flush()
    
    Then -> @httpBackend.expectGET(@url+@path)
    Then -> expect(@http.defaults.headers.common['Authorization']).not.toBeDefined()
   
   describe "with credentials" , ->
    
    When -> 
     @creds = 'foo'
     @subject.setCredentials @creds
     @subject.get @path 
     @httpBackend.flush()
    
    Then -> @httpBackend.expectGET(@url+@path)
    Then -> expect(@http.defaults.headers.common['Authorization']).toEqual('Basic ' + @creds)
   
 describe "checkCredentials()", ->
  Given ->
   @username = "foo"
   @password = "bar"
   @credentials = Base64.encode @username + ':' + @password
   
  describe "with a valid url", -> 
   Given -> @subject.url = @url
   
   describe "when authorization passes", ->
    Given ->
     @httpBackend.when('GET',@url).respond (method, url, data, headers) -> [200, '', '']
     
    When -> 
     @result = @subject.checkCredentials @credentials
     @httpBackend.flush()
     @rootScope.$apply()
     
    Then -> @httpBackend.expectGET @url
    Then -> expect(@http.defaults.headers.common['Authorization']).toBe 'Basic ' + @credentials
    
   describe "when authorization fails", ->
    Given ->
     @httpBackend.when('GET',@url).respond (method, url, data, headers) -> [401, '', '']
     
    When -> 
     @result = @subject.checkCredentials @credentials
     @httpBackend.flush()
     @rootScope.$apply()
     
    Then -> @httpBackend.expectGET @url
    Then -> expect(@http.defaults.headers.common['Authorization']).toBe 'Basic ' + @credentials
   
  describe "with an invalid url", ->
   Given -> 
    @invalidUrl = 'someurl'
    @subject.url = @invalidUrl
    @httpBackend.when('GET',@invalidUrl).respond (method, url, data, headers) -> [404, '', '']
    
   When ->
    @result = @subject.checkCredentials @credentials
    @httpBackend.flush()
    @rootScope.$apply()
    
   Then -> @httpBackend.expectGET @invalidUrl
