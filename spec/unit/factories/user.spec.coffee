describe "user", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector) -> @userClass = $injector.get 'user'
  
 Then -> expect(@userClass).toBeDefined()
 
 describe "constructor with id and username", ->
  Given ->
   @userId = 'someid'
   @username = 'someusername'
   
  When -> @subject = new @userClass @userId, @username 
  
  Then -> expect(@subject.id).toBe @userId
  Then -> expect(@subject.username).toBe @username
 
