//
//  NavigationView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subjects: [SubjectModel]
    @Query private var backgrounds: [BackgroundModel]
    @Query private var settings: [SettingsModel]
    
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var factoryTask: Task<Void, Never>?
    @State var outputModel: OutputModel = OutputModel()
    @State var addState: (() -> Void)?
    @State private var isDarkMode = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    //splash screen variables
    @State var size = 0.7
    @State var opacity = 0.5
    @State var subjectToEdit: SubjectModel? = nil
    @State var selectedTab: Int = 0
    @State var editing: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab( "Subjects",
                 systemImage: "square.and.arrow.down.on.square",
                 value: 0
            ) {
                SubjectsView(subjectToEdit: $subjectToEdit)
            }
            Tab("Backgrounds", systemImage: "photo", value: 1) {
                BackgroundsView(editing: editing)
            }
            Tab("Settings", systemImage: "gearshape", value: 2) {
                SettingsViewWrapper()
            }
            Tab("Output", systemImage: "text.below.photo", value: 3) {
                OutputsView(model: $outputModel)
            }.disabled(subjects.isEmpty || backgrounds.isEmpty)
        }
        .foregroundStyle(.accent)
        .transition(.move(edge: .leading))
        .background(.app)
        .toolbar {
            if selectedTab == 1 {
                Button(
                    action: { editing.toggle() },
                    label: {
                        ZStack {
                            RoundedRectangle(
                                cornerSize: CGSizeMake(15.0, 15.0),
                                style: .circular
                            )
                            Text(editing ? "Done" : "Edit")
                                .accentColor(.white)
                        }
                        .frame(width: 80.0, height: 30.0)
                    }
                )
                .font(.headline)
            }
        }
        .task {
            let stream = NotificationCenter.default.notifications(
                named: ModelContext.didSave
            )
            
            for await foo in stream {
                if let source = foo.object as? ModelContext,
                    source === modelContext
                {
                    fetch()
                    print(foo)
                }
            }
            print("canceled task")
        }
    }
    
    func fetch() {
        factoryTask?.cancel()
        factoryTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.5))
                guard let settings = settings.first else { return }
                outputModel.blueprints = BlueprintFactory().createBlueprints(
                    subjects,
                    backgrounds,
                    settings
                )
                print("Completed")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    @Previewable @State var subject: SubjectModel? = nil
    let preview = ContentViewContainer.mock

    NavigationView {
        VStack {
            ContentView()
                .modelContainer(preview.container)
        }
    }
}
