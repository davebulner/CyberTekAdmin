
//
//  FUser.swift
//  cybertek
//
//  Created by Dave Bulner on 2022-04-28.
//

import Foundation
import FirebaseAuth
import UIKit

class FUser {
    
    let id: String
    var email: String
    var fullName: String
    var phoneNumber: String
    
    var fullAddress: String?
    var onBoarding: Bool
    
    init(_id: String, _email: String, _fullName: String, _phoneNumber: String ){
        id = _id
        email = _email
        fullName = _fullName
        phoneNumber = _phoneNumber
        onBoarding = false
        
    }
    
    init(_ dictionary: NSDictionary){
        
        id = dictionary[kID] as? String ?? ""
        email = dictionary[kEMAIL] as? String ?? ""
        fullName = dictionary[kFULLNAME] as? String ?? ""
        phoneNumber = dictionary[kPHONENUMBER] as? String ?? ""
        fullAddress = dictionary[kFULLADDRESS] as? String ?? ""
        onBoarding = dictionary[kONBOARD] as? Bool  ?? false
        
    }
    
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            
            if let dictionary = userDefualts.object(forKey: kCURRENTUSER){
                return FUser.init(dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?,_ isEmailVerified: Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){(authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email) { (error) in
                        
                        completion(error, true)
                        
                    }
                    
                } else {
                    completion(error, false)
                }
                
            } else {
                completion(error, false)
            }
            
        }
    }
    
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {(authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                authDataResult!.user.sendEmailVerification { (error) in
                    print("Verification email sent error is: ", error?.localizedDescription)
                    
                }
            }
        }
    }
    
    class func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void){
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            completion(error)
        }
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void){
        
        do {
           
        try Auth.auth().signOut()
            
            userDefualts.removeObject(forKey: kCURRENTUSER)
            userDefualts.synchronize()
            
            completion(nil)
            
        } catch let error as Error {
            completion(error)
        }
        
    }
    
}

func downloadUserFromFirestore(userId: String, email: String, completion: @escaping(_ error: Error?) -> Void){
    FirebaseReference(.User).document(userId).getDocument { snapshot, error in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
            
        }else {
            let user = FUser(_id: userId, _email: email, _fullName: "", _phoneNumber: "")
            saveUserLocally(userDictionary: userDictionaryFrom(user: user) as NSDictionary)
            saveUserToFireStore(fUser: user)
        }
        
        completion(error)
        
    }
}


func saveUserToFireStore(fUser: FUser){
    FirebaseReference(.User).document(fUser.id).setData(userDictionaryFrom(user: fUser)) { (error) in
        
        if error != nil {
            print("Error creating fuser object: ", error!.localizedDescription)
        }
    }
}

func saveUserLocally(userDictionary: NSDictionary){
    
    userDefualts.set(userDictionary, forKey: kCURRENTUSER)
    userDefualts.synchronize()
}

func userDictionaryFrom(user: FUser) -> [String: Any] {
    
    return NSDictionary(objects: [
        user.id,
        user.email,
        user.fullName,
        user.fullAddress ?? "",
        user.onBoarding,
        user.phoneNumber
        
    ], forKeys: [
        kID as NSCopying,
        kEMAIL as NSCopying,
        kFULLNAME as NSCopying,
        kFULLADDRESS as NSCopying,
        kONBOARD as NSCopying,
        kPHONENUMBER as NSCopying
        
    
    ]) as! [String : Any]
}

func updateCurrentUser(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    
    if let dictionary = userDefualts.object(forKey: kCURRENTUSER){
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(FUser.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            if error == nil {
                saveUserLocally(userDictionary: userObject)
            }
            
        }
    }
    
}

