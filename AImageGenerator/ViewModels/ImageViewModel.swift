//
//  ImageViewModel.swift
//  AImageGenerator
//
//  Created by Thor on 16/12/2022.
//

import Foundation
import OpenAIKit
import SwiftUI

final class ImageViewModel: ObservableObject{
    private var openAI : OpenAI?
    
    
    // Setup OpenAI Configuration
    func setup(){
        openAI = OpenAI(
            Configuration(
                organization: "Personal",
                apiKey: "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")
        )
    }
    
    
    // Generate Image based on prompt
    func generateImage(prompt: String) async -> UIImage?{
        guard let openAI = openAI else{
            return nil
        }
        
        do {
            let params = ImageParameters(
                prompt: prompt,
                resolution: .medium,
                responseFormat: .base64Json
            )
            
            let result = try await openAI.createImage(
                parameters: params
            )
            
            result.data.forEach { ImageData in
                let i =  ImageData.image
                print("i: \(i)")
            }
            
            
            let data = result.data[0].image
            let image = try openAI.decodeBase64Image(data)
            return image
        } catch  {
            print(String(describing: error))
            return nil
        }
    }
}
