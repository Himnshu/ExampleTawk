//
//  UserDetailViewController.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import UIKit

class UserDetailViewController: BaseViewController {

    @IBOutlet weak var mAvtarImageView: UIImageView!
    @IBOutlet var serviceProfile: UserProfileViewControllerServiceManger!
    @IBOutlet weak var mFollowersLbl: UILabel!
    @IBOutlet weak var mFollowingLbl: UILabel!
    @IBOutlet weak var mNameLbl: UILabel!
    @IBOutlet weak var mCompanyLbl: UILabel!
    @IBOutlet weak var mBlogLbl: UILabel!
    @IBOutlet weak var mNoteTxtView: UITextView!
    @IBOutlet weak var mSaveBtn: UIButton!

    var userDataModel : UserData?
    
    @IBOutlet weak var mStackViewVertical: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIWithModes()
        loadUserProfileData(username: userDataModel?.login ?? "")
        // Do any additional setup after loading the view.
    }
    
    func updateUIWithModes() {
        mNoteTxtView.layer.borderColor = UITraitCollection.current.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        mNoteTxtView.layer.borderWidth = 1
        
        mSaveBtn.layer.borderColor = UITraitCollection.current.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        mSaveBtn.layer.borderWidth = 1
        let color = UITraitCollection.current.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        mSaveBtn.setTitleColor(color, for: .normal)
        
        setBackButton()
        setTitle(title: userDataModel?.login ?? "")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUIWithModes()
    }
    
    func getUserProfileFromDB() -> UserData? {
        let user = self.getUserProfileData(userDataModel!)
        return user
    }
    
    func loadUserProfileData(username: String) {
        Indicator.sharedInstance.showIndicator()
        self.serviceProfile.delegate = self
        self.serviceProfile.callUserProfileWebAPI(username: username)
    }
    
    func updateProfileDataUI(userData : UserData) {
        userDataModel = userData
        DispatchQueue.main.async{
            self.mAvtarImageView.sd_setImage(with: URL(string:self.userDataModel?.avatar_url ?? ""), completed: { (image, error, type, url) in
                self.mAvtarImageView.image = image
            })
            
            self.mFollowersLbl.text = "\(userData.followers!)"
            self.mFollowingLbl.text = "\(userData.following!)"
            self.mNameLbl.text = userData.name
            self.mCompanyLbl.text = userData.company
            self.mBlogLbl.text = userData.blog
            self.mNoteTxtView.text = userData.Note
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if mNoteTxtView.text.isEmpty {
            AppHelper.showAlert(title: "Error", subtitle: "Note Required")
            return
        }
        Indicator.sharedInstance.showIndicator()
        userDataModel?.Note = mNoteTxtView.text
        userDataModel?.isNote = true
        guard let result = self.updateUserNote(userDataModel!) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if result {
                Indicator.sharedInstance.hideIndicator()
                AppHelper.showAlert(title: "Success", subtitle: "Notes Updated Successfully")
            }
            else{
                Indicator.sharedInstance.hideIndicator()
                AppHelper.showAlert(title: "Error", subtitle: "Something went wrong!!!")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserDetailViewController: UserProfileViewControllerServiceMangerDelegate{
    func UserProfileViewControllerServiceMangerDelegate(serviceManger: UserProfileViewControllerServiceManger, didFetchingData data: UserData?){
        var userData = data
        self.updateProfileData(data!)
        let userDataModel = self.getUserProfileFromDB()
        userData?.Note = userDataModel?.Note
        userData?.isNote = userDataModel?.isNote
        updateProfileDataUI(userData: userData!)
    }
}
