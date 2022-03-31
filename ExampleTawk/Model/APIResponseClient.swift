//
//  APIResponseClient.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation
struct APIResponseClient<T: Codable>: Codable {
    var data: T?
    func validate() -> Bool {
        return true
    }
}
