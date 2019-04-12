//
//  ProfileViewTableViewController.swift
//  Messenger
//
//  Created by Kirk Washam on 3/9/19.
//  Copyright © 2019 StudioATX. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileViewTableViewController: UITableViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var messageButtonOutlet: UIButton!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var blockButtonOutlet: UIButton!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user: FUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      setupUI()
    }
    
    //MARK: IBActions
    
    @IBAction func callButtonPressed(_ sender: Any) {
        
        callUser()
        
        let currentUser = FUser.currentUser()!
        
        let call = CallClass(_callerId: currentUser.objectId, _withUserId: user!.objectId, _callerFullName: currentUser.fullname, _withUserFullName: user!.fullname)
        
        call.saveCallInBackground()
        
    }
    
    @IBAction func chatButtonPressed(_ sender: Any) {
        if !checkBlockedStatus(withUser: user!) {
            
            let chatVC = ChatViewController()
            chatVC.titleName = user!.firstname
            chatVC.membersToPush = [FUser.currentId(), user!.objectId]
            chatVC.memberIds = [FUser.currentId(), user!.objectId]
            chatVC.chatRoomId = startPrivateChat(user1: FUser.currentUser()!, user2: user!)
            
            chatVC.isGroup = false
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        } else {
            ProgressHUD.showError("This User is not available for chat!")
        }
    }
    
    @IBAction func blockUserButtonPressed(_ sender: Any) {
        
        
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId) {
            
            currentBlockedIds.remove(at: currentBlockedIds.index(of: user!.objectId)!)
        } else {
            currentBlockedIds.append(user!.objectId)
        }
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : currentBlockedIds]) { (error) in
            if error != nil {
                print("error updating user \(error!.localizedDescription)")
                return
            }
            self.updateBlockStatus()
        }
        
        blockUser(userToBlock: user!)
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    
    //MARK: Setup UI
    
    func setupUI() {
        
        if user != nil {
            self.title = "Profile"
            fullNameLabel.text = user!.fullname
            phoneNumberLabel.text = user!.phoneNumber
            
            updateBlockStatus()
            
            imageFromData(pictureData: user!.avatar) { (avatarImage) in
                
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
        
    }
    
    func updateBlockStatus() {
        
        if user!.objectId != FUser.currentId() {
            blockButtonOutlet.isHidden = false
            messageButtonOutlet.isHidden = false
            callButtonOutlet.isHidden = false
            
        } else {
            blockButtonOutlet.isHidden = true
            messageButtonOutlet.isHidden = true
            callButtonOutlet.isHidden = true
        }
        
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId) {
            
            blockButtonOutlet.setTitle("Unblock User", for: .normal)
            
        } else {
            blockButtonOutlet.setTitle("Block User", for: .normal)
        }
        
    }
    
    //MARK: CallUser
    
    
    func callClient() -> SINCallClient {
        return appDelegate._client.call()
    }
    
    
    func callUser() {
        
        let userToCall = user!.objectId
        let call = callClient().callUser(withId: userToCall)
        
        let callVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CallVC") as! CallViewController
        
        callVC._call = call
        self.present(callVC, animated: true, completion: nil)
    }

}
