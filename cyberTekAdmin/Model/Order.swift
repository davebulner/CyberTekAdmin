//
//  Order.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.

import Foundation

class Order: Identifiable {
    
    var id: String!
    var customerId: String!
    var orderItems: [Products] = []
    var amount: Double!
    var customerName: String!
    
    func saveOrderToFirestore(){
        
        FirebaseReference(.Order).document(self.id).setData(orderDictionaryFrom(self)) {
            error in
            
            if error != nil {
                print("error saving order to firestore:", error!.localizedDescription)
            }
        }
    }
}


func orderDictionaryFrom (_ order: Order) -> [String : Any] {
    
    var allProductsIds:  [String] = []
    
    for products in order.orderItems{
        allProductsIds.append(products.id)
        
    }
    return NSDictionary(objects: [
        order.id,
        order.customerId,
        allProductsIds,
        order.amount,
        order.customerName
    ],
        forKeys: [kID as NSCopying,
                  kCUSTOMERID as NSCopying,
                  kPRODUCTIDS as NSCopying,
                  kAMOUNT as NSCopying,
                  kCUSTOMERNAME as NSCopying
                 ]) as! [String : Any]
    
}

