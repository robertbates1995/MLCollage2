//
//  Item.swift
//  MLCollage
//
//  Created by Robert Bates on 4/28/25.
//

import Foundation
import SwiftData
import UIKit


final class SubjectModel: Identifiable {
    @_PersistedProperty var label: String
    @Relationship(deleteRule: .cascade, inverse: \SubjectImageModel.subject)
    @_PersistedProperty var images: [SubjectImageModel]
    
    init(label: String, images: [SubjectImageModel] = [SubjectImageModel]()) {
        self.label = label
        self.images = images
    }
    
    
    @Transient
    private var _$backingData: any SwiftData.BackingData<SubjectModel> = SubjectModel.createBackingData()
    
    public var persistentBackingData: any SwiftData.BackingData<SubjectModel> {
        get {
            return _$backingData
        }
        set {
            _$backingData = newValue
        }
    }
    
    static var schemaMetadata: [SwiftData.Schema.PropertyMetadata] {
        return [
            SwiftData.Schema.PropertyMetadata(name: "label", keypath: \SubjectModel.label, defaultValue: nil, metadata: nil),
            SwiftData.Schema.PropertyMetadata(name: "images", keypath: \SubjectModel.images, defaultValue: nil, metadata: SwiftData.Schema.Relationship(deleteRule: .cascade, inverse: \SubjectImageModel.subject))
        ]
    }
    
    init(backingData: any SwiftData.BackingData<SubjectModel>) {
        _label = _SwiftDataNoType()
        _images = _SwiftDataNoType()
        self.persistentBackingData = backingData
    }
    
    @Transient private let _$observationRegistrar = Observation.ObservationRegistrar()
    
    internal nonisolated func access<_M>(
        keyPath: KeyPath<SubjectModel, _M>
    ) {
        _$observationRegistrar.access(self, keyPath: keyPath)
    }
    
    internal nonisolated func withMutation<_M, _MR>(
        keyPath: KeyPath<SubjectModel, _M>,
        _ mutation: () throws -> _MR
    ) rethrows -> _MR {
        try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
    }
    
    struct _SwiftDataNoType {
    }
}

extension SubjectModel: SwiftData.PersistentModel {
}

extension SubjectModel: Observation.Observable {
}

@available(swift, deprecated: 5.9, message: "PersistentModels are not Sendable, consider utilizing a ModelActor or use SubjectModel's persistentModelID instead")
@available(*, unavailable, message: "PersistentModels are not Sendable, consider utilizing a ModelActor or use SubjectModel's persistentModelID instead")
extension SubjectModel: Sendable {
}

extension SubjectModel {
    static let mock: SubjectModel = {
        let imageModel = SubjectImageModel(
            image: UIImage(resource: .robotWithScissors),
            subject: SubjectModel(label: "test1")
        )
        
        let imageModel2 = SubjectImageModel(
            image: UIImage(resource: .folderTab),
            subject: SubjectModel(label: "test2")
        )
        
        let imageModel3 = SubjectImageModel(
            image: UIImage(resource: .photoStack),
            subject: SubjectModel(label: "test2")
        )
        
        let imageModel4 = SubjectImageModel(
            image: UIImage(resource: .notebookPaper),
            subject: SubjectModel(label: "test2")
        )
        
        return SubjectModel(label: "mock subject", images: [imageModel, imageModel2, imageModel3, imageModel4])
    }()
}


@Model
final class SubjectImageModel: Identifiable {
    var subject: SubjectModel?
    var image: Data

    init(image: Data) {
        self.image = image
    }
    
    func toImage() -> UIImage {
        UIImage(data: image)!
    }
}

extension SubjectImageModel {
    convenience init (image: UIImage, subject: SubjectModel) {
        self.init(image: image.pngData()!)
        self.subject = subject
    }
}
