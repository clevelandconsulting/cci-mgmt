describe "credentialStorageService", ->
 Given -> module ("app")
 
 Given angular.mock.inject (storageService) ->
  @mockStorageService = storageService
 
 Given inject ($injector) ->
  @subject = $injector.get 'credentialStorageService', {storageService:@mockStorageService}
 
 Given -> 
  spyOn(@mockStorageService,'store').andCallFake (name,value) =>
   if not value?
    if name == 'credentials'
     @credentials
    else
     undefined
   else
    true  
 
 Then -> expect(@subject).toBeDefined()
 
 describe "Form()", ->
  Given -> 
   @username = 'foo'
   @password = 'bar'
   
  When -> @result = @subject.form(@username,@password)
  Then -> expect(@result).toEqual({username: @username, password: @password})
 
 describe "get()", ->
  ###
  when called we expect it to check storage for credentials and return them
  if any are there, otherwise it should return with an empty username/password
  object: { username: '', password: '' }
  ###
  
  describe "when storage has a username and password", ->
   Given -> @credentials = {username: 'foo', password:'bar'}
 
   When -> @result = @subject.get()
   Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials')
   Then -> expect(@result).toEqual(@credentials)
  
  describe  "when storage has no username and password", ->
   Given -> 
    @credentials=undefined
    
   When -> @result = @subject.get() 
   Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials') 
   Then -> expect(@result).toEqual({username: '', password: ''})  
    
 describe "save()", ->
  ###
  when called we expect it to be passed a username and password to store that
  will later be accessible
  ###
  
  Given -> 
   @username = 'foo'
   @password = 'bar'
   @credentials = {username: @username, password: @password}
   
  When -> @result = @subject.save(@username,@password)
  Then -> expect(@mockStorageService.store).toHaveBeenCalledWith('credentials',@credentials)
  
  