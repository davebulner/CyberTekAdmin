//
//  OrderDetailView.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//

import SwiftUI

struct OrderDetailView: View {
    
    var order: Order
    
    var body: some View {
        
        VStack{
            List{
                Section(header: Text("Customer")){
                    NavigationLink(destination: UserDetailView(order: order)) {
                        
                        Text(order.customerName)
                            .font(.headline)
                    }
                    
                }
                
                Section(header: Text("Order Items")){
                    
                    ForEach(self.order.orderItems){
                        products in
                        
                        HStack{
                            Text(products.name)
                            Spacer()
                            Text("$\(products.price.clean)")
                        }
                    }
                }
            }
        }//end vstack
        .navigationTitle("Order Details")
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order())
    }
}
