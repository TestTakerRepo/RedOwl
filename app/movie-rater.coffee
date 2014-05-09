_ = require 'underscore'

module.exports = (ratings) ->
  average = undefined
  cleaned = undefined
  max = undefined
  min = undefined
  sum = undefined
  trimmed = undefined

  unless Array.isArray(ratings) and arguments.length is 1
    throw new Error("Invalid arguments")
  else
    arrUniq = _.uniq(ratings)
    throw new Error("Not enough ratings")  if arrUniq.length < 3
  
  cleaned = ratings.filter((x) ->
    typeof x is "number"
  )

  min = Math.min.apply(null, cleaned)
  max = Math.max.apply(null, cleaned)
  trimmed = cleaned.filter((x) ->
    x isnt min and x isnt max
  )
  sum = trimmed.reduce((a, b) ->
    a + b
  , 0)
  average = sum / trimmed.length
  average
