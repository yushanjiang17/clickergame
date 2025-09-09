import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("poop clicker")
                .font(.largeTitle)
      
            Text("poops: \(score)")
                .font(.title2)
            
            ZStack {
                Image("toliet2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
           
                Button(action: {//clickable poop emoji
                    score += 1
                    
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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
