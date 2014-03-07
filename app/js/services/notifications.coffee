angular.module('app').service 'notifications', ['toastrService', 
 class notifications
  constructor: (@toastrService) ->
   
  error: (msg) -> 
   @toastrService.error msg
  
  success: (msg) -> 
   @toastrService.success msg
   
  info: (msg) ->
   @toastrService.info msg
   
  clear: (optional) ->
   @toastrService.clear(optional)
    
]