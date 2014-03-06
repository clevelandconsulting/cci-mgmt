angular.module('app').service 'credentialStorageService', [ 'storageService', class credentialStorageService
  constructor: (@storageService) ->
  
  form: (username,password) ->
   {username: username, password: password }
  
  get: ->
   cred = @storageService.store('credentials')
   if cred?
    cred
   else
    @form('','')
    
  save: (username,password) ->
   @storageService.store('credentials', @form(username,password))
  
]  
# new credentialStorageService()
#] 