//
//  OutputModel.swift
//  MLCollage
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI
import SwiftData

@Observable
@MainActor

class OutputModel {
    var collages: [Collage] = []
    var canExport: Bool { state == .ready }
    var state = State.needsUpdate
    var blueprints: [CollageGenerator] = [] {
        didSet {
            task?.cancel()
            state = .needsUpdate
            collages.removeAll()
        }
    }
    var task: Task<Void, Never>?
    var progress: CGFloat? {
        guard blueprints.count > 0 else {
            return nil
        }
        return CGFloat(collages.count) / CGFloat(blueprints.count)
    }
    var outputSize: CGFloat = 100
    
    var observeDBTask: Task<Void, Never>?
    
    var modelContext: ModelContext? {
        didSet {
            observeDBTask?.cancel()
            observeRecordChanges()
            updateBlueprints()
        }
    }
    
    enum State {
        case needsUpdate
        case loading
        case ready
    }

    func updateIfNeeded() {
        guard state == .needsUpdate else {
            return
        }
        updateBlueprints()
        task = Task {
            state = .loading
            await withTaskGroup(of: Void.self) { group in
                var remaining = blueprints[...]
                
                for _ in 0..<6 {
                    guard let blueprint = remaining.popFirst() else { break }
                    group.addTask(priority: .background) { [outputSize] in
                        guard !Task.isCancelled else { return }
                        let collage = blueprint.create(size: outputSize)
                        await MainActor.run {
                            guard !Task.isCancelled else { return }
                            self.collages.append(collage)
                        }
                    }
                }
                
                while let blueprint = remaining.popFirst(),
                    await group.next() != nil
                {
                    group.addTask(priority: .background) { [outputSize] in
                        guard !Task.isCancelled else { return }
                        let collage = blueprint.create(size: outputSize)
                        await MainActor.run {
                            guard !Task.isCancelled else { return }
                            self.collages.append(collage)
                        }
                    }
                }
            }
            state = .ready
        }
    }
    
    func observeRecordChanges() {
        observeDBTask = Task {
            let stream = NotificationCenter.default.notifications(
                named: ModelContext.didSave
            )
            for await _ in stream {
                updateBlueprints()
            }
        }
    }
    
    func updateBlueprints() {
        guard let modelContext else {
            blueprints = []
            return
        }
        let settings = (try? modelContext.fetch(FetchDescriptor<SettingsModel>()))?.first ?? SettingsModel()
        let backgrounds = (try? modelContext.fetch(FetchDescriptor<BackgroundModel>())) ?? []
        let subjects = (try? modelContext.fetch(FetchDescriptor<SubjectModel>())) ?? []
        blueprints = BlueprintFactory().createBlueprints(
            subjects,
            backgrounds,
            settings,
        )
    }
}
