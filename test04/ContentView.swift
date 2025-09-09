import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var isPressed = false
    @State private var clickPower = 1
        @State private var autoPoops = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Text("poop clicker")
                .font(.largeTitle)
      
            Text("poops: \(score)")
                .font(.title2)
            Text("poops per click: \(clickPower)")
            Text("poops per sec: \(autoPoops)")
            
            ZStack {
                Image("toliet2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
           
                Button(action: {//clickable poop emoji
                    score += clickPower
                    
                    // Animate poop emoji
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isPressed = false
                        }
                    }
                }) {
                    Text("💩")
                        .font(.system(size: 50))
                        .scaleEffect(isPressed ? 1.3 : 1.0)
                }
                .buttonStyle(.plain)
                .offset(y: -20) // sits inside bowl
            }
            VStack {
                           Button("buy 🪠+5/click, cost 50") {
                               if score >= 50 {
                                   score -= 50
                                   clickPower += 5
                               }
                           }
                           .padding()
                           .background(score >= 50 ? Color.green : Color.gray)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                           
                           Button("buy 🧻 +1/sec, cost 100") {
                               if score >= 100 {
                                   score -= 100
                                   autoPoops += 1
                               }
                           }
                           .padding()
                           .background(score >= 100 ? Color.blue : Color.gray)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                       }
                   }
                   .padding()
                   .onAppear {
                       // Timer for auto poops
                       Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                           score += autoPoops
                       }
                   }
               }
           }

           #Preview {
               ContentView()
           }
