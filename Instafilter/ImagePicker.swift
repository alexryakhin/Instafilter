//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Alexander Bonney on 6/6/21.
//

import SwiftUI


///I realize at this point you’re probably sick of UIKit and coordinators, but before we move on I want to sum up the complete process:

/// --- 1) We created a SwiftUI view that conforms to UIViewControllerRepresentable.
/// --- 2) We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a UIImagePickerController.
/// --- 3) We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
/// --- 4) We gave that coordinator a didFinishPickingMediaWithInfo method, which will be triggered by UIKit when an image was selected.
/// --- 5) Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.

struct ImagePicker: UIViewControllerRepresentable {
    
    ///What we need here is SwiftUI’s @Binding property wrapper, which allows us to create a binding from ImagePicker up to whatever created it. This means we can set the binding value in our image picker and have it actually update a value being stored somewhere else – in ContentView, for example.
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        ///UIImagePickerControllerDelegate protocol, which is what adds functionality for detecting when the user selects an image.
        ///UINavigationControllerDelegate protocol, which lets us detect when the user moves between screens in the image picker.
        
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        ///This method receives a dictionary where the keys are of the type UIImagePickerController.InfoKey, and the values are of the type Any. It’s our job to dig through that to find the image that was selected, assign it to our parent, then dismiss the image picker.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
        
        
        
    }
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //
    }
    
}
