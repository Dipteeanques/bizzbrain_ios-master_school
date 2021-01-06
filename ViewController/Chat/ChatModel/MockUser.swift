//
//  MockUser.swift
//  bizzbrains
//
//  Created by Anques on 31/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation
import MessageKit

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
