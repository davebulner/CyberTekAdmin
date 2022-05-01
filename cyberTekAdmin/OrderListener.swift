//
//  OrderListener.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//


import Foundation
import Firebase
import UIKit

class OrderListener: ObservableObject {
    
    @Published var activeOrders: [Order]!
    
    init(){
        
        downloadOrder()
    }
    
    func downloadOrder(){
        
            
            FirebaseReference(.Order).addSnapshotListener{
                (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if !snapshot.isEmpty {
                    
                    self.activeOrders = []
                    
                    for order in snapshot.documents{
                        
                        let orderData = order.data()
                        
                        getProductsFromFirestore(withIds: orderData[kPRODUCTIDS] as? [String] ?? []){
                            (allProducts) in
                            
                            let order = Order()
                            order.customerId = orderData[kCUSTOMERID] as? String
                            order.id = orderData[kID] as? String
                            order.orderItems = allProducts
                            order.amount = orderData[kAMOUNT] as? Double
                            order.customerName = orderData[kCUSTOMERNAME] as? String ?? ""
                        
                            self.activeOrders.append(order)
                        }
                        
                    }
                    
                    
                    
                }
                
            }
    
    }
    
}


func getProductsFromFirestore (withIds: [String], completion: @escaping (_ productsArray: [Products]) -> Void){
    
    var count = 0
    var productsArray: [Products] = []
    
    if withIds.count == 0 {
        
        completion(productsArray)
        return
        
    }
    
    for productsId in withIds{
    
        FirebaseReference(.ProductList).whereField(kID, isEqualTo: productsId).getDocuments{(snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty{
                
                let productsData = snapshot.documents.first!
                
                productsArray.append(Products(id: productsData[kID] as? String ?? UUID().uuidString, name: productsData[kNAME] as? String ?? "Unknown", imageName: productsData[kIMAGENAME] as? String ?? "Unkwon", category: Category(rawValue: productsData[kCATEGORY] as? String ?? "featured") ?? .featured, description: productsData[kDESCRIPTION] as? String ?? "Description is missing", price: productsData[kPRICE] as? Double ?? 0.00))
                
                count += 1
                
            }else {
                print("Have no Products")
                completion(productsArray)
            }
            
            if count == withIds.count {
                completion(productsArray)
            }
        }
        
    }
    
}


