describe "fmRestModel", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector) -> @theclass = $injector.get 'fmRestModel'
  
 Then -> expect(@theclass).toBeDefined()
 
 describe "constructor with valid data, href, and record number", ->
  Given ->
   @data = {somekey:'somedata' }
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @subject = new @theclass @data, @href, @recordNumber 
  
  Then -> expect(@subject.data).toBe @data
  Then -> expect(@subject.href).toBe @href
  Then -> expect(@subject.recordID).toBe @recordNumber
  #Then -> expect(@subject.lastAccessed).toBeDefined()
 
 describe "constructor with undefined data, href, and record number", ->
  Given ->
   @data = undefined
   @href = 'somehref'
   @recordNumber = 0
   
  When -> @fn =  => new @theclass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for record'))
 
 describe "constructor with valid data, undefined href, and record number", ->
  Given ->
   @data = {somekey:'somedata' }
   @href = undefined
   @recordNumber = 0
   
  When -> @fn =  => new @theclass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for record'))
  
 describe "constructor with valid data, valid href, and undefined record number", ->
  Given ->
   @data = {somekey:'somedata' }
   @href = 'blah'
   @recordNumber = undefined
   
  When -> @fn =  => new @theclass @data, @href, @recordNumber
  
  Then -> expect(@fn).toThrow(new Error('Invalid data for record'))