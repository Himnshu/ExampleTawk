//
//  UserListViewControllerServiceMangerDelegate.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation

protocol UserListViewControllerServiceMangerDelegate : class{
    func UserListViewControllerServiceMangerDelegate(serviceManger: UserListViewControllerServiceManger, didFetchingData data: [UserData]?)
}

class UserListViewControllerServiceManger: NSObject, WebServiceClient{
    typealias DataModel = ([UserData])
    weak var delegate: UserListViewControllerServiceMangerDelegate?
    
    func callUserListWebAPI(id: Int) {
        let kApiValue = "\(kApiPagination)\(id)"
        self.callUserListData(ofRequestType: ReqestType.get, withInputModel: nil, atPath: kApiValue) { (result) in
            switch result{
            case .success(let apiResponse):
                Indicator.sharedInstance.hideIndicator()
                self.delegate?.UserListViewControllerServiceMangerDelegate(serviceManger: self, didFetchingData: apiResponse)
            case .fail(let error):
                Indicator.sharedInstance.hideIndicator()
                AppHelper.showAlert(error)
            }
        }
    }
}
