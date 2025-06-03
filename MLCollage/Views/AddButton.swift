//
//  addButton.swift
//  MLCollage
//
//  Created by Robert Bates on 5/27/25.
//

import SwiftUI

struct AddButton: View {
    var action: () -> () = {}
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 80.0, height: 80.0)
                }
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 20.0, trailing: 10.0))
            }
        }
    }
}

#Preview {
    AddButton()
}
