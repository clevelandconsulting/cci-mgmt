describe "user", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector) -> @userClass = $injector.get 'user'
  
 Then -> expect(@userClass).toBeDefined()
 
 describe "constructor with data, href, and record number", ->
  Given ->
   @data = 'somedata'
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @subject = new @userClass @data, @href, @recordNumber 
  
  Then -> expect(@subject.data).toBe @data
  Then -> expect(@subject.href).toBe @href
  Then -> expect(@subject.recordID).toBe @recordNumber
  Then -> expect(@subject.lastAccessed).toBeDefined()
 
