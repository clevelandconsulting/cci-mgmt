###
describe "storageService", ->
 Given -> module ("app")

 #mock out the service dependencies
 Given angular.mock.inject (amplifyStorage) ->
   @mockAmplify = amplifyStorage
 
 #inject the service under test
 Given inject ($injector) ->
  @subject = $injector.get 'storageService', {amplifyStorage:@mockAmplify}
  
 Then -> expect(@subject).toBeDefined()
 
 describe "store()", ->
  Given ->
   @foo = 'bar'
   spyOn(@mockAmplify,'store').andReturn(true)
   
  When -> @subject.store('foo', @foo)
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('foo',@foo)
  
 describe "get()", ->
  Given ->
   spyOn(@mockAmplify,'store').andReturn(@foo)
   
  When -> @result = @subject.get('foo')
  Then -> expect(@result).toEqual(@foo)

###