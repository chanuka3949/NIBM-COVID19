//
//  DatabaseService.swift
//  NIBM COVID19
//
//  Created by Chanuka on 9/1/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import Firebase

struct DatabaseService {
    static let sharedInstance = DatabaseService()
    static let databaseReference = Database.database().reference()
}
