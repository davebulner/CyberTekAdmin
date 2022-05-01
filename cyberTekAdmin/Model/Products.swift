//
//  Products.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//


import Foundation
import SwiftUI

enum Category: String, CaseIterable, Codable, Hashable {
    case featured
    case newArrival
}

struct Products: Identifiable, Hashable {
    var id: String
    var name: String
    var imageName: String
    var category: Category
    var description: String
    var price: Double
    var formattedPrice: String { return "$\(price)"}
}

func productDictionaryFrom(products: Products) -> [String: Any]{
    return NSDictionary(objects: [
        products.id,
        products.name,
        products.imageName,
        products.category.rawValue,
        products.description,
        products.price
    
    ], forKeys: [
        kID as NSCopying,
        kNAME as NSCopying,
        kIMAGENAME as NSCopying,
        kCATEGORY as NSCopying,
        kDESCRIPTION as NSCopying,
        kPRICE as NSCopying
        
    ]) as! [String : Any]
}

func createProductList(){
    for products in productData{
        FirebaseReference(.ProductList).addDocument(data: productDictionaryFrom(products: products))
    }
}

let productData = [
    //FEATURED
    Products(id: UUID().uuidString, name: "MSI GE76 RAIDER RTX 3070 DRAGON EDITION", imageName: "msige76", category: Category.featured, description: "Espresso is the purest distillation of the coffee bean. It doesn’t refer to a bean or blend, but actually the preparation method.", price: 1200.00),
    
    Products(id: UUID().uuidString, name: "MSI GP76 Leopard 11UH i7 RTX 3080", imageName: "msigp76", category: Category.featured, description: "An Americano Coffee is an Espresso-based coffee drink with no special additions. Actually it is a shot of Espresso with hot water poured in it. A well-prepared Americano has the subtle aroma and flavour like Espresso. Benefits of Americano Coffee it has a lighter body and less bitterness.", price: 750.00),
    
    Products(id: UUID().uuidString, name: "Mi Curved Gaming Monitor 34", imageName: "micurved", category: Category.featured, description: "Outside of Italy, cappuccino is a coffee drink that today is typically composed of double espresso and hot milk, with the surface topped with foamed milk. Cappuccinos are most often prepared with an espresso machine.", price: 225.50),
    
        
                    
    //NEWARRIVAL
    Products(id: UUID().uuidString, name: "ASUS ZenBook Duo UX482 i5 with ScreenPad Plus", imageName: "asuszen", category: Category.newArrival, description: "Filter coffee brewing involves pouring hot water over coffee grounds. Gravity then pulls the water through the grounds, facilitating extraction, and dispenses it into a mug or carafe placed below.", price: 850.00),
    
    Products(id: UUID().uuidString, name: "PLAYSTATION 5 STANDARD EDITION", imageName: "ps5", category: Category.newArrival, description: "Filter coffee brewing involves pouring hot water over coffee grounds. Gravity then pulls the water through the grounds, facilitating extraction, and dispenses it into a mug or carafe placed below.", price: 650.00),

    Products(id: UUID().uuidString, name: "MSI RTX 3080TI GAMING TRIO 12GB", imageName: "rtx3080", category: Category.newArrival, description: "Cold brew is really as simple as mixing ground coffee with cool water and steeping the mixture in the fridge overnight.", price: 1100.50),
    
]

