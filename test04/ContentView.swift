import SwiftUI

struct Upgrade: Identifiable {
    let id = UUID()
    let name: String
    var cost: Int
    let type: UpgradeType
}

enum UpgradeType {
    case clickPower(Int)
    case autoPoop(Int)
}


struct ContentView: View {
    @State private var score = 0
    @State private var isPressed = false
    @State private var clickPower = 1
    @State private var autoPoops = 0
    
    @State private var upgrades: [Upgrade] = [
        Upgrade(name: "🪠 (+5/click)", cost: 50, type: .clickPower(5)),
        Upgrade(name: "🧻 (+1/sec)", cost: 100, type: .autoPoop(1))
    ]
    
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
                
                Button(action: {
                    score += clickPower
       
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
                ForEach(upgrades.indices, id: \.self) { i in
                    let upgrade = upgrades[i]
                    
                    Button("buy \(upgrade.name), cost \(upgrade.cost)") {
                        if score >= upgrade.cost {
                            score -= upgrade.cost
                            switch upgrade.type {
                            case .clickPower(let amount):
                                clickPower += amount
                            case .autoPoop(let amount):
                                autoPoops += amount
                            }
                            // Increase cost for next purchase (×1.5)
                            upgrades[i].cost = Int(Double(upgrades[i].cost) * 1.5)
                        }
                    }
                    .padding()
                    .background(score >= upgrade.cost ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                score += autoPoops
            }
        }
    }
}

#Preview {
    ContentView()
}
