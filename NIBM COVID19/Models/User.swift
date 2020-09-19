//
//  User.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/19/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import Foundation

struct User {
    var uid: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var userId: String?
    var address: String?
    var role: Role.RawValue?
    var imageURL: String?
}

enum Role: Int{
    case Student = 0
    case Staff = 1
}
