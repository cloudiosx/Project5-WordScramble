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
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAnswer)
        present(ac, animated: true)
    }
    
    // Methods
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func submit(_ answer: String) {
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

