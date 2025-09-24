//
//  TrainingDataFile.swift
//  MLCollage
//
//  Created by Robert Bates on 10/28/24.
//

import SwiftUI
import UniformTypeIdentifiers


struct TrainingDataFile: FileDocument {
    static let readableContentTypes: [UTType] = [.folder, .json, .png]
    let collages: [Collage]
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var fileStructure = ["project.json": FileWrapper(regularFileWithContents: collages.json)]
        
        for i in collages {
            if let data = i.image.pngData() {
                fileStructure[i.json.imagefilename] = FileWrapper(regularFileWithContents: data)
            }
        }
        return FileWrapper(directoryWithFileWrappers: fileStructure)
    }
}

extension TrainingDataFile {
    init(configuration: ReadConfiguration) throws {
        fatalError()
    }
}
