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

struct PoopParticle: Identifiable {//temporary particle for the spray effect
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
    var rotation: Double
    var scale: CGFloat
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
    
    @State private var particles: [PoopParticle] = []
    
    var body: some View {
    GeometryReader { geo in
        ZStack {
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
                        spawnPoopSpray(in: geo.size)//spray from bottom
                        
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
                
                Spacer(minLength: 0)
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
            
        ZStack {
                                ForEach(particles) { p in
                                    Text("💩")
                                        .font(.system(size: 28))
                                        .rotationEffect(.degrees(p.rotation))
                                        .scaleEffect(p.scale)
                                        .opacity(p.opacity)
                                        .position(x: p.x, y: p.y)
                                }
                            }
                            .allowsHitTesting(false) // taps pass through to your button
                        }
            
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                score += autoPoops
            }
        }
    }
}

    // MARK: - Spray
       private func spawnPoopSpray(in size: CGSize) {
           // How many poops to spray per click
           let count = 6
           
           for _ in 0..<count {
               // Start along the bottom with random x
               let startX = CGFloat.random(in: 24...(size.width - 24))
               let startY = size.height + 20
               
               let particle = PoopParticle(
                   x: startX,
                   y: startY,
                   opacity: 1.0,
                   rotation: Double.random(in: -20...20),
                   scale: CGFloat.random(in: 0.8...1.2)
               )
               
               particles.append(particle)
               
               // End position: fly upward a random distance & drift slightly sideways
               let rise = CGFloat.random(in: 220...420)
               let drift = CGFloat.random(in: -40...40)
               let finalRotation = particle.rotation + Double.random(in: -180...180)
               let duration = Double.random(in: 0.8...1.2)
               
               // Animate the particle
               withAnimation(.easeOut(duration: duration)) {
                   if let idx = particles.firstIndex(where: { $0.id == particle.id }) {
                       particles[idx].y = startY - rise
                       particles[idx].x = startX + drift
                       particles[idx].opacity = 0.0
                       particles[idx].rotation = finalRotation
                       particles[idx].scale = CGFloat.random(in: 0.6...1.0)
                   }
               }
               
               // Remove from array after animation completes
               DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                   particles.removeAll { $0.id == particle.id }
               }
           }
       }
   }

#Preview {
    ContentView()
}
