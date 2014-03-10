###
describe "amplifyStorage", ->
 Given -> module('app')
 Given inject ($injector) ->
  @subject = $injector.get 'amplifyStorage'
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.store).toBeDefined()
 ###