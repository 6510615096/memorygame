import SwiftUI

struct ContentView: View {
    
    /*enum CardThemes: String, CaseIterable, Identifiable {
        case heart = "heart.fill"
        case sport = "sport.fill"
        case bakery = "bakery.fill"
        
        var id: String { self.rawValue }
        
        var cardEmojis: [String] {
            switch self {
            case .heart:
                return ["💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️","💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️"].shuffled()
            case .sport:
                return ["⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🎱","⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🎱"].shuffled()
            case .bakery:
                return ["🥐","🥨","🥞","🧇","🍰","🧁","🍪","🥖","🥐","🥨","🥞","🧇","🍰","🧁","🍪","🥖"].shuffled()
            }
        }
    }*/
    var emojis = ["💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️","💓","💕","💘","💝","💔","❤️‍🔥","❤️‍🩹","❣️"].shuffled()
    //@State var selectedCardTheme: CardThemes = .heart
    //@State var cards: [Card] = []
    @State var flippedIndices: [Int] = []
    @State var matchedCards: Set<Int> = []
    
    let cardCount = 16
    
    var body: some View {
        NavigationView() {
            VStack {
                ScrollView {
                    cards
                    /*Picker("", selection: $selectedCardTheme) {
                        ForEach(CardThemes.allCases) {
                            themes in Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.pink)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())*/

                }
                cardThemes
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Memorize!")
                    .padding(.top, 50)
                    .font(.largeTitle)
                    .foregroundColor(.pink)
                    .bold()
                }
            }
        }
    }
    
    var cards: some View {
           LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
               ForEach(0..<cardCount, id: \.self) { index in
                   CardView(content: emojis[index])
                       .aspectRatio(2/5, contentMode: .fit)
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
            Spacer()
        }
    }
    
    /*func cardThemes(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
                .imageScale(.large)
                .font(.largeTitle)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }*/
}

/*struct GameThemes: View {
    var selectThemes: String
    var body: some View {
        
    }
}*/

#Preview {
    ContentView()
}

struct CardView: View {
    @State var isFaceUp: Bool = true
    var content: String
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
//            var base = Ellipse()
            Group {
                base
                    .fill(.white)
                    .strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

