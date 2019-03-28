//
//  NewGroupViewController.swift
//  Messenger
//
//  Created by Kirk Washam on 3/27/19.
//  Copyright © 2019 StudioATX. All rights reserved.
//

import UIKit
import ProgressHUD

class NewGroupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GroupMemberCollectionViewCellDelegate {
    
    
    @IBOutlet weak var editAvatarButtonOutlet: UIButton!
    @IBOutlet weak var GroupIconImageView: UIImageView!
    @IBOutlet weak var GroupSubjectTextField: UITextField!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memberIds: [String] = []
    var allMembers: [FUser] = []
    var groupIcon: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
