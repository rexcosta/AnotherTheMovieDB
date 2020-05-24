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

public struct ApiRequestBuilder {
    
    private let userAgent: String
    private let authenticationManager: AuthenticationManagerProtocol
    private let languageManager: LanguageManagerProtocol
    
    public init(
        userAgent: String,
        authenticationManager: AuthenticationManagerProtocol,
        languageManager: LanguageManagerProtocol
    ) {
        self.userAgent = userAgent
        self.authenticationManager = authenticationManager
        self.languageManager = languageManager
    }
    
    public func make(endPoint: ApiEndPoint) -> NetworkRequest {
        let urlString = "\(endPoint.scheme)://\(endPoint.baseUrl)/\(endPoint.path)"
        var request = NetworkRequest(
            allowsCellularAccess: true,
            timeout: 30,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            networkServiceType: .responsiveData,
            url: urlString,
            headers: [
                // Accept-Encoding:gzip
                // ETags
                HttpHeader.userAgent(userAgent),
                HttpHeader.accept(HttpMimeType.json)
            ],
            parameters: endPoint.parameters,
            body: nil,
            method: endPoint.method
        )
        
        // Pass a ISO 639-1 value to display translated data for the fields that support it.
        //   minLength: 2
        //   pattern: ([a-z]{2})-([A-Z]{2})
        //   default: en-US
        request.add(parameter: HttpQueryParameter(name: "language", value: languageManager.language.rawValue))
        
        if endPoint.requiresAuth {
            request.add(parameter: HttpQueryParameter(name: "api_key", value: authenticationManager.apiKey))
        }
        
        return request
    }
    
}
