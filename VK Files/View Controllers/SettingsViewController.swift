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
    
    var queryService: QueryService!
    var fileService: FileService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryService = QueryService()
        queryService.getUser() { result in
            switch result {
            case .success(let user):
                self.showUserInfo(for: user)
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
            }
        }
        fileService = FileService()
    }
    
    func showUserInfo(for user: User) {
        userNameLabel.text = user.firstName + " " + user.lastName
        profileImageView.loadImage(from: user.photoURL)
    }
    
    
    @IBAction func clearStorageAction(_ sender: Any) {
        fileService.removeAlldocuments()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        fileService.removeAlldocuments()
        UserDefaults.standard.removeObject(forKey: "sortMethod")
        
        VKSdk.forceLogout()
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInVC")
        AppDelegate.getInstance().window?.rootViewController = signInVC
    }
}
