//
//  ContentView.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var orderlistener = OrderListener()

    var body: some View {

        NavigationView{
            List{
                    ForEach(self.orderlistener.activeOrders ?? []){
                        order in
                        
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            
                            HStack{
                                Text(order.customerName)
                                Spacer()
                                Text("$\(order.amount.clean)")
                            }
                        }

                    }
                    
                
                
            }.navigationBarTitle("Orders")
            //end list
        }//nav view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
