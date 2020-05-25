# AnotherTheMovieDB

This project is just an example to consume [The Movie DB](https://www.themoviedb.org) API.


### SearchServiceProtocol

* [search/movie](https://developers.themoviedb.org/3/search/search-movies)
  * Search for movies with the given query string

### GenreServiceProtocol

* [genre/movie/list](https://developers.themoviedb.org/3/movies/get-now-playing)
  * Get the list of official genres for movies.

### MovieServiceProtocol

* [movie/latest](https://developers.themoviedb.org/3/movies/get-now-playing)
  * Get the most newly created movie.

* [movie/now_playing](https://developers.themoviedb.org/3/movies/get-now-playing)
  * Get a list of movies in theatres.

* [movie/popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
  * Get a list of the current popular movies on TMDb.

* [movie/top_rated](https://developers.themoviedb.org/3/movies/get-top-rated-movies)
  * Get the top rated movies on TMDb.

* [movie/upcoming](https://developers.themoviedb.org/3/movies/get-upcoming)
  * Get a list of upcoming movies in theatres.

## Example usuage
```swift
let theMovieDB = AnotherTheMovieDB(apiKey: "YOUR_API_KEY", userAgent: "YOUR_USER_AGENT", language: .en_US, network: network)

// Example:
let search = db.searchService.search()
search.send(action: .refresh(query: searchTextField.text))
search.state.sink { state in
    // update ui
}
```

# Roadmap
- [ ] Add core data support
- [ ] Unit tests
- [ ] More documentation

# Dependencies
* [AnotherSwiftCommonLib](https://github.com/rexcosta/AnotherSwiftCommonLib)
* [AnotherPagination](https://github.com/rexcosta/AnotherPagination)
