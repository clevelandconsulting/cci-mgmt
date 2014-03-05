describe "credentialService", ->
 Given -> 
  module ("app")
 Given inject ($injector) ->
  @subject = $injector.get 'credentialService'
  
 Then -> expect(@subject).toBeDefined()