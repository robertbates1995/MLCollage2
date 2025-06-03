//
//  AboutView.swift
//  MLCollage
//
//  Created by Robert Bates on 4/7/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text(
                "MLCollage is an application used for generating large sets of novel images to be used in the training of machine learning models. It was created by Robert Bates."
            )
            .padding()
            Text(
                "MLCollage is open source. You can find the code on GitHub here:"
            )
            .padding()
            Link(
                destination: URL(
                    string: "https://github.com/robertbates1995/MLCollage"
                )!,
                label: {
                    HStack {
                        Text("GitHub")
                        Image(.githubIcon)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                }
            )
            Spacer()
            Text("Version 1.0.0")
                .padding()
        }
    }
}

#Preview {
    AboutView()
}
