//
//  PushNotifications.swift
//  Messenger
//
//  Created by Kirk Washam on 3/30/19.
//  Copyright © 2019 StudioATX. All rights reserved.
//

import Foundation
import OneSignal

func sendPushNootification(membersToPush: [String], message: String) {
    
    let updateMembers = removeCurrentUserFromMembersArray(members: membersToPush)
    
    getMembersToPush(members: updateMembers) { (userPushIds) in
        
        let currentUser = FUser.currentUser()!
        print(userPushIds)
        OneSignal.postNotification(["contents" : ["en" : "\(currentUser.firstname) \n \(message)"], "ios_badgeType" : "Increase", "ios_badgeCount" : "1", "include_player_ids" : userPushIds])
    }
    
}

func removeCurrentUserFromMembersArray(members: [String]) -> [String] {
    
    var updatedMembers: [String] = []
    
    for memberId in members {
        if memberId != FUser.currentId() {
            updatedMembers.append(memberId)
        }
    }
    
    return updatedMembers
}

func getMembersToPush(members: [String], completion: @escaping (_ usersArray: [String]) -> Void) {
    
    var pushIds: [String] = []
    var count = 0
    
    for memberId in members {
        
        reference(.User).document(memberId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { completion(pushIds); return}
            
            if snapshot.exists {
                
                let userDictionary = snapshot.data() as! NSDictionary
                
                let fUser = FUser.init(_dictionary: userDictionary)
                
                pushIds.append(fUser.pushId!)
                count += 1
                
                if members.count == count {
                    completion(pushIds)
                }
                
            } else {
                completion(pushIds)
            }
        }
    }
    
}
