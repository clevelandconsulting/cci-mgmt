describe "user", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, _fmRestModel_) -> @userClass = $injector.get 'user', {fmRestModel: _fmRestModel_}
  
 Then -> expect(@userClass).toBeDefined()
 
 describe "constructor with valid data, href, and record number", ->
  Given ->
   @data = {somekey:'somedata', filemaker_accountname: 'someusername' }
   @href = 'somehref'
   @recordNumber = 0
  
  describe "when privilege set is [Full Access]", ->
   Given ->
    @data.filemaker_accountprivilege = "[Full Access]"
    
   When -> @subject = new @userClass @data, @href, @recordNumber
    
   Then -> expect(@subject.username).toEqual(@data.filemaker_accountname)
   Then -> expect(@subject.canSeeOthers).toBeTruthy()
  
  describe "when privilege set is not [Full Access]", ->
   Given ->
    @data.filemaker_accountprivilege = "Administrator"
    
   When -> @subject = new @userClass @data, @href, @recordNumber
   
   Then -> expect(@subject.username).toEqual(@data.filemaker_accountname)
   Then -> expect(@subject.canSeeOthers).toBeFalsy()
   
 describe "constructor with data that has no username, href, and record number", ->
  Given ->
   @data = {}
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @fn =  => new @userClass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for user'))