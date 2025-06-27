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
    
    @State private var selectedDetent: PresentationDetent = .height(100)
    @State var isSheetPresented: Bool = true
    @State var title: String = "Test Title"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    subjectScrollView
                    backgroundScrollView
                }
                .padding(.vertical)
                outputPreview
            }
        }
        .navigationTitle(title)
        .toolbarBackground (
            .accent, for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: .constant(true)) {
            VStack {
                Image(systemName: "swift")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .foregroundStyle(.app)
                if (selectedDetent != .height(100)) {
                    Text("We can’t wait to see what you will Create with Swift!")
                }
            }
            .presentationDetents([.height(100), .medium, .large], selection: $selectedDetent)
            .interactiveDismissDisabled()
            .presentationBackgroundInteraction(.enabled(upThrough: .height(100)))
        }

    }
    
    @ViewBuilder var titleView: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .padding()
            Spacer()
            Button(action: {}) {
                Text("Settings")
                    .font(.headline)
                    .foregroundStyle(.app)
                    .padding(6.0)
                    .background(.black.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 15.0))
            }.padding(.horizontal)
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

    @ViewBuilder var outputPreview: some View {
            VStack {
                HStack {
                    Text("Output")
                        .font(.title)
                        .padding([.leading, .top])
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 50.0)
                    .foregroundStyle(.black.opacity(0.15))
                    .shadow(radius: 5.0)
                    .padding(.horizontal, 5.0)
                    .padding(.bottom)
            }
            .background(.accent)
            .clipShape(.rect(cornerRadius: 50.0))
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
