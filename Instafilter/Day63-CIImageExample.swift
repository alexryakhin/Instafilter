//
//  Day63-CIImageExample.swift
//  Instafilter
//
//  Created by Alexander Bonney on 6/6/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CIImageExample: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }.onAppear(perform: loadImage)
    }
    
    func loadImage() {
//        image = Image("example")
        
        ///USING CORE IMAGE FRAMEWORK
        
        ///just using SwiftUI Image to show in on screen.
        ///but for CIImage we should: 1) Create UIImage, 2) transform it to a CIImage.
        guard let imputImage = UIImage(named: "example") else { return }
        let beginImage = CIImage(image: imputImage)
        
        ///Then we could use filters which are built in CIImage.
        ///For manipulating CIImage we will:
        ///1) Create a context (instanse of CIContext)
        ///2) Create a filter.
        ///3) Take this filter and set up an imput image.
        ///4) Set up filter's parameter (intensity for sepiaTone) - how strong the effect should be applied to an image.
        ///5) Create output CIImage from our filter.
        let context = CIContext()
        let currentFilter = CIFilter.crystallize()
        currentFilter.inputImage = beginImage
        currentFilter.radius = 200
        guard let outputImage = currentFilter.outputImage else { return }
        
        ///To get Image from CIImage we should:
        ///1) Create CGImage from CIImage.
        ///2) Transform it to an UIImage.
        ///3) Transform UIImage to an Image.
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
        
        
    }
}

struct CIImageExample_Previews: PreviewProvider {
    static var previews: some View {
        CIImageExample()
    }
}
