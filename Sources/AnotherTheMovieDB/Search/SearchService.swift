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

final class SearchService: SearchServiceProtocol {
    
    private let log: OSLog
    private let network: NetworkProtocol
    private let apiRequestBuilder: ApiRequestBuilder
    
    init(log: OSLog = .default, network: NetworkProtocol, apiRequestBuilder: ApiRequestBuilder) {
        self.log = log
        self.network = network
        self.apiRequestBuilder = apiRequestBuilder
    }
    
    func search() -> SearchStateMachine<MovieModel, String, AnotherTheMovieDbError> {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        return SearchStateMachine(
            log: log,
            stateMachineName: "SearchMovie",
            stateMachineQueueName: "\(bundleIdentifier).SearchService.SearchMovie"
        ) {
            self.fetchSearch(with: $1, page: $0)
        }
    }
    
}

// MARK: Network
extension SearchService {
    
    private func fetchSearch(with query: String?, page: Int) -> AnyPublisher<SearchDataResult<MovieModel>, AnotherTheMovieDbError> {
        guard let query = query, !query.isEmpty else {
            return Result.makeSuccess(SearchDataResult.empty())
        }
        
        os_log(.debug, log: log, "Searching %s", query)
        
        let request = apiRequestBuilder.make(endPoint: SearchAPI.movies(query: query, page: page))
        return network.requestDecodable(
            request: request,
            objectMapper: MovieMapper(page: page),
            errorMapper: AppErrorMapper(context: .searchMovies(query: query))
        )
    }
    
}