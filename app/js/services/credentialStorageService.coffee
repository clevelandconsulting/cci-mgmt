angular.module('app').service 'credentialStorageService', [ 'storageService', class credentialStorageService
  constructor: (@storageService) ->
  
  form: (username,password) ->
   if username != ''
    Base64.encode username + ':' + password
   else
    ''
    
  get: ->
   cred = @storageService.store('credentials')
   if cred?
    cred
   else
    ''
  clear: -> @save('')
   
  save: (credentials) -> @storageService.store('credentials', credentials)
  
]  
# new credentialStorageService()
#] 