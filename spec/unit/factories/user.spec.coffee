describe "user", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector) -> @userClass = $injector.get 'user'
  
 Then -> expect(@userClass).toBeDefined()
 
 describe "constructor with valid data, href, and record number", ->
  Given ->
   @data = {somekey:'somedata', filemaker_accountname: 'someusername' }
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @subject = new @userClass @data, @href, @recordNumber 
  
  Then -> expect(@subject.data).toBe @data
  Then -> expect(@subject.href).toBe @href
  Then -> expect(@subject.recordID).toBe @recordNumber
  Then -> expect(@subject.lastAccessed).toBeDefined()
  Then -> expect(@subject.username).toEqual(@data.filemaker_accountname)
 
 describe "constructor with data that has no username, href, and record number", ->
  Given ->
   @data = {}
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @fn =  => new @userClass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for user'))
  
 describe "constructor with undefined data, href, and record number", ->
  Given ->
   @data = undefined
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @fn =  => new @userClass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for user'))
 
 describe "constructor with valid data, undefined href, and record number", ->
  Given ->
   @data = {somekey:'somedata', filemaker_accountname: 'someusername' }
   @href = undefined
   @recordNumber = 0
   
  When -> @fn =  => new @userClass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for user'))
  
 describe "constructor with valid data, valid href, and undefined record number", ->
  Given ->
   @data = {somekey:'somedata', filemaker_accountname: 'someusername' }
   @href = 'blah'
   @recordNumber = undefined
   
  When -> @fn =  => new @userClass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for user'))
 
 
  ###
  Then -> expect(@subject.data).toBe @data
  Then -> expect(@subject.href).toBe @href
  Then -> expect(@subject.recordID).toBe @recordNumber
  Then -> expect(@subject.lastAccessed).toBeDefined()
  Then -> expect(@subject.username).toEqual(@data.filemaker_accountname)
  ###
