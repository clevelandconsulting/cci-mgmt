angular.module('app').service 'userStorageService', ['amplifyStorage', 
 class userStorageService
  constructor: (@amplifyStorage) ->

  get: -> @amplifyStorage.store('user')
  save: (user) -> @amplifyStorage.store('user', user)
  clear: -> @save('')
]