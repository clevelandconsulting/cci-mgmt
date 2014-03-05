describe "storageService", ->
 Given -> module ("app")
 Given ->
  @mockAmplify = () -> {
   mock: true,
   store: (foo,bar) -> 
    true
  }
 
 Given -> 
  module ($provide) ->
   $provide.value('amplifyStorage', @mockAmplify)
 
 Given inject ($injector) ->
  @subject = $injector.get 'storageService' #, {amplifyStorage:@mockAmplify}
  
 Then -> expect(@subject).toBeDefined()
 
 describe "store()", ->
  Given ->
   @foo = 'bar'
   spyOn(@mockAmplify,'store').andReturn(true)
   console.log @mockAmplify
   
  When -> @subject.store('foo', @foo)
  Then -> expect(@mockAmplify.store).toHaveBeenCalledWith('foo',@foo)