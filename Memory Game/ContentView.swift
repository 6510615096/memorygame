import SwiftUI

struct ContentView: View {
    
    enum CardThemes: String, CaseIterable, Identifiable {
        case heart = "heart.fill"
        case sport = "sport.fill"
        case bakery = "bakery.fill"
        
        var id: String { self.rawValue }
        
        var cardEmojis: [String] {
            switch self {
            case .heart:
                return ["💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️","💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️"]
            case .sport:
                return ["⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🎱","⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🎱"]
            case .bakery:
                return ["🥐","🥨","🥞","🧇","🍰","🧁","🍪","🥖","🥐","🥨","🥞","🧇","🍰","🧁","🍪","🥖"]
            }
        }
    }
    /*var emojis = ["💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️","💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️"].shuffled()*/
    @State var selectedCardTheme: CardThemes = .heart
    @State var flippedIndices: [Int] = []
    @State var matchedCards: Set<Int> = []
    @State var emojis: [String] = CardThemes.heart.cardEmojis
    @State private var shuffledEmojis: [String] = []
    
    let cardCount = 16
    
    var body: some View {
        NavigationView() {
            VStack(spacing: 0) {
                Text("Memorize!")
                    .font(.largeTitle)
                    .foregroundColor(.pink)
                    .bold()
                    .padding(.top, 40)
                .padding(10)
                cards
                Spacer()
                cardThemes
            }
            .padding()
            .onAppear {
                shuffledEmojis = selectedCardTheme.cardEmojis.shuffled()
            }
        }
    }
    
    var cards: some View {
           LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
               ForEach(0..<cardCount, id: \.self) { index in
                   CardView(content: selectedCardTheme.cardEmojis[index],
                            isFaceUp: flippedIndices.contains(index) || matchedCards.contains(index)
                            )
                   .onTapGesture {
                       handleTap(index: index)
                   }
                    .aspectRatio(4/5, contentMode: .fit)
               }
           }
           .foregroundColor(.pink)
       }
    
    var cardThemes : some View {
        HStack {
        Spacer()
            VStack {
                Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)
                Text("Heart")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .onTapGesture {
                changeTheme(to: .heart)
            }
            Spacer()
            VStack {
                Image(systemName: "soccerball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)
                Text("Sport")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .onTapGesture {
                changeTheme(to: .sport)
            }
            Spacer()
            VStack {
                Image(systemName: "birthday.cake.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)
                Text("Bakery")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .onTapGesture {
                changeTheme(to: .bakery)
            }
            Spacer()
        }
    }
    
    func changeTheme(to newTheme: CardThemes) {
        selectedCardTheme = newTheme
        shuffledEmojis = newTheme.cardEmojis.shuffled()
        emojis = newTheme.cardEmojis
        matchedCards.removeAll()
        //flippedIndices.removeAll()
    }
    
    func handleTap(index: Int) {
        guard !flippedIndices.contains(index), !matchedCards.contains(index) else { return }

        flippedIndices.append(index)
        
        if flippedIndices.count == 2 {
            let firstIndex = flippedIndices[0]
            let secondIndex = flippedIndices[1]
            
            if selectedCardTheme.cardEmojis[firstIndex] == selectedCardTheme.cardEmojis[secondIndex] {
                matchedCards.insert(firstIndex)
                matchedCards.insert(secondIndex)
                /*flippedIndices.removeAll()*/
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

            base.fill(Color.pink.opacity(0.7))
                .opacity(isFaceUp ? 0 : 1)
        }
        .frame(width: 80, height: 120)
    }
}


#Preview {
    ContentView()
}
