//
//  NetworkUtility.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation
import SystemConfiguration
import UIKit

class NetworkUtility
{
    typealias ResultData = (_ result: Result<Data, SAError>) -> ()
    static let shareInstance = NetworkUtility()
    private init(){}
    
    enum JSONError: String, Error{
        case NoData = "No data"
    }
    
    var tryCount = 0
    
    func callData(requestType: ReqestType ,jsonInputData: Data?, subPath:String, completion: @escaping ResultData){
        if isInternetAvailable() {
            let urlPath = kBaseUrl + subPath
            guard let endpoint = NSURL(string: urlPath) else {
                completion(Result.fail(SAError.init(WebServiceError.invalidUrl, code: 401, description: "Error in creating endpoint")))
                return
            }
            var request = URLRequest(url:endpoint as URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = requestType.rawValue
            if requestType == .post , jsonInputData != nil{
                request.httpBody = jsonInputData!
            }
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                do{
                    guard error == nil else {
                        self.tryCount += 1
                        if self.tryCount < 3 {
                            self.callData(requestType: requestType, jsonInputData: jsonInputData, subPath: subPath, completion: completion)
                         } else {
                            completion(Result.fail(SAError.init(error!)))
                         }
                         return
                    }
                    
                    guard let data = data else{
                        throw JSONError.NoData
                    }
                    completion(Result.success(data))
                }
                catch {
                    completion(Result.fail(SAError.init(error)))
                }
                }.resume()
        }else{
            completion(Result.fail(SAError.init(WebServiceError.networkNotReachable, code: 400, description: "Please check your internet connection")))
        }
    }
    
    public func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

//MARK: Indicator Class
public class Indicator {
    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    static var isEnabledIndicator = true
    
    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = UIColor.white.withAlphaComponent(1.0)
    }
    
    func showIndicator(){
        DispatchQueue.main.async( execute: {
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
        })
    }
    func hideIndicator(){
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        })
    }
}
