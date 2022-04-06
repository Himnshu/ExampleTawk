//
//  WebServiceProtocol.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation

enum ReqestType:String{
    case post = "POST"
    case get = "GET"
}

enum WebServiceError: Error{
    case dataParsingFailed
    case dataModelParsingFailed
    case invalidResponse
    case resultValidationFailed
    case networkNotReachable
    case invalidUrl
    case jsonParsingFailed
}

protocol WebServiceClient {
    associatedtype DataModel:Decodable
    typealias ResultData = (_ result: Result<DataModel, SAError>) -> ()
    
    func callUserListData(ofRequestType requestType: ReqestType ,withInputModel inputDataModel: Encodable?, atPath path:String, completionHandler: @escaping ResultData)
    
    func callUserProfileData(ofRequestType requestType: ReqestType ,withInputModel inputDataModel: Encodable?, atPath path:String, completionHandler: @escaping ResultData)
}
extension WebServiceClient{
    func callUserListData(ofRequestType requestType: ReqestType ,withInputModel inputDataModel: Encodable? = nil, atPath path:String, completionHandler: @escaping ResultData){
        do{
            var inputData: Data?
            //encode model to data if needed
            if let inputModel = inputDataModel{
                inputData = try inputModel.getData()
            }
            //call network API
            NetworkUtility.shareInstance.callData(requestType: requestType, jsonInputData: inputData, subPath: path) { (result) in
                switch result{
                case .success(let data):
                    //decode data to model
                    do {
                        let json = try! JSON(data: data)
                        let value = json.arrayValue
                        DataModel.getDataModel(fromJsonObject: try value.getJsonObject(), completionHandler: { (result) in
                            completionHandler(result)
                        })
                    }catch {
                        print(error)
                    }
                case .fail(let error):
                    completionHandler(Result.fail(error))
                }
            }
        }
        catch {
            completionHandler(Result.fail(SAError.init(error)))
        }
    }
    
    func callUserProfileData(ofRequestType requestType: ReqestType ,withInputModel inputDataModel: Encodable? = nil, atPath path:String, completionHandler: @escaping ResultData){
        do{
            var inputData: Data?
            //encode model to data if needed
            if let inputModel = inputDataModel{
                inputData = try inputModel.getData()
            }
            //call network API
            NetworkUtility.shareInstance.callData(requestType: requestType, jsonInputData: inputData, subPath: path) { (result) in
                switch result{
                case .success(let data):
                    //decode data to model
                    do {
                        let json = try! JSON(data: data)
                        let value = json.dictionary
                        DataModel.getDataModel(fromJsonObject: try value.getJsonObject(), completionHandler: { (result) in
                            completionHandler(result)
                        })
                    }catch {
                        print(error)
                    }
                case .fail(let error):
                    completionHandler(Result.fail(error))
                }
            }
        }
        catch {
            completionHandler(Result.fail(SAError.init(error)))
        }
    }
}

