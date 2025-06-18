//
//  OutputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct PinchGesture: UIGestureRecognizerRepresentable {
    @Binding var scale: Double
    @Binding var velocity: Double
    @Binding var state: UIGestureRecognizer.State

    func makeUIGestureRecognizer(context: Context) -> UIPinchGestureRecognizer {
        UIPinchGestureRecognizer()
    }

    func handleUIGestureRecognizerAction(
        _ recognizer: UIPinchGestureRecognizer,
        context: Context
    ) {
        scale = recognizer.scale
        velocity = recognizer.velocity
        state = recognizer.state
    }
}

struct OutputsView: View {
    @Binding var model: OutputModel
    @State var showingExporter = false
    @State var minSize: Double = 100.0
    @State var scale: Double = 1.0
    @State var velocity: Double = 0.0
    @State var state: UIGestureRecognizer.State = .ended
    @State var progress: CGFloat = 0.0

    var body: some View {
        let pinch = PinchGesture(
            scale: $scale.animation(.spring(.smooth(extraBounce: 0.2))),
            velocity: $velocity,
            state: $state.animation(.spring(.smooth(extraBounce: 0.5)))
        )

        GeometryReader { size in
            VStack {
                if model.blueprints.isEmpty {
                    ContentUnavailableView(
                        "Key Data Missing",
                        image: "photo",
                        description: Text(
                            "At least one subject and one background must be entered to generate an output."
                        )
                    )
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(
                                    .adaptive(minimum: minSize * scale)
                                )
                            ],
                            spacing: 20
                        ) {
                            ForEach(model.collages) { collage in
                                VStack {
                                    ThumbnailView(collage: collage)
                                }
                            }
                        }
                    }.gesture(pinch)
                    if model.canExport {
                        Button("export") {
                            showingExporter.toggle()
                        }.fileExporter(
                            isPresented: $showingExporter,
                            document: TrainingDataFile(
                                collages: model.collages
                            ),
                            defaultFilename: "foo"
                        ) { _ in

                        }
                        .padding()
                    } else {
                        if let progress = model.progress {
                            ProgressView(value: progress)
                        }
                    }
                }
            }.task {
                model.updateIfNeeded()
            }
            .padding()
            .navigationTitle("Output")
        }
    }
}

//#Preview {
//    @Previewable @State var model = OutputModel.mock
//    OutputsView(model: $model)
//}
