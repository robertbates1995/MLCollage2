//
//  ResultsView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/18/25.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    @Environment(\.modelContext) private var modelContext
    //@Query private var results: [OutputModel]
    
    var body: some View {
        VStack {
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
    NavigationView {
        ResultsView()
    }
}
