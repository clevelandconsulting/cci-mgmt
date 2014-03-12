angular.module('app').service 'userStorageService', ['amplifyStorage', 
 class userStorageService
  
  @users: 'users'
  @currentId: 'currentUserID'
  @expiry: 86400000 * 30
 
  constructor: (@amplifyStorage) ->

  getUsers: -> @amplifyStorage.store(userStorageService.users)
  saveUsers: (users) -> @amplifyStorage.store(userStorageService.users, users, {expires:userStorageService.expiry})
  clearUsers: -> @amplifyStorage.store(userStorageService.users,'')
  addUser: (user) ->
   users = @getUsers()
   if users == '' || users == undefined
    users = [user]
   else
    users.push user
   @saveUsers users
  
  getCurrentId: () -> @amplifyStorage.store(userStorageService.currentId)
  saveCurrentId: (userId) -> @amplifyStorage.store(userStorageService.currentId, userId)
  clearCurrentId: -> @saveCurrentId('')
]