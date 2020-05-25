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
import AnotherPagination
import Combine
import Foundation
import os

final class MovieService: MovieServiceProtocol {
    
    private let log: OSLog
    private let network: NetworkProtocol
    private let apiRequestBuilder: ApiRequestBuilder
    
    init(log: OSLog = .default, network: NetworkProtocol, apiRequestBuilder: ApiRequestBuilder) {
        self.log = log
        self.network = network
        self.apiRequestBuilder = apiRequestBuilder
    }
    
    func latestAddedMovie() -> AnyPublisher<MovieModel?, AnotherTheMovieDbError> {
        let request = apiRequestBuilder.make(endPoint: MovieAPI.latestAddedMovie)
        return network.requestDecodable(
            request: request,
            objectMapper: MovieMapper(),
            errorMapper: AppErrorMapper(context: .latestAddedMovie)
        )
    }
    
    func nowPlaying() -> SearchStateMachine<MovieModel, Void, AnotherTheMovieDbError> {
        return makeStateMachine(stateMachineName: "NowPlaying") { (page, _) in
            return self.fetchNowPlaying(page: page)
        }
    }
    
    func popular() -> SearchStateMachine<MovieModel, Void, AnotherTheMovieDbError> {
        return makeStateMachine(stateMachineName: "Popular") { (page, _) in
            return self.fetchPopular(page: page)
        }
    }
    
    func topRated() -> SearchStateMachine<MovieModel, Void, AnotherTheMovieDbError> {
        return makeStateMachine(stateMachineName: "TopRated") { (page, _) in
            return self.fetchTopRated(page: page)
        }
    }
    
    func upcoming() -> SearchStateMachine<MovieModel, Void, AnotherTheMovieDbError> {
        return makeStateMachine(stateMachineName: "Upcoming") { (page, _) in
            return self.fetchUpcoming(page: page)
        }
    }
    
}

// MARK: Network
extension MovieService {
    
    private func fetchNowPlaying(page: Int) -> AnyPublisher<SearchDataResult<MovieModel>, AnotherTheMovieDbError> {
        let request = apiRequestBuilder.make(endPoint: MovieAPI.nowPlaying(page: page))
        return network.requestDecodable(
            request: request,
            objectMapper: MoviesMapper(page: page),
            errorMapper: AppErrorMapper(context: .nowPlayingMovies)
        )
    }
    
    private func fetchPopular(page: Int) -> AnyPublisher<SearchDataResult<MovieModel>, AnotherTheMovieDbError> {
        let request = apiRequestBuilder.make(endPoint: MovieAPI.popular(page: page))
        return network.requestDecodable(
            request: request,
            objectMapper: MoviesMapper(page: page),
            errorMapper: AppErrorMapper(context: .popularMovies)
        )
    }
    
    private func fetchTopRated(page: Int) -> AnyPublisher<SearchDataResult<MovieModel>, AnotherTheMovieDbError> {
        let request = apiRequestBuilder.make(endPoint: MovieAPI.topRated(page: page))
        return network.requestDecodable(
            request: request,
            objectMapper: MoviesMapper(page: page),
            errorMapper: AppErrorMapper(context: .topRatedMovies)
        )
    }
    
    private func fetchUpcoming(page: Int) -> AnyPublisher<SearchDataResult<MovieModel>, AnotherTheMovieDbError> {
        let request = apiRequestBuilder.make(endPoint: MovieAPI.upcoming(page: page))
        return network.requestDecodable(
            request: request,
            objectMapper: MoviesMapper(page: page),
            errorMapper: AppErrorMapper(context: .upcomingMovies)
        )
    }
    
}

// MARK: Helpers
extension MovieService {
    
    private func makeStateMachine(
        stateMachineName: String,
        dataProvider: @escaping SearchDataProvider<MovieModel, Void, AnotherTheMovieDbError>
    ) -> SearchStateMachine<MovieModel, Void, AnotherTheMovieDbError> {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        return SearchStateMachine(
            log: log,
            stateMachineName: stateMachineName,
            stateMachineQueueName: "\(bundleIdentifier).MovieService.\(stateMachineName)",
            dataProvider: dataProvider
        )
    }

}
