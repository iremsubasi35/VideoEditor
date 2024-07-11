//
//  VideoEditorViewModel.swift
//  VideoEditor
//
//  Created by İrem Subaşı on 8.07.2024.
//

import SwiftUI
import AVFoundation
import Combine

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
}

class VideoEditorViewModel: NSObject, ObservableObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Published var selectedVideoURL: URL?
    @Published var alertItem: AlertItem?

       private var cancellables = Set<AnyCancellable>()
    
    func requestMediaAccess() {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.openMediaPicker()
                    }
                } else {
                    self.alertItem = AlertItem(title: Text("Permission Denied"), message: Text("Please grant permission to access your media."), dismissButton: .default(Text("OK")))
                }
            }
        }
    
    private func openMediaPicker() {
            let picker = UIImagePickerController()
            picker.sourceType = .savedPhotosAlbum
            picker.mediaTypes = ["public.movie"]
            picker.delegate = self

            UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let mediaURL = info[.mediaURL] as? URL else {
                    print("Failed to get media URL")
                    return
                }
                print("Selected video URL: \(mediaURL)")
                selectedVideoURL = mediaURL
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
