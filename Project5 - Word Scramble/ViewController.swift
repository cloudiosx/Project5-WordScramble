//
//  ViewController.swift
//  Project5 - Word Scramble
//
//  Created by John Kim on 1/28/22.
//

import UIKit

class ViewController: UITableViewController {
    
    // Properties
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create a UIBarButtonItem to run the promptForAnswer() method
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Find start.txt file URL, convert it to a String instance, then convert it to an array separated by "\n"
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                print(startWords)
                allWords = startWords.components(separatedBy: "\n")
            }
            /*
            let startWords = try! String(contentsOf: startWordsURL)
            print(startWords)
            allWords = startWords.components(separatedBy: "\n")
            */
        }
        
        // If start.txt file is empty, then set allWords array to be ["silkworm"]
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        // startGame() method call
        
        startGame()
    }
    
    // Objective-C Methods
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAnswer = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text?.lowercased() else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAnswer)
        present(ac, animated: true)
    }
    
    // Methods
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func submit(_ answer: String) {
        let lowercaseAnswer = answer.lowercased()
        
        if isSame(word: lowercaseAnswer) {
            if isPossible(word: lowercaseAnswer) {
                if isOriginal(word: lowercaseAnswer) {
                    if isReal(word: lowercaseAnswer) {
                        usedWords.insert(answer, at: 0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
    //                    tableView.reloadData()
                        return
                    } else {
                        showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                    }
                } else {
                    showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
                }
            } else {
                guard let title = title?.lowercased() else { return }
                showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
            }
        } else {
            showErrorMessage(errorTitle: "Word is same as title", errorMessage: "You can't use the same word as the title!")
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Conditions to check if the word is possible, original, and real
    
    func isSame(word: String) -> Bool {
        guard let lowercaseTitle = title?.lowercased() else { return false }
        if (lowercaseTitle == word) { return false }
        return true
    }
    
    func isPossible(word: String) -> Bool {
        guard var lowercaseTitle = title?.lowercased() else { return false }
        
        for letter in word {
            if let index = lowercaseTitle.firstIndex(of: letter) {
                lowercaseTitle.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if (word.count < 3) { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    // UITableViewController methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

