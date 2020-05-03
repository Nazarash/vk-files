//
//  SettingsViewController.swift
//  VK Files
//
//  Created by Дмитрий on 17.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit
import VKSdkFramework

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    let queryService =  QueryService()
    let fileService = FileService()
    let coreDataManager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedUser = coreDataManager.getUserInfo() {
            showUserInfo(for: savedUser)
        }
        queryService.getUser() { result in
            switch result {
            case .success(let user):
                self.showUserInfo(for: user)
                self.coreDataManager.setUserInfo(user)
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    func showUserInfo(for user: User) {
        userNameLabel.text = user.firstName + " " + user.lastName
        profileImageView.loadImage(from: user.photoURL)
    }
    
    
    @IBAction func clearStorageAction(_ sender: Any) {
        fileService.removeAlldocuments()
        showAlert(name: "Done", with: "All local files are removed")
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        fileService.removeAlldocuments()
        UserDefaults.standard.removeObject(forKey: "sortMethod")
        coreDataManager.clearDatabase()
        VKSdk.forceLogout()
        let signInVC = UIViewController.initFromStoryboard(id: .SignInVC)
        AppDelegate.getInstance().window?.rootViewController = signInVC
    }
}
