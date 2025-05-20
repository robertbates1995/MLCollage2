//
//  OutputModel.swift
//  MLCollage
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI

@Observable
@MainActor
class OutputModel {
    var collages: [Collage]
    var canExport: Bool { state == .ready }
    var state = State.needsUpdate
    var blueprints: [CollageFactory] = [] {
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

    enum State {
        case needsUpdate
        case loading
        case ready
    }

    init(
        collages: [Collage] = [], state: State = State.needsUpdate,
        blueprints: [CollageFactory] = []
    ) {
        self.collages = collages
        self.state = state
        self.blueprints = blueprints
    }

    func updateIfNeeded() {
        guard state == .needsUpdate else {
            return
        }
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
}
