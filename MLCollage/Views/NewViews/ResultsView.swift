//
//  ResultsView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/18/25.
//

import SwiftUI

struct ResultsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Results")
                    .font(.largeTitle)
                    .padding(.horizontal)
                Spacer()
                Button("View All") {

                }
                .padding(5.0)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10.0)
                .padding(.horizontal)
            }
            .background(.secondaryAccent)
            VStack {
                //make gridview here
                    
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10.0)
            .padding(.horizontal)
            Spacer()
        }
        .navigationBarTitle("Results")
    }
}

#Preview {
    ResultsView()
}
