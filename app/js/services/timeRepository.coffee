angular.module('app').service 'timeRepository', [ '$q', 'cciApiService', 'fmRestModel', 
 class timeRepository
  constructor: (@$q, @cciApi, @model) ->
   @path = 'layout/Api-Time'
   
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
    console.log response
    @d.reject response
   
   @d.promise
]
