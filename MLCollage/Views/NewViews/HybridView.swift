//
//  HybridView.swift
//  MLCollage
//
//  Created by Robert Bates on 6/17/25.
//

import SwiftData
import SwiftUI

struct HybridView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]
    @Query private var backgrounds: [BackgroundModel]
    @Query private var settings: [SettingsModel]
    
    @State var title: String = "Test Title"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    subjectScrollView
                    backgroundScrollView
                }
                .padding(.vertical)
                settingsView
            }
        }
        .navigationTitle(title)
        .toolbarBackground (
            .accent, for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    @ViewBuilder var titleView: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .padding()
            Spacer()
            Text("Settings")
                .font(.headline)
                .foregroundStyle(.app)
                .padding(6.0)
                .background(.black.opacity(0.15))
                .clipShape(.rect(cornerRadius: 15.0))
        }
        .background(.accent)
        .clipShape(.rect(cornerRadius: 20.0))
        .foregroundStyle(.app)
        .shadow(radius: 5.0)
    }
    
    @ViewBuilder var subjectScrollView: some View {
        HStack {
            Text("Subjects")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            Button("Edit") {
                
            }
            .padding(.horizontal)
            Button("Add") {
                
            }
            .padding(.horizontal)
        }
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(subjects) { subject in
                    HeroView(subject: subject)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder var backgroundScrollView: some View {
        HStack {
            Text("Backgrounds")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            Button("Edit") {
                
            }
            .padding(.horizontal)
            Button("Add") {
                
            }
            .padding(.horizontal)
        }
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(backgrounds) { background in
                    Image(uiImage: background.toMLCImage().uiImage)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 10.0))
                        .frame(maxWidth: 100, maxHeight: 100)
                        .padding(3.0)
                }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding(.horizontal)
    }

    @ViewBuilder var settingsView: some View {
            VStack {
                HStack {
                    Text("Settings")
                        .font(.title)
                        .padding([.leading, .top])
                    Spacer()
                }
                SettingsView(settings: settings[0])
            }
            .background(.accent)
            .clipShape(.rect(cornerRadius: 20.0))
            .foregroundStyle(.app)
            .shadow(radius: 5.0)
            .ignoresSafeArea()
    }
}

#Preview {
    let preview = ContentViewContainer.mock

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}
