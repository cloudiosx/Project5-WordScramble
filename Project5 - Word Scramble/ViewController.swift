//
//  ViewController.swift
//  Project5 - Word Scramble
//
//  Created by John Kim on 1/28/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
}

