//
//  Result.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation

enum Result<T,U: SAError>{
    case success(T)
    case fail(U)
}

class SAError {
    var error: Error
    var code: Int?
    var description: String?
    
    init(_ error: Error) {
        self.error = error
    }
    
    init(_ error: Error, code: Int? = nil, description: String? = nil) {
        self.error = error
        self.code = code
        self.description = description
    }
}
