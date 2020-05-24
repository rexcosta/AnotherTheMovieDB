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
import Foundation
import os

final class ImageService: ImageServiceProtocol {
    
    private let apiRequestBuilder: ApiRequestBuilder
    
    private let imagesCache: MultipleValuesCache<NetworkRequest, ImageModel, AnotherTheMovieDbError>
    
    init(log: OSLog = .default, network: NetworkProtocol, apiRequestBuilder: ApiRequestBuilder) {
        self.apiRequestBuilder = apiRequestBuilder
        
        imagesCache = MultipleValuesCache(log: log, cacheName: "Images") { request -> AnyPublisher<ImageModel, AnotherTheMovieDbError> in
            return network.requestData(
                request: request,
                objectMapper: ImageMapper(request: request),
                errorMapper: AppErrorMapper(context: .image)
            )
        }
    }
    
    func findImage(for movie: MovieModel, with size: ImageSize) -> AnyPublisher<ImageModel, AnotherTheMovieDbError> {
        guard let posterPath = movie.posterPath else {
            return Result.makeError(.image(context: .movieDontHavePoster))
        }
        let request = apiRequestBuilder.make(endPoint: ImageAPI.movie(posterPath, size: size))
        return imagesCache.value(for: request)
    }
    
}
