//
//  ContentView.swift
//  Claim_Insurance
//
//  Created by Gokul B on 28/02/24.
//

import SwiftUI
import CoreML
import UIKit
import CoreVideo
import CoreGraphics


enum DamageType: String {
    case severe_scratch = "Severe scratch"
    case severe_dents = "Severe dent"
    case slightly_scratch = "Slight scratch"
}

struct ContentView: View {
    
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage = UIImage()
    
    //let model = claim
    
    var body: some View {
        NavigationView {
            ZStack() {
                RadialGradient(stops: [
                    .init(color: .blue, location: 0.3),
                    .init(color: .red, location: 0.3),
                ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    Text("Diagnose the damage")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    VStack(spacing: 60) {
                        VStack(spacing: 20) {
                            Text("Select a picture from gallery")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Button {
                                isShowingImagePicker = true
                                //open photos app to select photos and feed it back here
                            } label: {
                                Image(systemName: "photo")
                            }
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                            .sheet(isPresented: $isShowingImagePicker) {
                                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                                
                            }
                            .onChange(of: selectedImage) { newImage in
                                handleImageSelection(newImage)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(Rectangle())
                    .cornerRadius(20)
                    
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    
                    HStack {
                        Text("Result: ")
                        Text("The car has xx damage")

                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Damage Diagnosis")
        }
    }
    
    func classifyImage(_ image: UIImage) -> String? {
        
        if let model = loadModel() {
            print("model loaded")
        } else {
            print("model failed to load")

            // Failed to load model, handle error accordingly
        }
        // Load the Core ML model
        guard let model = try? MyImageClassifier1(configuration: MLModelConfiguration()) else {
            print("Failed to load Core ML model")
            return nil
        }
        
        // Preprocess the user-provided image
        guard let inputPixelBuffer = preprocessImage(image) else {
            print("Failed to preprocess image")
            return nil
        }
        
        // Perform inference with the model
        guard let output = try? model.prediction(image: inputPixelBuffer) else {
            print("Failed to perform inference with the model")
            return nil
        }
        let probability = output.targetProbability
        // Process the output predictions to obtain the predicted damage type
        let predictedDamageType = output.target
        return predictedDamageType
    }
    
    // Function to preprocess the image
    func preprocessImage(_ image: UIImage) -> CVPixelBuffer? {
        // Resize the image to the required input size (299x299)
        guard let resizedImage = image.resize(size: CGSize(width: 299, height: 299)) else {
            return nil
        }

        // Convert the resized image to a CVPixelBuffer
        guard let pixelBuffer = resizedImage.getCVPixelBuffer() else {
            return nil
        }

        return pixelBuffer
    }
    
    // Function to process the output predictions
    func processOutput(_ predictedDamageType: String?) {
        guard let damageType = predictedDamageType else {
            print("Failed to classify the image")
            return
        }
        
        print("Predicted Damage Type: \(damageType)")
        // Use the predicted damage type for further processing
    }

    // Function to handle image selection by the user
    func handleImageSelection(_ image: UIImage) {
        if let predictedDamageType = classifyImage(image) {
            processOutput(predictedDamageType)
        }
    }
    
    func loadModel() -> MyImageClassifier1? {
        do {
            let model = try MyImageClassifier1(configuration: MLModelConfiguration())
            print("Model loaded successfully")
            return model
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
}

#Preview {
    ContentView()
}

