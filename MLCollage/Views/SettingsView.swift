//
//  SettingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftData
import SwiftUI

struct SettingsViewWrapper: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsModel]
    @State var task: Task<Void, Error>?

    var body: some View {
        if let model = settings.first {
            SettingsView(settings: model)
                .onChange(of: model.numberOfEachSubject) {
                    maybeSave()
                }
                .onChange(of: model.translate) {
                    maybeSave()
                }
                .onChange(of: model.rotate) {
                    maybeSave()
                }
                .onChange(of: model.scale) {
                    maybeSave()
                }
                .onChange(of: model.mirror) {
                    maybeSave()
                }
                .onChange(of: model.outputSize) {
                    maybeSave()
                }
        } else {
            //creating new model if none exists
            Text("loading settings...")
                .onAppear {
                    modelContext.insert(SettingsModel())
                }
        }
    }

    func maybeSave() {
        task?.cancel()
        task = Task {
            try await Task.sleep(for: .seconds(0.3))
            try? modelContext.save()
        }
    }
}

struct SettingsView: View {
    @Bindable var settings: SettingsModel

    var resolutions = [100, 200, 300]
    @State private var selectedResolution = 200

    var body: some View {
        HStack {
            //translation toggle
            Toggle("Translate", isOn: $settings.translate)
            //rotate toggle
            Toggle("Rotate", isOn: $settings.rotate)
        }
        .padding([.top, .horizontal])
        HStack {
            //scale toggle
            Toggle("Scale", isOn: $settings.scale)
            //flip toggle
            Toggle("Mirror", isOn: $settings.mirror)
        }
        .padding([.bottom, .horizontal])
        Section("Resolution") {
            Picker("Resolution", selection: $settings.outputSize) {
                ForEach(Outputsize.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
        SliderView(
            title: "number of each subject",
            value: $settings.numberOfEachSubject,
            range: 10...1000
        )
        .padding(.vertical)

    }
}

struct SliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step = 10.0

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Number of Subjects:")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%g", value.rounded()))
                    Spacer()
                }
                HStack {
                    Stepper(
                        value: $value,
                        in: range,
                        step: step
                    ) {
                        Slider(value: $value, in: range) {
                            Text("population")
                        } onEditingChanged: { _ in
                            value = value.rounded()
                        }
                    }
                    .padding(10)
                }
            }
        }
    }
}

#Preview {
    let preview = SettingsPreviewContainer()

    NavigationView {
        VStack {
            SettingsViewWrapper()
                .modelContainer(preview.container)
        }
    }
}

@MainActor
struct SettingsPreviewContainer {
    let container: ModelContainer
    init() {
        do {
            container = try ModelContainer(
                for: SettingsModel.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            container.mainContext.autosaveEnabled = false
        } catch {
            fatalError()
        }
    }
}
