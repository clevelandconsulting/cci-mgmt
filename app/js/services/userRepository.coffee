angular.module('app').service 'userRepository', [ 'cciApiService', 'user', 'userStorageService', 
 class userRepository
  constructor: (@cciApi, @user, @userStorage) ->
  getUser: ->
]