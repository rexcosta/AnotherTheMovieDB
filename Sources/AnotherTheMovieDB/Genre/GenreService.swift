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
import AnotherCombineCache
import Combine
import os

final class GenreService: GenreServiceProtocol {
    
    private let genresCache: ValueCache<[GenreModel], AnotherTheMovieDbError>
    
    init(log: OSLog = .default, network: NetworkProtocol, apiRequestBuilder: ApiRequestBuilder) {
        let request = apiRequestBuilder.make(endPoint: GenreAPI.movieGenres)
        
        genresCache = ValueCache(log: log, cacheName: "MoviesGenres") {
            return network.requestDecodable(
                request: request,
                objectMapper: GenreMapper(),
                errorMapper: AppErrorMapper(context: .genre)
            )
        }
    }
    
    func genres() -> AnyPublisher<[GenreModel], AnotherTheMovieDbError> {
        return genresCache.value()
    }
    
    func findGenre(with id: Int) -> AnyPublisher<GenreModel?, AnotherTheMovieDbError> {
        return genresCache
            .value()
            .reduce(nil) { $1.findIdentifiable(with: id) }
            .eraseToAnyPublisher()
    }
    
}
