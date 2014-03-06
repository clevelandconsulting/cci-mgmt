describe "apiService", ->
 Given -> module('app')

 Given inject ($injector, $http, $httpBackend, $rootScope) ->
  @url = "https://fms.clevelandconsulting.com/RESTfm/"
  @http = $http
  @httpBackend = $httpBackend
  @rootScope = $rootScope
  @subject = $injector.get 'apiService'
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.url).toBe('')
 Then -> expect(@subject.credentials).toBe('')
 
 describe "setUrl()", ->
  When -> @subject.setUrl(@url)
  Then -> expect(@subject.url).toBe(@url)
 
 describe "isValidated() when valid is true", ->
  When -> @subject.validated = true;
  Then -> expect(@subject.isValidated()).toBe(true)
 
 describe "isValidated() when valid is false", ->
  When -> @subject.validated = false;
  Then -> expect(@subject.isValidated()).toBe(false)
 
 
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
    Then -> expect(@subject.credentials).toEqual(@credentials)
    Then -> expect(@subject.validated).toBe(true)
    Then -> expect(@http.defaults.headers.common['Authorization']).toBe 'Basic ' + @credentials
    #Then -> expect(@result).toBe(true)
    
   describe "when authorization fails", ->
    Given ->
     @httpBackend.when('GET',@url).respond (method, url, data, headers) -> [401, '', '']
     
    When -> 
     @result = @subject.checkCredentials @credentials
     @httpBackend.flush()
     @rootScope.$apply()
     
    Then -> @httpBackend.expectGET @url
    Then -> expect(@subject.credentials).toEqual('')
    Then -> expect(@subject.validated).toBe(false)
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
   Then -> expect(@subject.credentials).not.toEqual(@credentials)
   Then -> expect(@subject.validated).toBe(false)
   