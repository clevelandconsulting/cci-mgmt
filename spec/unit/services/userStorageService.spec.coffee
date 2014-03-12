describe "userStorageService", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector,_amplifyStorage_) ->
  @mockAmplify = _amplifyStorage_
  @expiry = {expires: 86400000 * 30}
  @subject = $injector.get 'userStorageService', {amplifyStorage: @mockAmplify}
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.amplifyStorage).toBe(@mockAmplify)
 
 describe "getUsers() when users exists", ->
  Given -> 
   @users = [{ username: 'something' }]
   spyOn(@mockAmplify,"store").andReturn(@users)
   
  When -> @result = @subject.getUsers()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('users')
  Then -> expect(@result).toBe(@users)
  
 describe "getUsers() when users does not exists", ->
  Given -> 
   @users = ''
   spyOn(@mockAmplify,"store").andReturn(@users)
   
  When -> @result = @subject.getUsers()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('users')
  Then -> expect(@result).toBe(@users)
  
 describe "saveUsers()", ->
  Given ->
   @users = [{ username: 'blah' }]
   spyOn(@mockAmplify,"store")
   
  When -> @subject.saveUsers(@users)
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('users',@users, @expiry)
 
 describe "addUser()", ->
  Given ->
   @user1 = { username: 'blah' }
   @users = [@user1]
   @user = {username: 'new'}
   spyOn(@mockAmplify,"store").andReturn(@users)
   @expectedCall = [@user1,@user]
   
  When -> @subject.addUser(@user)
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('users',@expectedCall, @expiry)
 
 
 describe "clearUsers()", ->
  Given ->
   spyOn(@mockAmplify,"store")
   
  When -> @subject.clearUsers()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('users','')
  
  
 describe "getCurrentId() when an id exists", ->
  Given -> 
   @userID = 2
   spyOn(@mockAmplify,"store").andReturn(@userID)
   
  When -> @result = @subject.getCurrentId()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('currentUserID')
  Then -> expect(@result).toBe(@userID)
 
 describe "getCurrentId() when an id does not exists", ->
  Given -> 
   @userID = ''
   spyOn(@mockAmplify,"store").andReturn(@userID)
   
  When -> @result = @subject.getCurrentId()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('currentUserID')
  Then -> expect(@result).toBe(@userID)
 
 describe "saveCurrentId()", ->
  Given ->
   @userID = 2
   spyOn(@mockAmplify,"store")
   
  When -> @subject.saveCurrentId(@userID)
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('currentUserID',@userID)
 
 describe "clearCurrentId()", ->
  Given ->
   spyOn(@mockAmplify,"store")
   
  When -> @subject.clearCurrentId()
  
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('currentUserID','')
 
  
  