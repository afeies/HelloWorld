//
//  ContentView.swift
//  HelloWorld
//
//  Created by Alex Feies on 5/31/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var input: String = ""
    @State private var output: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                
#if !targetEnvironment(simulator)
                CameraView()
                    .frame(height: geometry.size.height * 0.75 - 30)
                    .cornerRadius(16)
                    .padding([.horizontal, .top], 20)
#else
                Text("Camera not available in simulator")
#endif
                
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: geometry.size.height / 3)
                    .overlay(
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Enter Your Question")
                                .bold()
                            
                            TextField("What do you see?", text: $input)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("Response").bold()
                            
                            TextField("Output", text: $output)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                            .padding()
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct CameraView: UIViewRepresentable {
    class CameraPreview: UIView {
        private var previewLayer: AVCaptureVideoPreviewLayer?
        private let session = AVCaptureSession()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initializeCamera()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initializeCamera()
        }
        
        private func initializeCamera() {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input) else { return }
            
            session.addInput(input)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = bounds
            layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer
            
            session.startRunning()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        return CameraPreview()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    ContentView()
}
