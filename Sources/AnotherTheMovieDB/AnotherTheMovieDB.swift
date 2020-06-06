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
    ///   - logging: loggers to be used
    public init(
        apiKey: String,
        userAgent: String,
        language: Language,
        network: NetworkProtocol,
        logging: Logging = Logging.default()
    ) {
        let languageManager = LanguageManager(log: logging.languageLog, language: language)
        
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
            network: network,
            logging: logging
        )
    }
    
    /// Creates a full functional AnotherTheMovieDB to be used
    /// - Parameters:
    ///   - authenticationManager: the instance resposible for the authentication
    ///   - languageManager: the instance resposible for the language
    ///   - apiRequestBuilder: the instance resposible to build the http requests
    ///   - network: the network layer to do http requests
    ///   - logging: loggers to be used
    public init(
        authenticationManager: AuthenticationManagerProtocol,
        languageManager: LanguageManagerProtocol,
        apiRequestBuilder: ApiRequestBuilder,
        network: NetworkProtocol,
        logging: Logging
    ) {
        let movieService = MovieService(
            log: logging.movieLog,
            network: network,
            apiRequestBuilder:
            apiRequestBuilder
        )
        
        let searchService = SearchService(
            log: logging.searchLog,
            network: network,
            apiRequestBuilder: apiRequestBuilder
        )
        
        let genreService = GenreService(
            log: logging.genreLog,
            network: network,
            apiRequestBuilder: apiRequestBuilder
        )
        
        let imageService = ImageService(
            log: logging.imageLog,
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

// MARK: Logging
extension AnotherTheMovieDB {

    public struct Logging {
        fileprivate let languageLog: OSLog
        fileprivate let movieLog: OSLog
        fileprivate let searchLog: OSLog
        fileprivate let genreLog: OSLog
        fileprivate let imageLog: OSLog
        
        public static func `default`() -> Logging {
            return custom()
        }
        
        public static func disabled() -> Logging {
            return custom(
                languageLogEnabled: false,
                movieLogEnabled: false,
                searchLogEnabled: false,
                genreLogEnabled: false,
                imageLogEnabled: false
            )
        }
        
        public static func custom(
            languageLogEnabled: Bool = true,
            movieLogEnabled: Bool = true,
            searchLogEnabled: Bool = true,
            genreLogEnabled: Bool = true,
            imageLogEnabled: Bool = true
        ) -> Logging {
            let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
            let subsystem = "\(bundleIdentifier).AnotherTheMovieDB"
            
            let languageLog = makeOsLog(enabled: languageLogEnabled, subsystem: subsystem, category: "Language")
            let movieLog = makeOsLog(enabled: languageLogEnabled, subsystem: subsystem, category: "Movies")
            let searchLog = makeOsLog(enabled: languageLogEnabled, subsystem: subsystem, category: "Search")
            let genreLog = makeOsLog(enabled: languageLogEnabled, subsystem: subsystem, category: "Genres")
            let imageLog = makeOsLog(enabled: languageLogEnabled, subsystem: subsystem, category: "Images")
            
            return Logging(
                languageLog: languageLog,
                movieLog: movieLog,
                searchLog: searchLog,
                genreLog: genreLog,
                imageLog: imageLog
            )
        }
        
        private static func makeOsLog(enabled: Bool, subsystem: String, category: String) -> OSLog {
            if enabled {
                return OSLog(subsystem: subsystem, category: category)
            } else {
                return .disabled
            }
        }
        
    }
    
}
