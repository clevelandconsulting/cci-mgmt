class fmRestRepository
  constructor: (@$q, @cciApi, @model, @path, @modelName) ->
   #@path = 'layout/Api-Time'
   
  getAllForStaff: (staff_id) -> 
   @d = @$q.defer()
   
   successFn = (response) =>
    results = []
    fmData = response.data
    if fmData.data?
     for time, i in fmData.data
      results.push new @model time, fmData.meta[i].href, fmData.meta[i].recordID
    @d.resolve results
   
   @cciApi.get(@path+'.json?RFMsF1=staff_id&RFMsV1='+staff_id).then successFn, (response) => 
    @d.reject response
   
   @d.promise
   
  add: (data) ->
   
   @d = @$q.defer()
   
   successFn = (response) => 
    msg = "Your " + @modelName + " was successfully added!"
    data = new @model response.data.data[0], response.data.meta[0].href, response.data.meta[0].recordID
    @d.resolve {msg: msg, data:data }
   errorFn = (response) =>
    msg = "There was a problem adding your " + @modelName + ". "
    msg = msg + response.data.info['X-RESTfm-Reason']
    @d.reject msg
    
   @cciApi.post(@path+'.json', {data: [data]}).then successFn, errorFn
   
   @d.promise
   
  update: (data,href) ->
   dataToSend = {data: [data]}
   
   href = href.replace '/RESTfm/STEVE/',''
   
   @d = @$q.defer()
   
   successFn = (response) => 
    @d.resolve "Your " + @modelName + " was successfully updated!"
   errorFn = (response) =>
    msg = "There was a problem updating your " + @modelName + ". "
    if response.status == 404
     msg = "There was a problem updating your " + @modelName + ". Unable to find the record at " + href
    else
     fmstatus = response.data.info['X-RESTfm-FM-Status']
     fmreason = response.data.info['X-RESTfm-FM-Reason']
     if fmstatus?
      msg = msg + fmstatus + ': ' + fmreason
     else 
      msg = msg + fmreason
     
    @d.reject msg
   
   @cciApi.put(href, dataToSend).then successFn, errorFn
   
   @d.promise

angular.module('app').factory 'fmRestRepository', -> fmRestRepository
 