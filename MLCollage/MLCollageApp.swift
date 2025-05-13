//
//  MLCollageApp.swift
//  MLCollage
//
//  Created by Robert Bates on 4/28/25.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

@main
struct MLCollageApp: App {
    @State private var iconSize: CGFloat = 100

    var body: some Scene {
        DocumentGroupLaunchScene("MLCollage") {
            NewDocumentButton("New Project")
        } background: {
            //add background here
        } overlayAccessoryView: { geometry in
            ZStack {
                Image(.photoStack)
                    .resizable()
                    .frame(
                        width: geometry.frame.width / 4,
                        height: geometry.frame.height / 5
                    )
                    .position(
                        x: geometry.titleViewFrame.maxX * 0.23,
                        y: geometry.titleViewFrame.maxY/5
                    )
                Image(.photoStack)
                    .resizable()
                    .frame(
                        width: geometry.frame.width / 4,
                        height: geometry.frame.height / 5
                    )
                    .position(
                        x: geometry.titleViewFrame.maxX * 0.94,
                        y: geometry.titleViewFrame.maxY/5
                    )
                Image(.photoStack)
                    .resizable()
                    .frame(
                        width: geometry.frame.width / 4,
                        height: geometry.frame.height / 5
                    )
                    .position(
                        x: geometry.titleViewFrame.maxX * 0.94,
                        y: geometry.titleViewFrame.maxY * 0.7
                    )
                Image(.photoStack)
                    .resizable()
                    .frame(
                        width: geometry.frame.width / 4,
                        height: geometry.frame.height / 5
                    )
                    .position(
                        x: geometry.titleViewFrame.maxX * 0.23,
                        y: geometry.titleViewFrame.maxY * 0.7
                    )
            }
        }
        DocumentGroup(
            editing: .itemDocument,
            migrationPlan: MLCollageMigrationPlan.self
        ) {
            ContentView()
        }
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}

struct MLCollageMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
        MLCollageVersionedSchema.self
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]
}

struct MLCollageVersionedSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        SubjectModel.self,
        BackgroundModel.self,
        SettingsModel.self,
    ]
}

//#Preview {
//    let preview = ContentViewContainer()
//
//    NavigationView {
//        MLCollageApp()
//    }
//}
