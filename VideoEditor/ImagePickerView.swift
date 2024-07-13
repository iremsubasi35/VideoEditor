//
//  ImagePickerView.swift
//  VideoEditor
//
//  Created by İrem Subaşı on 12.07.2024.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: VideoEditorViewModel

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var viewModel: VideoEditorViewModel

        init(viewModel: VideoEditorViewModel) {
            self.viewModel = viewModel
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let mediaURL = info[.mediaURL] as? URL else { return }
            DispatchQueue.main.async {
                self.viewModel.selectedVideoURL = mediaURL
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
