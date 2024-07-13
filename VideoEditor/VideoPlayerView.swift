//
//  VideoPlayerView.swift
//  VideoEditor
//
//  Created by İrem Subaşı on 11.07.2024.
//

import AVFoundation
import SwiftUI

struct VideoPlayerView: View {
  //  var player: AVPlayer
    var videoURL: URL

    var body: some View {
        VStack {
        VideoPlayerUIView(player: AVPlayer(url: videoURL))
                        .onAppear {
                            AVPlayer(url: videoURL).play()
                        }
                    .frame(height: 300)
            }
            .navigationBarTitle("Video Player", displayMode: .inline)
    }
}

struct VideoPlayerUIView: UIViewRepresentable {
    var player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: player)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Any updates if needed
    }
}

class PlayerUIView: UIView {
    private var player: AVPlayer
    private var playerLayer: AVPlayerLayer

    init(player: AVPlayer) {
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        super.init(frame: .zero)
        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
