describe "userStorageService", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector,_amplifyStorage_) ->
  @mockAmplify = _amplifyStorage_
  @subject = $injector.get 'userStorageService', {amplifyStorage: @mockAmplify}
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.amplifyStorage).toBe(@mockAmplify)
 
 describe "get() when a user exists", ->
  Given -> 
   @user = { username: 'something' }
   spyOn(@mockAmplify,"store").andReturn(@user)
   
  When -> @result = @subject.get()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('user')
  Then -> expect(@result).toBe(@user)
  
 describe "get() when a user exists", ->
  Given -> 
   @user = ''
   spyOn(@mockAmplify,"store").andReturn(@user)
   
  When -> @result = @subject.get()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('user')
  Then -> expect(@result).toBe(@user)
  
 describe "save()", ->
  Given ->
   @user = { username: 'blah' }
   spyOn(@mockAmplify,"store")
   
  When -> @subject.save(@user)
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('user',@user)
  
 describe "clear()", ->
  Given ->
   spyOn(@mockAmplify,"store")
   
  When -> @subject.clear()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('user','')