class storageService
  constructor: (amplifyStorage) ->
   @storage = amplifyStorage
  store: (name,value) ->
   @storage.store(name,value)
  get: (name) ->
   @storage.store(name)
   
angular.module('app').service 'storageService', ['amplifyStorage', (amplifyStorage) -> new storageService(amplifyStorage) ]