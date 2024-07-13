//
//  VideoTrimView.swift
//  VideoEditor
//
//  Created by İrem Subaşı on 12.07.2024.
//

import SwiftUI
import AVFoundation

struct VideoTrimView: View {
    @ObservedObject var viewModel: VideoEditorViewModel
    @State private var startTime: Double = 0
    @State private var endTime: Double = 10
    @State private var player: AVPlayer?
    @State private var durationSeconds: Double = 0

    init(viewModel: VideoEditorViewModel) {
        self.viewModel = viewModel
        if let url = viewModel.selectedVideoURL {
            _player = State(initialValue: AVPlayer(url: url))
        } else {
            _player = State(initialValue: nil)
        }
    }

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayerUIView(player: player)
                    .frame(height: 300)
                    .onAppear {
                        player.play()
                        if let duration = player.currentItem?.duration {
                            self.durationSeconds = CMTimeGetSeconds(duration)
                            self.endTime = self.durationSeconds
                        }
                    }

                if durationSeconds > 0 {
                    HStack {
                        Text("Start Time: \(startTime, specifier: "%.2f")")
                        Slider(value: $startTime, in: 0...endTime)
                        Text("End Time: \(endTime, specifier: "%.2f")")
                        Slider(value: $endTime, in: startTime...durationSeconds)
                    }
                    .padding()
                } else {
                    Text("Loading video duration...")
                }

                Button(action: {
                    let start = CMTime(seconds: startTime, preferredTimescale: 600)
                    let end = CMTime(seconds: endTime, preferredTimescale: 600)
                    viewModel.trimVideo(startTime: start, endTime: end)
                }) {
                    Text("Trim Video")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let trimmedVideoURL = viewModel.trimmedVideoURL {
                    NavigationLink(destination: VideoPlayerView(videoURL: trimmedVideoURL)) {
                        Text("Play Trimmed Video")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            } else {
                Text("Video URL is not valid")
            }
        }
        .navigationBarTitle("Trim Video", displayMode: .inline)
    }
}
