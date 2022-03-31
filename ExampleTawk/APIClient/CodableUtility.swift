//
//  CodableUtility.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation

extension Encodable{
    func getData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func getJsonObject() throws -> Any{
        return try JSONSerialization.jsonObject(with: self.getData(), options: .allowFragments)
    }
}

extension Decodable{
    static func getDataModel(fromData jsonData: Data, completionHandler: (_ result: Result<Self, SAError>) -> ()){
        do {
            let apiResponse = try JSONDecoder().decode(Self.self, from: jsonData)
            completionHandler(Result.success(apiResponse))
        } catch {
            if let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary{
                print(jsonDict ?? "unable to parse json object") //To see unexpected json data
            }
            completionHandler(Result.fail(SAError.init(error)))
        }
    }
    static func getDataModel(fromJsonObject object: Any, completionHandler: (_ result: Result<Self, SAError>) -> ()){
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            self.getDataModel(fromData: data, completionHandler: { (result) in
                 completionHandler(result)
            })
        } catch {
            completionHandler(Result.fail(SAError.init(error)))
        }
    }
}

