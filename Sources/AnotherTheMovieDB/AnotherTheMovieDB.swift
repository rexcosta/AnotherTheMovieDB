//
// The MIT License (MIT)
//
// Copyright (c) 2020 Effective Like ABoss, David Costa Gonçalves
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import AnotherSwiftCommonLib
import Foundation
import os

/// AnotherTheMovieDB dependencies
public struct AnotherTheMovieDB {
    
    private let authenticationManager: AuthenticationManagerProtocol
    public let languageManager: LanguageManagerProtocol
    public let apiRequestBuilder: ApiRequestBuilder
    public let movieService: MovieServiceProtocol
    public let searchService: SearchServiceProtocol
    public let genreService: GenreServiceProtocol
    public let imageService: ImageServiceProtocol
    
    /// Creates a full functional AnotherTheMovieDB to be used
    /// - Parameters:
    ///   - authenticationManager: the instance resposible for the authentication
    ///   - languageManager: the instance resposible for the language
    ///   - apiRequestBuilder: the instance resposible to build the http requests
    ///   - movieService: the instance resposible to do movie related operations
    ///   - searchService: the instance resposible to do search related operations
    ///   - genreService: the instance resposible to do genre related operations
    ///   - imageService: the instance resposible to do image related operations
    public init(
        authenticationManager: AuthenticationManagerProtocol,
        languageManager: LanguageManagerProtocol,
        apiRequestBuilder: ApiRequestBuilder,
        movieService: MovieServiceProtocol,
        searchService: SearchServiceProtocol,
        genreService: GenreServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.authenticationManager = authenticationManager
        self.languageManager = languageManager
        self.apiRequestBuilder = apiRequestBuilder
        self.movieService = movieService
        self.searchService = searchService
        self.genreService = genreService
        self.imageService = imageService
    }
    
}

// MARK: Init Helpers
extension AnotherTheMovieDB {
    
    /// Creates a full functional AnotherTheMovieDB to be used
    /// - Parameters:
    ///   - apiKey: themoviedb API key
    ///   - userAgent: the user agent to use in the http requets
    ///   - language: the initial language
    ///   - network: the network layer to do http requests
    public init(apiKey: String, userAgent: String, language: Language, network: NetworkProtocol) {
        let languageLog = OSLog(subsystem: AnotherTheMovieDB.subsystem(), category: "Language")
        let languageManager = LanguageManager(log: languageLog, language: language)
        
        let authenticationManager = AuthenticationManager(apiKey: apiKey)
        
        let apiRequestBuilder = ApiRequestBuilder(
            userAgent: userAgent,
            authenticationManager: authenticationManager,
            languageManager: languageManager
        )
        
        self.init(
            authenticationManager: authenticationManager,
            languageManager: languageManager,
            apiRequestBuilder: apiRequestBuilder,
            network: network
        )
    }
    
    /// Creates a full functional AnotherTheMovieDB to be used
    /// - Parameters:
    ///   - authenticationManager: the instance resposible for the authentication
    ///   - languageManager: the instance resposible for the language
    ///   - apiRequestBuilder: the instance resposible to build the http requests
    ///   - network: the network layer to do http requests
    public init(
        authenticationManager: AuthenticationManagerProtocol,
        languageManager: LanguageManagerProtocol,
        apiRequestBuilder: ApiRequestBuilder,
        network: NetworkProtocol
    ) {
        let subsystem = AnotherTheMovieDB.subsystem()
        let movieLog = OSLog(subsystem: subsystem, category: "Movies")
        let searchLog = OSLog(subsystem: subsystem, category: "Search")
        let genreLog = OSLog(subsystem: subsystem, category: "Genres")
        let imageLog = OSLog(subsystem: subsystem, category: "Images")
        
        let movieService = MovieService(
            log: movieLog,
            network: network,
            apiRequestBuilder:
            apiRequestBuilder
        )
        
        let searchService = SearchService(
            log: searchLog,
            network: network,
            apiRequestBuilder: apiRequestBuilder
        )
        
        let genreService = GenreService(
            log: genreLog,
            network: network,
            apiRequestBuilder: apiRequestBuilder
        )
        
        let imageService = ImageService(
            log: imageLog,
            network: network,
            apiRequestBuilder: apiRequestBuilder
        )
        
        self.init(
            authenticationManager: authenticationManager,
            languageManager: languageManager,
            apiRequestBuilder: apiRequestBuilder,
            movieService: movieService,
            searchService: searchService,
            genreService: genreService,
            imageService: imageService
        )
    }
    
}

// MARK: Helpers
extension AnotherTheMovieDB {
    
    private static func subsystem(bundle: Bundle = .main) -> String {
        let bundleIdentifier = bundle.bundleIdentifier ?? ""
        return "\(bundleIdentifier).AnotherTheMovieDB"
    }
    
}
