//
//  PhotoPicker.swift
//  Instafilter
//
//  Created by Alexander Bonney on 6/8/21.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //
    }
    
    /// ------------ Coordinator takes care of comunication between photo library and the app. Without this this whole thing won't work.
    
    func makeCoordinator() -> Coordinator {
         Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        //this method is called whenever user choose photo from the library
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //checking if image is existing, and it can load it
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] uiImage, error in
                    DispatchQueue.main.async {
                        guard let self = self, let uiImage = uiImage as? UIImage else { return }
                        self.parent.image = uiImage
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    
}
