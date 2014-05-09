assert = require("assert")
movieRatings = {}
objMovieRatings = {};
sort = {};
MovieRatingsResource = require("../app/movie-ratings")

describe "MovieRatingsResource", ->
  beforeEach ->

    objMovieRatings =
      "Bladerunner": [
        5
        1
      ]
      "The Empire Strikes Back": [
        1
        1
        2
        3
        5
      ]

    movieRatings = new MovieRatingsResource objMovieRatings
    
    sort = (array) ->
      array.sort (a, b) ->
        a - b

     

    
  describe "#getAllMovieRatings()", ->
    it "should return the correct ratings for all movies", ->
      MovieRatingsInput = objMovieRatings
      MovieRatingsMethod = movieRatings.getAllMovieRatings()
      for movie of MovieRatingsMethod
        inputRatings = sort MovieRatingsInput[movie]
        storedRatings = sort MovieRatingsMethod[movie]
        assert.deepEqual inputRatings, storedRatings
      return


  describe "#getMovieRatings()", ->
    it "should return the correct movie ratings for the requested movie", ->
      
      MovieName = Object.keys(objMovieRatings)[0]
      moreMovieRatings = movieRatings.getMovieRatings MovieName
      assert.deepEqual sort(moreMovieRatings), sort(objMovieRatings[MovieName])


    it "should throw an error if the requested movie does not exist in the repo", ->
      assert.throws (-> movieRatings.getMovieRatings 'AFakeMoviethatWontExist'), /Movie does not exist in repository/


  describe "#putMovieRatings()", ->
    it "should put a new movie with ratings into the repo and return the ratings", ->
      if typeof objMovieRatings["Jackie Chan"]  is 'undefined'
        movieRater = movieRatings.putMovieRatings "Jackie Chan", [5,4,4,3,2,4,5]
        assert.deepEqual sort(movieRater), sort([5,4,4,3,2,4,5])
      else
        throw new Error 'Dummy movie exists in repo!'


    it "should overwrite the ratings of an existing movie in the repo and return the new ratings", ->
      MovieName = Object.keys(objMovieRatings)[0]
      movieRater = movieRatings.putMovieRatings MovieName, [100,4,6,100,4]
      assert.deepEqual sort(movieRater), sort([100,4,6,100,4])

  describe "#postMovieRating()", ->
    it "should put a new movie with rating into the repo if it does not already exist and return the rating", ->
      if typeof objMovieRatings["Jackie Chan"] is "undefined"
        ratings = movieRatings.postMovieRating 'Jackie Chan', 30
        assert.deepEqual ratings, [30]
 
    it "should not put a new movie with rating into the repo if it already exists", ->
      MovieName = Object.keys(objMovieRatings)[0]
      ratings = movieRatings.postMovieRating MovieName, [5,3,3,4,2,4,3]
      assert.notDeepEqual sort(ratings), sort([5,3,3,4,2,4,3])

    it "should add a new rating to an existing movie in the repo and return the ratings", ->
      MovieName = Object.keys(objMovieRatings)[0]
      count = objMovieRatings[MovieName].filter((x) ->
        x is 10
      ).length

      ratings = movieRatings.postMovieRating MovieName, 10
      newCount = objMovieRatings[MovieName].filter((x) ->
        x is 10
      ).length

      assert.equal count, newCount - 1


  describe "#deleteMovieRatings()", ->
    it "should delete a movie from the ratings repo", ->
      MovieName = Object.keys(objMovieRatings)[0]
      movieRatings.deleteMovieRatings MovieName
      assert.throws (-> movieRatings.getMovieRatings MovieName), /Movie does not exist in repository/
      
    it "should throw an error when attempting to delete a movie that does not exist", ->
      assert.throws (-> movieRatings.deleteMovieRatings 'Afakemoviethatwouldneverexist'), /Movie does not exist in repository/


