//
//  ContentView.swift
//  VideoEditor
//
//  Created by İrem Subaşı on 8.07.2024.
//

import SwiftUI
import AVFoundation

struct VideoEditorView: View {
    @ObservedObject var viewModel: VideoEditorViewModel
    var body: some View {
        VStack {
                    Text("Video Cutter")
                        .font(.title)
                        .padding()

                    Button(action: {
                        viewModel.requestMediaAccess()
                    }) {
                        Text("Select Video")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    if let selectedVideoURL = viewModel.selectedVideoURL {
                        VideoPlayer(player: AVPlayer(url: selectedVideoURL))
                            .frame(height: 300)
                            .padding()
                    }
                }
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
    }
}


