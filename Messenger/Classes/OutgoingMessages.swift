//
//  OutgoingMessages.swift
//  Messenger
//
//  Created by Kirk Washam on 3/11/19.
//  Copyright © 2019 StudioATX. All rights reserved.
//

import Foundation

class OutgoingMessage {

    let messageDictionary: NSMutableDictionary

//MARK: Initializers

//Text message
    init(message: String, senderId: String, senderName: String, date: Date, status: String, type: String) {
    
    messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
        
    }
    
    //picture message here
    init(message: String, pictureLink: String, senderId: String, senderName: String, date: Date, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, pictureLink, senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kPICTURE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
        
    }
    
    //Audio Message
    init(message: String, audio: String, senderId: String, senderName: String, date: Date, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, audio, senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kAUDIO as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    //Video Message
    init(message: String, video: String, thumbNail: NSData, senderId: String, senderName: String, date: Date, status: String, type: String) {
        
        let picThumb = thumbNail.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        messageDictionary = NSMutableDictionary(objects: [message, video, picThumb, senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kVIDEO as NSCopying, kPICTURE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
        
    }
    
    //Location Message
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: Date, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().string(from: date), status, type], forKeys: [kMESSAGE as NSCopying, kLATITUDE as NSCopying, kLONGITUDE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kDATE as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    
    
    //MARK: SendMessage
    
    func sendMessage(chatRoomId: String, messageDictionary: NSMutableDictionary, memberIds: [String], membersToPush: [String]) {
        
        let messageId = UUID().uuidString
        messageDictionary[kMESSAGEID] = messageId
        
        for memberId in memberIds {
            
            reference(.Message).document(memberId).collection(chatRoomId).document(messageId).setData(messageDictionary as! [String : Any])
            
        }
        
        updateRecents(chatRoomId: chatRoomId, lastMessage: messageDictionary[kMESSAGE] as! String)
        
        
        let pushText = "\(messageDictionary[kTYPE] as! String) message"
        print(pushText)
        print(membersToPush)
        sendPushNootification(membersToPush: membersToPush, message: pushText)
        
        
    }
    
    
    class func deleteMessage(withId: String, chatRoomId: String) {
        
        reference(.Message).document(FUser.currentId()).collection(chatRoomId).document(withId).delete()
        
    }
    
    class func updateMessage(withId: String, chatRoomId: String, memberIds: [String]) {
        
        let readDate = dateFormatter().string(from: Date())
        let values = [kSTATUS: kREAD, kREADDATE: readDate]
        
        for userId in memberIds {
            reference(.Message).document(userId).collection(chatRoomId).document(withId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    reference(.Message).document(userId).collection(chatRoomId).document(withId).updateData(values)
                }
            }
        }
    }
}
