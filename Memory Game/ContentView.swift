// 6510615096 ณัฐภูพิชา อรุณกรพสุรักษ์
// 6510615211 พรนัชชา ประทีปสังคม

import SwiftUI

struct ContentView: View {
    
    @State private var theme: Theme = .heart
    @State private var emojis: [String] = Theme.heart.emojis.shuffled()
    @State private var flippedIndices: [Int] = []
    @State private var matchedCards: Set<Int> = []
    
    let cardCount = 16
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Memorize!")
                    .font(.largeTitle)
                    .foregroundColor(theme.color)
                    .bold()
                    .padding(.top, 40)
                    .padding(10)
                
                cards
                
                Spacer()
                
                cardThemes
            }
            .padding()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(0..<cardCount, id: \ .self) { index in
                CardView(content: emojis[index],
                         isFaceUp: flippedIndices.contains(index) || matchedCards.contains(index),
                         color: theme.color)
                .onTapGesture {
                    handleTap(index: index)
                }
                .aspectRatio(4/5, contentMode: .fit)
            }
        }
        .foregroundColor(theme.color)
    }
    
    var cardThemes: some View {
        HStack {
            Spacer()
            ThemeButton(icon: "heart.fill", label: "Heart", color: .pink) {
                changeTheme(to: .heart)
            }
            Spacer()
            ThemeButton(icon: "soccerball", label: "Sport", color: .blue) {
                changeTheme(to: .sport)
            }
            Spacer()
            ThemeButton(icon: "birthday.cake.fill", label: "Bakery", color: .purple) {
                changeTheme(to: .bakery)
            }
            Spacer()
        }
    }
    
    func changeTheme(to newTheme: Theme) {
        if theme == newTheme {
            emojis = theme.emojis.shuffled()
            flippedIndices.removeAll()
            matchedCards.removeAll()
        } else {
            let oldEmojis = emojis
            theme = newTheme
            let newEmojis = theme.emojis.shuffled()

            var emojiMap: [String: String] = [:]
            var usedEmojis: Set<String> = []
                    
            for oldEmoji in Set(oldEmojis) {
                if let newEmoji = newEmojis.first(where: { !usedEmojis.contains($0) }) {
                    emojiMap[oldEmoji] = newEmoji
                    usedEmojis.insert(newEmoji)
                }
            }
            emojis = oldEmojis.map { emojiMap[$0] ?? $0 }
        }
    }
    
    func handleTap(index: Int) {
        guard !flippedIndices.contains(index), !matchedCards.contains(index) else { return }
        
        guard flippedIndices.count < 2 else { return }
        
        flippedIndices.append(index)
        
        if flippedIndices.count == 2 {
            let firstIndex = flippedIndices[0]
            let secondIndex = flippedIndices[1]
            
            if emojis[firstIndex] == emojis[secondIndex] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    matchedCards.insert(firstIndex)
                    matchedCards.insert(secondIndex)
                    flippedIndices.removeAll()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    flippedIndices.removeAll()
                }
            }
        }
    }
}

struct CardView: View {
    var content: String
    var isFaceUp: Bool
    var color: Color
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            
            Group {
                base.fill(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 2))
                Text(content)
                    .font(.largeTitle)
                    .opacity(isFaceUp ? 1 : 0)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill(color.opacity(0.7))
                .opacity(isFaceUp ? 0 : 1)
        }
        .frame(width: 80, height: 120)
    }
}

struct ThemeButton: View {
    var icon: String
    var label: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(color)
                .onTapGesture(perform: action)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
    }
}

enum Theme {
    case heart, sport, bakery
    
    var emojis: [String] {
        switch self {
        case .heart: return ["💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️","💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️"]
        case .sport: return ["⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🎱","⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🎱"]
        case .bakery: return ["🥐","🥨","🥞","🧇","🍰","🧁","🍪","🥖","🥐","🥨","🥞","🧇","🍰","🧁","🍪","🥖"]
        }
    }
    
    var color: Color {
        switch self {
        case .heart: return .pink
        case .sport: return .blue
        case .bakery: return .purple
        }
    }
}

#Preview {
    ContentView()
}

