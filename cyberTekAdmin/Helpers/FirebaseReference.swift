//
//  FirebaseReference.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//


import Foundation
import FirebaseFirestore


enum FcollectionReference: String {
    case User
    case ProductList
    case Order
    case Cart
}

func FirebaseReference(_ collectionReference: FcollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}

