class storageService
  constructor: (amplifyStorage) ->
   @storage = amplifyStorage
  store: (name,value) ->
   @storage.store(name,value)
   
angular.module('app').service 'storageService', ['amplifyStorage', (amplifyStorage) -> new storageService(amplifyStorage) ]