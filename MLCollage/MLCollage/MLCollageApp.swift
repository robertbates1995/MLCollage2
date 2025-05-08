//
//  MLCollageApp.swift
//  MLCollage
//
//  Created by Robert Bates on 4/28/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct MLCollageApp: App {
    var body: some Scene {
        DocumentGroup(editing: .itemDocument, migrationPlan: MLCollageMigrationPlan.self) {
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
        MLCollageVersionedSchema.self,
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
        SettingsModel.self
    ]
}
