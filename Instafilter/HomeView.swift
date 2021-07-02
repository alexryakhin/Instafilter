//
//  HomeView.swift
//  Instafilter
//
//  Created by Alexander Bonney on 6/6/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins



struct HomeView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var showImagePicker = false
    @State private var showFilterSheet = false
    @State private var inputImage: UIImage?
    @State private var prosessedImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var filterName = "Select a filter"
    
    @State private var showAlert = false
    let context = CIContext()
    
    @State private var showIntensitySlider = true
    @State private var showRadiusSlider = false
    @State private var showScaleSlider = false
    
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                filterIntensity
            },
            set: {
                filterIntensity = $0
                applyProcessing()
            }
        )
        let radius = Binding<Double>(
            get: {
                filterRadius
            },
            set: {
                filterRadius = $0
                applyProcessing()
            }
        )
        let scale = Binding<Double>(
            get: {
                filterScale
            },
            set: {
                filterScale = $0
                applyProcessing()
            }
        )
        
        
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    
                    //display the image
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select an image")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    //select an image
                    showImagePicker = true
                }
                //Sliders
                VStack {
                    if showIntensitySlider {
                        HStack {
                            Text("Intensity")
                            Slider(value: intensity)
                        }
                    }
                    if showRadiusSlider {
                        HStack {
                            Text("Radius")
                            Slider(value: radius)
                        }
                    }
                    if showScaleSlider {
                        HStack {
                            Text("Scale")
                            Slider(value: scale)
                        }
                    }
                    
                }.padding(.vertical)
                
                HStack {
                    Button(action: {
                        //change filter
                        showFilterSheet = true
                    }, label: {
                        Text(filterName).padding(10).background(Color.blue).cornerRadius(10).foregroundColor(.white)
                    })
                    Spacer()
                    Button(action: {
                        guard let prosessedImage = prosessedImage else {
                            showAlert = true
                            alertTitle = "Ooops..."
                            alertMessage = "There's nothing to save"
                            return }
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                            showAlert = true
                            alertTitle = "Success!"
                            alertMessage = "Picture has been saved to your library!"
                        }
                        
                        imageSaver.errorHandler = { error in
                            print("Fail... \(error.localizedDescription )")
                            showAlert = true
                            alertTitle = "Saving is failed"
                            alertMessage = "Something went wrong"
                        }
                        imageSaver.writeToPhotoAlbum(image: prosessedImage )
                        //save
                    }, label: {
                        Text("Save").padding(10).background(saveButtonColor).cornerRadius(10).foregroundColor(.white)
                    })
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                //                ImagePicker(image: $inputImage)
                PhotoPicker(image: $inputImage)
            }
            .actionSheet(isPresented: $showFilterSheet, content: {
                ActionSheet(title: Text("Select a filter"),buttons: [
                    //some buttons
                    .default(Text("Crystallize")) {
                        setFilter(CIFilter.crystallize())
                        filterName = "Crystallize"
                    },
                    .default(Text("Edges")) {
                        setFilter(CIFilter.edges())
                        filterName = "Edges"
                    },
                    .default(Text("Gaussian Blur")) {
                        setFilter(CIFilter.gaussianBlur())
                        filterName = "Gaussian Blur"
                    },
                    .default(Text("Pixellate")) {
                        setFilter(CIFilter.pixellate())
                        filterName = "Pixellate"
                    },
                    .default(Text("Sepia Tone")) {
                        setFilter(CIFilter.sepiaTone())
                        filterName = "Sepia Tone"
                    },
                    .default(Text("Unsharp Mask")) {
                        setFilter(CIFilter.unsharpMask())
                        filterName = "Unsharp Mask"
                    },
                    .default(Text("Vignette")) {
                        setFilter(CIFilter.vignette())
                        filterName = "Vignette"
                    },
                    .cancel()
                ])
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .default(Text("OK")))
            })
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            showIntensitySlider = true
        } else {
            showIntensitySlider = false
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
            showRadiusSlider = true
        } else {
            showRadiusSlider = false
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 30, forKey: kCIInputScaleKey)
            showScaleSlider = true
        } else {
            showScaleSlider = false
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            prosessedImage = uiImage
        }
        
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    var saveButtonColor: Color {
        if prosessedImage != nil {
            return .green
        }
        return Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
