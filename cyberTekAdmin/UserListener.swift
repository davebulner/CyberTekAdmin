//
//  UserListener.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-30.
//

import Foundation
import Firebase

func downloadUser(userId: String, completion: @escaping(_ user: FUser) -> Void){
    
    FirebaseReference(.User).whereField(kID, isEqualTo: userId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {return }
        
        if !snapshot.isEmpty {
            let userData = snapshot.documents.first!.data()
            completion(FUser(userData as NSDictionary))
        }
    }
    
}
