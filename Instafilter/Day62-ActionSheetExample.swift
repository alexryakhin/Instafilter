//
//  ContentView.swift
//  Instafilter
//
//  Created by Alexander Bonney on 6/5/21.
//

import SwiftUI

//struct ContentView: View {
//    @State private var blurAmount: CGFloat = 0
//
//    var body: some View {
//        let blur = Binding<CGFloat>(
//                    get: {
//                        self.blurAmount
//                    },
//                    set: {
//                        self.blurAmount = $0
//                        print("New value is \(self.blurAmount)")
//                    }
//                )
//
//
//        VStack {
//            Text("Hello, world!")
//                .blur(radius: blurAmount)
//
//            Slider(value: blur, in: 0...25)
//        }
//
//
//    }
//}

struct ContentView: View {
    @State private var showingActionSheet = false
    @State private var backgroung = Color.white
    
    var body: some View {
        ZStack {
            backgroung.ignoresSafeArea()
            
            Text("Tap me")
                .frame(width: 400, height: 400, alignment: .center)
                .onTapGesture {
                    showingActionSheet = true
                }
                .actionSheet(isPresented: $showingActionSheet, content: {
                    ActionSheet(title: Text("What backgroung color would you like?"), message: Text("Pick a new one"), buttons: [
                        Alert.Button
                            .default(Text("Green")) { backgroung = .green},
                        Alert.Button
                            .default(Text("Red")) { backgroung = .red},
                        Alert.Button
                            .default(Text("Blue")) { backgroung = .blue},
                        Alert.Button
                            .cancel()
                        
                    ])
            })
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
