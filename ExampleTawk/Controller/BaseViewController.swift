//
//  BaseViewController.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setTitle(title:String) {
        self.navigationController?.isNavigationBarHidden = false
        let titleLabel = UILabel(frame: CGRect(x: 50, y:5, width:100, height:18))
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.textColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.navigationItem.titleView = titleLabel
    }
    
    func setBackButton(){
        var yourBackImage = UIImage(named: "back")
        yourBackImage = yourBackImage?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton() //Custom back Button
        backButton.frame = CGRect(x: 0, y: 0, width: 42, height: 36)
        backButton.setImage(yourBackImage, for: UIControl.State.normal)
        backButton.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        backButton .addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        //ios 11
        backButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
   
    //Back Button Action
    @objc func backButtonAction() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func hideNavigationBar()  {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationBar()  {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func OpenUserDetailVC(userDataM: UserData) {
        let mainStoryboard = UIStoryboard(storyboard: .Main)
        let userDetailVC = mainStoryboard.instantiateViewController(withIdentifier: kUserDetailVC) as! UserDetailViewController
        userDetailVC.userDataModel = userDataM
        self.navigationController?.pushViewController(userDetailVC, animated: false)
    }
    
    func popToViewController() {
        self.navigationController?.popViewController(animated: false)
    }
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
     }
    
    func getUserDataListFromDB() -> [UserData]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var userDataModels = [UserData]()
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                var userDataModel = UserData()
                userDataModel.avatar_url = data.value(forKey: "avtar") as! String?
                userDataModel.login = data.value(forKey: "username") as? String
                userDataModel.id = data.value(forKey: "id") as? Int
                userDataModel.name = data.value(forKey: "name") as? String
                userDataModel.email = data.value(forKey: "email") as? String
                userDataModel.isNote = data.value(forKey: "isNote") as? Bool
                userDataModel.Note = data.value(forKey: "note") as? String
                userDataModel.type = data.value(forKey: "type") as? String
                userDataModel.followers = data.value(forKey: "followers") as? Int
                userDataModel.following = data.value(forKey: "following") as? Int
                userDataModel.bio = data.value(forKey: "bio") as? String
                userDataModel.location = data.value(forKey: "location") as? String
                userDataModel.blog = data.value(forKey: "blog") as? String
                userDataModel.company = data.value(forKey: "company") as? String
                userDataModels.append(userDataModel)
            }
            return userDataModels
        } catch {
            print("Failed")
            return nil
        }
    }
    
    func saveUserDataInDB(_ users: [UserData]) {
        for user in users {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntityName)
            request.predicate = NSPredicate(format: "id=%@", "\(user.id!)")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                if !result.isEmpty {
                    continue
                }
            } catch {
                print("Failed")
            }
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: kUserEntityName, into: context)
            newUser.setValue(user.avatar_url, forKey: "avtar")
            newUser.setValue(user.login, forKey: "username")
            newUser.setValue(user.id, forKey: "id")
            newUser.setValue(user.name, forKey: "name")
            newUser.setValue(user.email, forKey: "email")
            newUser.setValue(user.isNote, forKey: "isNote")
            newUser.setValue(user.Note, forKey: "note")
            newUser.setValue(user.type, forKey: "type")
            newUser.setValue(user.followers, forKey: "followers")
            newUser.setValue(user.following, forKey: "following")
            newUser.setValue(user.bio, forKey: "bio")
            newUser.setValue(user.location, forKey: "location")
            newUser.setValue(user.blog, forKey: "blog")
            newUser.setValue(user.company, forKey: "company")
            
            do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }
        }
    }
    
    func getUserProfileData(_ user: UserData) -> UserData? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntityName)
        request.predicate = NSPredicate(format: "id=%@", "\(user.id!)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if !result.isEmpty {
                let data = result.first! as! NSManagedObject
                var userDataModel = UserData()
                userDataModel.avatar_url = data.value(forKey: "avtar") as! String?
                userDataModel.login = data.value(forKey: "username") as? String
                userDataModel.id = Int(data.value(forKey: "id") as! Int32)
                userDataModel.name = data.value(forKey: "name") as? String
                userDataModel.email = data.value(forKey: "email") as? String
                userDataModel.isNote = data.value(forKey: "isNote") as? Bool
                userDataModel.Note = data.value(forKey: "note") as? String
                userDataModel.type = data.value(forKey: "type") as? String
                userDataModel.followers = data.value(forKey: "followers") as? Int
                userDataModel.following = data.value(forKey: "following") as? Int
                userDataModel.bio = data.value(forKey: "bio") as? String
                userDataModel.location = data.value(forKey: "location") as? String
                userDataModel.blog = data.value(forKey: "blog") as? String
                userDataModel.company = data.value(forKey: "company") as? String
                return userDataModel
            }
            return nil
        } catch {
            print("Failed")
            return nil
        }
    }
    
    func updateProfileData(_ user: UserData) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntityName)
        request.predicate = NSPredicate(format: "id=%@", "\(user.id ?? 0)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if !result.isEmpty {
                let data = result.first! as! NSManagedObject
                data.setValue(user.name, forKey: "name")
                data.setValue(user.email, forKey: "email")
                data.setValue(user.followers, forKey: "followers")
                data.setValue(user.following, forKey: "following")
                data.setValue(user.bio, forKey: "bio")
                data.setValue(user.location, forKey: "location")
                data.setValue(user.blog, forKey: "location")
                data.setValue(user.company, forKey: "location")
                do {
                    try context.save()
                    print("Success")
                } catch {
                    print("Error saving: \(error)")
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    func updateUserNote(_ user: UserData) -> Bool? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntityName)
        request.predicate = NSPredicate(format: "id=%@", "\(user.id!)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if !result.isEmpty {
                let data = result.first! as! NSManagedObject
                data.setValue(user.Note, forKey: "note")
                data.setValue(user.isNote, forKey: "isNote")
                do {
                    try context.save()
                    print("Success")
                    return true
                } catch {
                    print("Error saving: \(error)")
                    return false
                }
            }
            return false
        } catch {
            print("Failed")
            return false
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
