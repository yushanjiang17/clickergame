//
//  ContentView.swift
//  test04
//
//  Created by Sabrina Jiang on 9/4/25.
//

//import SwiftUI
//
//struct ContentView: View {
//    @State var isOn = false
//    
//    var body: some View {
//        ZStack {
//            if !isOn{
//                Rectangle().background(Color.black)
//            }
//            
//            Button("Click Me") {
//                isOn.toggle()
//            }.font(.largeTitle)
//           
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI

struct ContentView: View {
    @State private var score = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Text("💩 poop clicker")
                .font(.largeTitle)
            
            Text("poops: \(score)")
                .font(.title2)
    
            Button(action: { // main button
                score += 1
            }) {
                Image("toliet1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text("Click Me")
                            .foregroundColor(.white)
                            .font(.title)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

