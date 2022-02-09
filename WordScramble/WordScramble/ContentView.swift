//
//  ContentView.swift
//  WordScramble
//
//  Created by Wassim Mansouri on 14/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var newGame = false
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var wordList = [String]()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word:", text: $newWord)
                        .autocapitalization(.none)
                }
                Section {
                    ForEach(usedWords, id: \.self) {word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok", role: .cancel) {
                    if (newGame) {
                        restartGame()
                    } else {
                        return
                    }
                }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possibler", message: "You can't spell that word from '\(rootWord)'")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word is not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
        
        guard startNewGame() else {
            wordError(title: "Nice job", message: "Start again?")
            newGame = true
            return
        }
    }
    
    func startGame() {
        if let startWordsList = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsList) {
                wordList = startWords.components(separatedBy: "\n")
                rootWord = pickNewWord(wordList)
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func restartGame() {
        rootWord = pickNewWord(wordList)
        usedWords = [String]()
    }
    
    func pickNewWord(_ wordList: [String]) -> String {
        let result = wordList.randomElement() ?? "silkworm"
        return result
    }
    
    func startNewGame() -> Bool {
        return !(usedWords.count == 3)
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var refWord = rootWord
        for letter in word {
            if let pos = refWord.firstIndex(of: letter) {
                refWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let chcker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = chcker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location ==  NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
