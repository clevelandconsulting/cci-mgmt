describe 'notifications', ->
 Given -> module('app')
 
 Given angular.mock.inject (toastrService) ->
  @mockToastrService = toastrService
 
 Given inject ($injector) ->
  @subject = $injector.get 'notifications', {toastrService:@mockToastrService}
  
 Then -> expect(@subject).toBeDefined()
 
 describe "info()", ->
  Given -> 
   spyOn(@mockToastrService,'info')
   @msg = 'This is a sample msg!'
  
  When -> @subject.info(@msg)
  
  Then -> expect(@mockToastrService.info).toHaveBeenCalledWith(@msg)
 
 describe "clear()", ->
  Given -> 
   @toastrs = undefined
   spyOn(@mockToastrService,'clear')
  
  When -> @subject.clear(@toastrs)
  
  Then -> expect(@mockToastrService.clear).toHaveBeenCalledWith(@toastrs)
 
 
 describe "error()", ->
  Given -> 
   spyOn(@mockToastrService,'error')
   @msg = 'This is a sample error!'
  
  When -> @subject.error(@msg)
  
  Then -> expect(@mockToastrService.error).toHaveBeenCalledWith(@msg)
  
 describe "success()", ->
  Given -> 
   spyOn(@mockToastrService,'success')
   @msg = 'This is a message!'
  
  When -> @subject.success(@msg)
  
  Then -> expect(@mockToastrService.success).toHaveBeenCalledWith(@msg)