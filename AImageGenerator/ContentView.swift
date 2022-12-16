//
//  ContentView.swift
//  AImageGenerator
//
//  Created by Thor on 14/12/2022.
//

import SwiftUI
import OpenAIKit

struct ContentView: View {
    
    @ObservedObject var imageViewModel = ImageViewModel()
    @State var text = ""
    @State var image: UIImage?
    @State private var showingSheet = false
    @State var isLoading = false
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                if let image = image{
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width:300, height: 400)
                }else{
                    Text("Type prompt to generate Image!")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
                TextField("Type prompt here...", text: $text, prompt: Text("Type prompt here...").foregroundColor(.gray))
                    .foregroundColor(.black)
                    .padding()
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.yellow, style: StrokeStyle(lineWidth: 1.5, dash: [22]))
                    )
                
                Spacer().frame(height: 20)
                
                HStack{
                    
                    if isLoading {
                        MyProgress(isLoading: isLoading)
                    }else{
                        Button("Generate!"){
                            if !text.trimmingCharacters(in: .whitespaces).isEmpty{
                                isLoading = true
                                Task{
                                    let result = await imageViewModel.generateImage(prompt: text)
                                    
                                    if result == nil{
                                        print("Failed to load image")
                                    }
                                    
                                    self.image = result
                                    isLoading = false
                                }
                            }
                        }
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        .padding()
                        .background(Color.yellow.cornerRadius(30))
                        .foregroundColor(.white)
                    }
           
                }
        
            }
            .navigationTitle("Prompt to Image")
            .onAppear{
                imageViewModel.setup()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyProgress: View {
    @State var isLoading = false
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.green, lineWidth: 5)
            .frame(width: 30, height: 30)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear
                .repeatForever(autoreverses: false), value: isLoading)
            .onAppear {
                isLoading = true
            }
    }
}
