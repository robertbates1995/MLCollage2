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
    
    @State var title: String = "Test Title"
    
    let backgroundColor: Color = Color(UIColor.secondarySystemBackground)
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer()
                    subjectScrollView
                    Spacer()
                    backgroundScrollView
                    Spacer()
                }
                .padding(.vertical)
                settingsView
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    @ViewBuilder var subjectScrollView: some View {
        HStack {
            Text("Subjects")
                .font(.headline)
                .padding(.horizontal)
            Spacer()
            NavigationLink("Edit", destination: { AllSubjectsView() })
                .padding(.horizontal)
                .padding(.vertical, 2.0)
                .background(backgroundColor)
                .clipShape(.rect(cornerRadius: 15.0))
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
            NavigationLink("Edit", destination: { AllBackgroundsView() })
                .padding(.horizontal)
                .padding(.vertical, 2.0)
                .background(backgroundColor)
                .clipShape(.rect(cornerRadius: 15.0))
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

    //TODO: styalize settings, add background to controll panel

    @ViewBuilder var settingsView: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal, .top])
            VStack {
                SettingsViewWrapper()
            }
            .background(.black.opacity(0.08))
            .clipShape(.rect(cornerRadius: 10.0))
            .foregroundStyle(.app)
            .padding([.horizontal, .bottom], 15.0)
        }
        .background(.accent)
        .clipShape(.rect(cornerRadius: 10.0))
        .foregroundStyle(.app)
        .shadow(radius: 5.0)
    }
}

#Preview {
    let preview = ContentViewContainer.mock
    
    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}
