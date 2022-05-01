//
//  UserDetailView.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//

import SwiftUI

struct UserDetailView: View {
    
    
    var order: Order
    @State var user: FUser?
    
    var body: some View {
        
        List{
        
        Section{
            Text(user?.fullName ?? "")
            Text(user?.email ?? "")
            Text(user?.phoneNumber ?? "")
            Text(user?.fullAddress ?? "")
        }
    }
        .listStyle(GroupedListStyle())
        .navigationTitle("Customer Profile")
        .onAppear{
            getUser()
        }
    }
    
    private func getUser(){
        downloadUser(userId: self.order.customerId) { (fuser) in
            self.user = fuser
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(order: Order())
    }
}
