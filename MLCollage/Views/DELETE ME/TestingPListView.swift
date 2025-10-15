//
//  TestingPListView.swift
//  MLCollage
//
//  Created by Robert Bates on 10/15/25.
//

import SwiftUI

struct TestingPListView: View {
    let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    var body: some View {
        Text("version \(versionString)")
    }
}

#Preview {
    TestingPListView()
}
