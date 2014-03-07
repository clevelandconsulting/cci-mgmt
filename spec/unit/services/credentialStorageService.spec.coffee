describe "credentialStorageService", ->
 Given -> module ("app")
 
 Given angular.mock.inject (storageService) ->
  @mockStorageService = storageService
 
 Given inject ($injector) ->
  @subject = $injector.get 'credentialStorageService', {storageService:@mockStorageService}
 
 Given -> 
  @authorizationCredentials = (un,pw) -> Base64.encode(un + ":" + pw)
  spyOn(@mockStorageService,'store').andCallFake (name,value) =>
   if not value?
    if name == 'credentials'
     @credentials
    else
     undefined
   else
    true  
 
 Then -> expect(@subject).toBeDefined()
 
 describe "form()", ->
   
  describe "with a username and password", ->
   Given -> 
    @username = 'foo'
    @password = 'bar'
   
   When -> @result = @subject.form(@username,@password)
   Then -> expect(@result).toEqual(@authorizationCredentials(@username,@password))
  
  describe "with a username and empty password", ->
   Given ->
    @username = 'foo'
    @password = ''
    
   When -> @result = @subject.form(@username,@password)
   Then -> expect(@result).toEqual(@authorizationCredentials(@username,@password))
  
  describe "with an empty username and a password", ->
   Given ->
    @username = ''
    @password = 'bar'
    
   When -> @result = @subject.form(@username,@password)
   Then -> expect(@result).toEqual('')
   
  describe "with an empty username and an empty password", ->
   Given ->
    @username = ''
    @password = ''
    
   When -> @result = @subject.form(@username,@password)
   Then -> expect(@result).toEqual('')

 describe "clear()", ->
 
  When -> @result = @subject.clear()
  
  Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials', '')
 
 describe "get()", ->
  ###
  when called we expect it to check storage for credentials and return them
  if any are there, otherwise it should return with an empty username/password
  object: { username: '', password: '' }
  ###
  
  describe "when storage has a username and password", ->
   Given -> @credentials = @authorizationCredentials(@username,@password)
 
   When -> @result = @subject.get()
   Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials')
   Then -> expect(@result).toEqual(@credentials)
  
  describe  "when storage has no username and password", ->
   Given -> 
    @credentials=undefined
    
   When -> @result = @subject.get() 
   Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials') 
   Then -> expect(@result).toEqual('')  
    
 describe "save()", ->
  ###
  when called we expect it to be passed a username and password to store that
  will later be accessible
  ###
  
  Given -> 
   @username = 'foo'
   @password = 'bar'
   @credentials = @authorizationCredentials(@username,@password)
   
  When -> @result = @subject.save(@credentials)
  Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials',@credentials)
  
  