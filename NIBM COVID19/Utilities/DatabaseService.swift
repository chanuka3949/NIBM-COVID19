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
    
//    func getUserData() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        DatabaseService.databaseReference.child(Constants.users).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            //let value = snapshot.value as? NSDictionary
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    
}
