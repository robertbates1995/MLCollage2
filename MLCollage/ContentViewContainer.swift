//
//  ContentViewContainer.swift
//  MLCollage
//
//  Created by Robert Bates on 5/27/25.
//

import SwiftData
import SwiftUICore
import UIKit

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

extension ContentViewContainer {
    static let mock: ContentViewContainer = {
        let container = ContentViewContainer()
        container.container.mainContext.insert(SubjectModel.mock)
        container.container.mainContext.insert(BackgroundModel.mock)
        try? container.container.mainContext.save()
        return container
    }()
}
