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
    @State private var navigateToTrim = false
    
    var body: some View {
        NavigationView {
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
            NavigationLink(
                                destination: VideoTrimView(viewModel: viewModel),
                                isActive: Binding<Bool>(
                                    get: { viewModel.selectedVideoURL != nil },
                                    set: { newValue in
                                        if !newValue {
                                            viewModel.selectedVideoURL = nil
                                        }
                                    }
                                )
                            ) {
                                EmptyView()
                            }
                }
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
                .fullScreenCover(isPresented: $viewModel.isPickerPresented, content: {
                                ImagePickerView(viewModel: viewModel)
                            })
                            .onChange(of: viewModel.selectedVideoURL) { newValue in
                                if newValue != nil {
                                    navigateToTrim = true
                                }
                            }
                        }
    }
}


