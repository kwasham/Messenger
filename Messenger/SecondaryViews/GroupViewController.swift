//
//  GroupViewController.swift
//  Messenger
//
//  Created by Kirk Washam on 3/29/19.
//  Copyright © 2019 StudioATX. All rights reserved.
//

import UIKit
import ProgressHUD

class GroupViewController: UIViewController {
    
    @IBOutlet weak var cameraButtonOutlet: UIImageView!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet var iconTapGesture: UITapGestureRecognizer!
    
    var group: NSDictionary!
    var groupIcon: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButtonOutlet.isUserInteractionEnabled = true
        cameraButtonOutlet.addGestureRecognizer(iconTapGesture)
        
        setupUI()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Invite Users", style: .plain, target: self, action: #selector(self.inviteUsers))]
        
    }

    
    //MARK: IBActions
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        showIconOptions()
        
    }
    
    
    
    @IBAction func cameraIconTapped(_ sender: Any) {
        
        showIconOptions()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        var withValues: [String : Any]!
        
        if groupNameTextField.text != "" {
            withValues = [kNAME : groupNameTextField.text!]
        } else {
            ProgressHUD.showError("Subject is required")
            return
        }
        
        let avatarData = cameraButtonOutlet.image?.jpegData(compressionQuality: 0.7)!
        
        let avatarString = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        withValues = [kNAME : groupNameTextField.text!, kAVATAR : avatarString!]
        
        Group.updateGroup(groupId: group[kGROUPID] as! String, withValues: withValues)
        
        withValues = [kWITHUSERFULLNAME : groupNameTextField.text!, kAVATAR : avatarString]
        
        updateExistingRecentWithNewValues(chatRoomId: group[kGROUPID] as! String, members: group[kMEMBERS] as! [String], withValues: withValues)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func inviteUsers() {
        
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteUsersTableView") as! InviteUsersTableViewController
        
        userVC.group = group
        self.navigationController?.pushViewController(userVC, animated: true)
        
    }
    
    
    //MARK: Helpers
    
    func setupUI() {
        
        self.title = "Group"
        groupNameTextField.text = group[kNAME] as? String
        imageFromData(pictureData: group[kAVATAR] as! String) { (avatarImage) in
            if avatarImage != nil {
                self.cameraButtonOutlet.image = avatarImage!.circleMasked
            }
        }
    }
    
    
    func showIconOptions() {
        
        let optionMenu = UIAlertController(title: "Choose group Icon", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take/Choose Photo", style: .default) { (alert) in
            
            print("Camera")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
            
        }
        
        if groupIcon != nil {
            
            let resetAction = UIAlertAction(title: "Reset", style: .default) { (alert) in
                
                self.groupIcon = nil
                self.cameraButtonOutlet.image = UIImage(named: "cameraIcon")
                self.editButtonOutlet.isHidden = true
            }
            optionMenu.addAction(resetAction)
            
        }
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        
        if ( UI_USER_INTERFACE_IDIOM() == .pad) {
            if let currentPopoverPresentationController = optionMenu.popoverPresentationController {
                currentPopoverPresentationController.sourceView = editButtonOutlet
                currentPopoverPresentationController.sourceRect = editButtonOutlet.bounds
                
                currentPopoverPresentationController.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }
        } else {
            self.present(optionMenu, animated: true, completion: nil)
        }
        
        
    }
    
}
