//
//  UserProfileViewControllerServiceManger.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation
import SwiftyJSON

protocol UserProfileViewControllerServiceMangerDelegate : class {
    func UserProfileViewControllerServiceMangerDelegate(serviceManger: UserProfileViewControllerServiceManger, didFetchingData data: UserData?)
}

class UserProfileViewControllerServiceManger: NSObject, WebServiceClient{
    typealias DataModel = (UserData)
    weak var delegate: UserProfileViewControllerServiceMangerDelegate?
    
    func callUserProfileWebAPI(username: String) {
        let kApiValue = "\(kApiProfileInfo)\(username)"
        self.callUserProfileData(ofRequestType: ReqestType.get, withInputModel: nil, atPath: kApiValue) { (result) in
            switch result{
            case .success(let apiResponse):
                Indicator.sharedInstance.hideIndicator()
                self.delegate?.UserProfileViewControllerServiceMangerDelegate(serviceManger: self, didFetchingData: apiResponse)
            case .fail(let error):
                Indicator.sharedInstance.hideIndicator()
                AppHelper.showAlert(error)
            }
        }
    }
}
