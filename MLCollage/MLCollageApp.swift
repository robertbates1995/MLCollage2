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
    @State private var showAboutScreen: Bool = false
    
    var body: some Scene {
        DocumentGroupLaunchScene("MLCollage") {
            NewDocumentButton("New Project")
            Button("About") {
                showAboutScreen.toggle()
            }
            .sheet(isPresented: $showAboutScreen) {
                AboutView()
            }
        } background: {
            LinearGradient(
                gradient: Gradient(colors: [.accent, .white]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        } overlayAccessoryView: { geometry in
            ZStack {
                Image(.robotWithScissors)
                    .resizable()
                    .frame(
                        width: geometry.frame.width * 0.35,
                        height: geometry.frame.width * 0.35
                    )
                    .position(
                        x: geometry.titleViewFrame.maxX * 0.20,
                        y: geometry.titleViewFrame.maxY * 0.13
                    )
                Image(.photoStack)
                    .resizable()
                    .frame(
                        width: geometry.frame.width * 0.35,
                        height: geometry.frame.width * 0.35
                    )
                    .position(
                        x: geometry.titleViewFrame.maxX * 0.90,
                        y: geometry.titleViewFrame.maxY * 0.16
                    )
            }
        }
        DocumentGroup(
            editing: .itemDocument,
            migrationPlan: MLCollageMigrationPlan.self
        ) {
            HybridView()
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
        //Stages of migration between VersionedSchema, if required.
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
