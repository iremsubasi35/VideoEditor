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
    @Published var isPickerPresented = false
    @Published var trimmedVideoURL: URL?
    
       private var cancellables = Set<AnyCancellable>()
    
    func requestMediaAccess() {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.isPickerPresented = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertItem = AlertItem(title: Text("Permission Denied"), message: Text("Please grant permission to access your media."), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    
    func trimVideo(startTime: CMTime, endTime: CMTime) {
            guard let selectedVideoURL = selectedVideoURL else { return }
            
            let asset = AVAsset(url: selectedVideoURL)
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let outputURL = documentsDirectory.appendingPathComponent("trimmedVideo.mov")
            
            if FileManager.default.fileExists(atPath: outputURL.path) {
                try? FileManager.default.removeItem(at: outputURL)
            }
            
            exportSession?.outputURL = outputURL
            exportSession?.outputFileType = .mov
            
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            exportSession?.timeRange = timeRange
            
            exportSession?.exportAsynchronously {
                DispatchQueue.main.async {
                    switch exportSession?.status {
                    case .completed:
                        self.trimmedVideoURL = outputURL
                    case .failed, .cancelled:
                        self.alertItem = AlertItem(title: Text("Error"), message: Text("Failed to trim video."), dismissButton: .default(Text("OK")))
                    default:
                        break
                    }
                }
            }
        }
   
//    func requestMediaAccesstwo() {
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    DispatchQueue.main.async {
//                        self.openMediaPicker()
//                    }
//                } else {
//                    self.alertItem = AlertItem(title: Text("Permission Denied"), message: Text("Please grant permission to access your media."), dismissButton: .default(Text("OK")))
//                }
//            }
//        }
//
//    private func openMediaPicker() {
//            let picker = UIImagePickerController()
//            picker.sourceType = .savedPhotosAlbum
//            picker.mediaTypes = ["public.movie"]
//            picker.delegate = self
//
//            UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
//        }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let mediaURL = info[.mediaURL] as? URL else {
//                    print("Failed to get media URL")
//                    return
//                }
//                print("Selected video URL: \(mediaURL)")
//                selectedVideoURL = mediaURL
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
}
