//
//  Constants.swift
//  bizzbrains
//
//  Created by Anques on 31/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Firebase
import FirebaseDatabase

struct Constants
{
    struct refs1
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("Inbox")
    }
    
    struct refs2
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("Users")
    }
    
    struct refs3
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chat").child(strChatIdRoot)
    }
}

var strChatIdRoot = ""

struct Inbox {
    let date = "date"
    let msg = "msg"
    let name = "name"
    let rid = "rid"
    let status = "status"
    let timestamp = "timestamp"
}

struct Users {
    let id = "id"
    let username = "username"
}

//struct chat {
    let chat_id = "chat_id"
    let pic_url = "pic_url"
    let receiver_id = "receiver_id"
    let sender_id = "sender_id"
    let sender_name = "sender_name"
    let status = "status"
    let text = "text"
    let time = "time"
    let timestamp = "timestamp"
    let type1 = "type"
//}

