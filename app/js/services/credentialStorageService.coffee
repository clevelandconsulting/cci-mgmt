angular.module('app').service 'credentialStorageService', [ 'storageService', class credentialStorageService
  constructor: (@storageService) ->
  
  form: (username,password) ->
   if username != ''
    auth = Base64.encode(username + ':' + password)
    {auth: auth, username: username}
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