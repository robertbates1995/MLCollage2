//
//  ContentView.swift
//  MLCollage
//
//  Created by Robert Bates on 4/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationSplitView {
            List {
//               TODO: ForEach() { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        HStack {
//                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                            Spacer()
//                            ForEach(item.images) {
//                                Image(uiImage: $0.toImage())
//                            }
//                        }
//                    }
//                }
//                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            //let newItem = SubjectModel(timestamp: Date())
//            modelContext.insert(newItem)
//            modelContext.insert(SubjectImageModel(image: UIImage(systemName: "plus")!, subject: newItem))
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                //modelContext.delete(subjects[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SubjectModel.self, inMemory: true)
}
