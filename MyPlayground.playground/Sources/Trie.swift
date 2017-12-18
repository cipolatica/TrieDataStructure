//
//  File.swift
//  Trie
//
//  Created by Alberto Plata on 12/11/17.
//  Copyright © 2017 Alberto Plata. All rights reserved.
//

import Foundation

class TrieNode<T: Hashable> {
    
    var value: Character?
    weak var parent: TrieNode?
    var children: [Character: TrieNode] = [:]
    var endOfWordCounter: Int
    
    init(value: Character? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
        self.endOfWordCounter = 0
    }
    
    func add(_ child: Character) {
        guard children[child] == nil else { return }
        
        children[child] = TrieNode(value: child, parent: self)
    }
}

public class Trie {
    typealias Node = TrieNode<Character>
    fileprivate let root: Node
    
    public init() {
        root = TrieNode<Character>()
    }
    
    private func getNode(atEndof word:String) -> Node? {
        guard !word.isEmpty else { return nil }
        
        var currentNode = root
        let characters = Array(word.lowercased())
        var currentIndex = 0
        
        while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
            currentIndex += 1
            currentNode = child
        }
        if currentIndex == characters.count {
            return currentNode
        }
        return nil
    }
    
    public func insert(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        
        var currentNode = root
        let characters = Array(word.lowercased())
        
        for char in characters {
            if let child = currentNode.children[char] {
                currentNode = child
            } else {
                currentNode.add(char)
                currentNode = currentNode.children[char]!
            }
        }
        currentNode.endOfWordCounter += 1
        return true
    }
    
    public func contains(word: String) -> Bool {
        
        if let node = getNode(atEndof: word) {
            return node.endOfWordCounter > 0
        }
        return false
    }
    
    private func printString(_ string:String, with node:Node) {
        guard node.endOfWordCounter > 0 else { return }
        
        print(string, terminator:"")
        if node.endOfWordCounter > 1 {
            print(" (times \(node.endOfWordCounter))")
        }
        else {
            print()
        }
    }
    
    private func printAllWords(startingWith prefix: String, from dict:[Character:Node]){
        for (char,node) in dict {
            let newPrefix = prefix + String(char)
            printString(newPrefix, with: node)
            printAllWords(startingWith: newPrefix, from: node.children)
        }
    }
    
    public func printAllWords(startingWith prefix: String){
        
        if let node = getNode(atEndof: prefix) {
            printString(prefix, with: node)
            printAllWords(startingWith: prefix, from: node.children)
        }
    }
    
    func readFile(fileName: String, fileType: String) -> String? {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                var text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                print("Read in text: \n\(text)\n")
                let pattern = "[^A-Za-z0-9 ]*"
                text = text.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
                print("Removed special characters: \n\(text)\n")
                return text
            } catch let error {
                print("error reading file again: \(error)")
                return nil
            }
        }
        return nil
    }
    
    public func addFile(fileName: String, fileType: String) -> Bool {
        
        if let text = readFile(fileName: fileName, fileType: fileType) {
            let words = text.components(separatedBy: " ")
            for word in words {
                _ = insert(word: word)
            }
            return true
        }
        return false
    }
    
    public func containsAllWords(toMake sentence:String) -> Bool {
        
        let words = sentence.components(separatedBy: " ")
        var wordDict: [String:Int] = [:]
        
        for word in words {
            if let amount = wordDict[word] {
                if amount == 0 {
                    return false
                }
                wordDict[word] = amount-1
            }
            else if let node = getNode(atEndof: word) {
                if node.endOfWordCounter > 0 {
                    wordDict[word] = node.endOfWordCounter-1
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        return true
    }
}
