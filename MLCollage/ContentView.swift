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
    
    @State private var isDarkMode = false
    @Environment(\.colorScheme) private var colorScheme

    //splash screen variables
    @State var size = 0.7
    @State var opacity = 0.5

    var body: some View {
        TabView {
            Tab("Subjects", systemImage: "square.and.arrow.down.on.square") {
                SubjectsView()
            }
            Tab("Backgrounds", systemImage: "photo") {
                BackgroundsView()
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsViewWrapper()
            }
            Tab("Output", systemImage: "text.below.photo") {
                OutputsView(model: $outputModel)
            }
            Tab("About", systemImage: "questionmark.circle") {
                //AboutView()
            }
        }
        .task {
            let stream = NotificationCenter.default.notifications(
                named: ModelContext.didSave
            )

            for await foo in stream {
                if let source = foo.object as? ModelContext, source === modelContext {
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
                outputModel.blueprints = BlueprintFactory().createBlueprints(subjects, backgrounds, settings)
                print("Completed")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    let preview = ContentViewContainer()
    
    NavigationView {
        VStack {
            ContentView()
                .modelContainer(preview.container)
        }
    }
}

@MainActor
struct ContentViewContainer {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: SettingsModel.self,
                SubjectModel.self,
                BackgroundModel.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            container.mainContext.insert(SettingsModel())
        } catch {
            fatalError()
        }
    }
}
