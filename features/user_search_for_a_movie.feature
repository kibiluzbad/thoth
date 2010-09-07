Feature: user search for a movie

  As a user
  I want to search for a movie
  So that I can find the imdbid of that movie
  Scenario: search movie
    When I search for the matrix
    Then title should contains the matrix
