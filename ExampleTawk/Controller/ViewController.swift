//
//  ViewController.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import UIKit
import PaginatedTableView

class ViewController: BaseViewController {

    @IBOutlet var searchBarView: UISearchBar!
    @IBOutlet weak var mTableView: PaginatedTableView!
    @IBOutlet var service: UserListViewControllerServiceManger!
    internal var userArray = [UserData]()
    internal var dataArray = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBarView
        mTableView.paginatedDelegate = self
        mTableView.paginatedDataSource = self
        searchBarView.delegate = self
        mTableView.enablePullToRefresh = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserList(id: 0)
    }

    func getUserList(id: Int) {
        if !dataArray.isEmpty {
            dataArray.removeAll()
        }
        if !userArray.isEmpty{
            userArray.removeAll()
        }
        Indicator.sharedInstance.showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let itemData = self.getUserDataListFromDB()
            if itemData?.count ?? 0 > 0 {
                Indicator.sharedInstance.hideIndicator()
                self.updateUserList(itemData: itemData!)
            }
            else{
                self.loadMoreUsers(id: 0)
            }
        }
    }
    
    func loadMoreUsers(id: Int)  {
        Indicator.sharedInstance.showIndicator()
        service.delegate = self
        service.callUserListWebAPI(id: id)
    }
    
    func updateUserList(itemData:[UserData]) {
        dataArray.append(contentsOf: itemData)
        userArray.append(contentsOf: itemData)
        DispatchQueue.main.async{
            self.mTableView.reloadData()
        }
    }
}

extension ViewController: UserListViewControllerServiceMangerDelegate{
    func UserListViewControllerServiceMangerDelegate(serviceManger: UserListViewControllerServiceManger, didFetchingData data: [UserData]?){
        saveUserDataInDB(data!)
        self.updateUserList(itemData: data!)
    }
}

//
// MARK: Paginated Delegate - Where magic happens
//
extension ViewController: PaginatedTableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        if (pageSize <= self.userArray.count){
            let mUserDataModel = self.userArray[pageSize]
            loadMoreUsers(id: mUserDataModel.id ?? 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onSuccess?(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mUserDataModel = self.userArray[indexPath.row]
        self.OpenUserDetailVC(userDataM: mUserDataModel)
    }
}

//
// MARK: Paginated Data Source
//
extension ViewController: PaginatedTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUserTableViewCell, for: indexPath as IndexPath) as! UserTableViewCell
        let mUserDataModel = self.userArray[indexPath.row]
        cell.updateUI(userDataModel: mUserDataModel)
        cell.mAvtarImageView.roundedImage()
        return cell
    }
}
extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.userArray = searchText.isEmpty ? self.dataArray : self.userArray.filter({(dataModel: UserData) -> Bool in
            if ((dataModel.login?.contains(searchText)) != nil){
                return dataModel.login?.range(of: searchText, options: .caseInsensitive) != nil
            }
            return dataModel.Note?.range(of: searchText, options: .caseInsensitive) != nil
        })

        mTableView.reloadData()
    }
}
