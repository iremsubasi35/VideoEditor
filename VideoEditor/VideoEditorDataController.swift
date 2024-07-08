//
//  VideoEditorDataController.swift
//  VideoEditor
//
//  Created by İrem Subaşı on 8.07.2024.
//

import Foundation
import Combine

class VideoEditorDataController: ObservableObject {
    @Published var viewModel: VideoEditorViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: VideoEditorViewModel) {
        self.viewModel = viewModel

        viewModel.$selectedVideoURL
            .sink { selectedVideoURL in
                print("Selected video URL: \(selectedVideoURL)")
            }
            .store(in: &cancellables)
    }
}
