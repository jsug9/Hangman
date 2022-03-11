//
//  ContentView.swift
//  Apple Pie SUI
//
//  Created by Augusto Galindo Alí on 4/08/21.
//

import SwiftUI

struct ContentView: View {
    let incorrectMovesAllowed = 7
    
    //Buttons Functionality
    let qwerty = "qwertyuiopasdfghjklzxcvbnm"
    @State var rows = [[0..<10], [10..<19], [19..<26]]
    @State var letterState = Array(repeating: false, count: 26)
    @State var isDisabled = false
    
    //Game Functionality
    @State var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
    @State var currentGame: Game
    @State var correctWordLabel = "____"
    
    //Score
    @State var currentPoints = 0
    @State var totalWins = 0 {
        didSet {
            newRound()
            currentPoints += 10
        }
    }
    @State var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    init() {
        currentGame = Game(word: "X", incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 15) {
                Image("Hanged \(currentGame.incorrectMovesRemaining)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                //Correct here
                Text(correctWordLabel).font(.system(size: 30))
                
                ForEach(0..<rows.count) { row in
                    HStack(spacing: 5) {
                        ForEach(rows[row][0]) { letter in
                            Button(action: {
                                //Add functionality here
                                currentGame.playerGuessed(letter: qwerty[letter])
                                
                                //Disable Letter
                                letterState[letter].toggle()
                                
                                updateGameState()
                            }, label: {
                                Text(String(qwerty[letter]))
                                    .font(.system(size: 35))
                            })
                            .frame(width: geo.size.width * 0.08)
                            .disabled(letterState[letter])
                        }
                    }
                }

                HStack {
                    Text("Wins: \(totalWins) | Losses: \(totalLosses)").font(.system(size: 20))
                    Spacer()
                    Text("Points: \(currentPoints)").font(.system(size: 20))
                }
                .padding([.horizontal, .bottom])
            }
        }
        .onAppear(perform: {
            newRound()
        })
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
        }
        
    }
    
    func enableLetterButtons(_ enable: Bool) {
        if enable {
            letterState = Array(repeating: false, count: 26)
        } else {
            letterState = Array(repeating: true, count: 26)
        }
    }
    
    func updateUI() {
        let wordWithSpacing = currentGame.formatedWord.map { String($0) }
        correctWordLabel = wordWithSpacing.joined(separator: " ").capitalizingFirstLetter()
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formatedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
