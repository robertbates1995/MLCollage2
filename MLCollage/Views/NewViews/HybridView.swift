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
                    VStack {
                        subjectScrollView
                    }
                    .frame(height: 170.0)
                    .padding(.vertical)
                    .background(Color.secondaryAccent)
                    .clipShape(.rect(cornerRadius: 15.0))
                    .shadow(radius: 5.0)
                    Spacer()
                    backgroundScrollView
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
                .background(.black.opacity(0.05))
                .clipShape(.rect(cornerRadius: 15.0))
                .padding(.horizontal)
        }
        if subjects.isEmpty {
            HStack {
                ContentUnavailableView(
                    "No Subjects",
                    systemImage: "photo",
                    description: Text(
                        "At lest one subject is needed"
                    )
                )
            }
        } else {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(subjects) { subject in
                        NavigationLink(destination: {
                            SubjectDetailView(subject: subject)
                        }) {
                            HeroView(subject: subject)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
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
        if backgrounds.isEmpty {
            HStack {
                ContentUnavailableView(
                    "No Backgrounds",
                    systemImage: "photo",
                    description: Text(
                        "At lest one background is needed"
                    )
                )
            }
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(backgrounds) { background in
                        Image(uiImage: background.toMLCImage().uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                            .clipShape(.rect(cornerRadius: 8.0))
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                            .padding(3.0)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal)
        }
    }

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
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: RectangleCornerRadii(
                        topLeading: 10.0,
                        bottomLeading: 30.0,
                        bottomTrailing: 30.0,
                        topTrailing: 10.0
                    )
                )
            )
            .foregroundStyle(.app)
            .padding([.horizontal, .bottom], 15.0)
            Spacer()
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

#Preview {
    let preview = ContentViewContainer.init()

    NavigationView {
        HybridView()
            .modelContainer(preview.container)
    }
}
