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

public enum MovieAPI {
    case latestAddedMovie
    case nowPlaying(page: Int)
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
}

extension MovieAPI: ApiEndPoint {
    
    public var requiresAuth: Bool {
        return true
    }
    
    public var scheme: String {
        return "https"
    }
    
    public var baseUrl: String {
        return "api.themoviedb.org/3/movie"
    }
    
    public var path: String {
        switch self {
            
        case .latestAddedMovie:
            return "latest"
            
        case .nowPlaying:
            return "now_playing"
            
        case .popular:
            return "popular"
            
        case .topRated:
            return "top_rated"
            
        case .upcoming:
            return "upcoming"
        }
    }
    
    public var parameters: [HttpQueryParameter] {
        switch self {
        case .latestAddedMovie:
            return [HttpQueryParameter]()
            
        case .nowPlaying(let page), .popular(let page), .topRated(let page), .upcoming(let page):
            return [
                HttpQueryParameter(name: "page", value: "\(page)")
            ]
        }
    }
    
    public var method: HttpMethod {
        return .get
    }
    
}
