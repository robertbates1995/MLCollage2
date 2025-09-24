//
//  ContentViewContainer.swift
//  MLCollage
//
//  Created by Robert Bates on 5/27/25.
//

import SwiftData
import SwiftUI
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
        container.container.mainContext.insert(SubjectModel.mock1)
        container.container.mainContext.insert(SubjectModel.mock2)
        container.container.mainContext.insert(SubjectModel.mock3)
        container.container.mainContext.insert(BackgroundModel.mock)
        container.container.mainContext.insert(BackgroundModel.mock1)
        container.container.mainContext.insert(BackgroundModel.mock2)
        container.container.mainContext.insert(BackgroundModel.mock3)
        container.container.mainContext.insert(BackgroundModel.mock4)

        try? container.container.mainContext.save()
        return container
    }()
}
