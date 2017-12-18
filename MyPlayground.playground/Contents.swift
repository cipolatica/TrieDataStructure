//: Playground - noun: a place where people can play

import UIKit

let trie = Trie()
if trie.addFile(fileName: "TextFile", fileType: "txt") {
    
    print("\ncontains:")
    print(trie.contains(word: "Steve")) //true
    print(trie.contains(word: "Steven")) //true
    print(trie.contains(word: "College")) //true
    print(trie.contains(word: "1985")) //true
    print(trie.contains(word: "Alberto")) //false
    print(trie.contains(word: "tree")) //false
    
    print("\nprintAllWords:")
    trie.printAllWords(startingWith: "st")
    print()
    trie.printAllWords(startingWith: "198")
    print("\ncontainsAllWords:")
    print(trie.containsAllWords(toMake: "after and and and a are")) //true
    print(trie.containsAllWords(toMake: "after and and and after a are")) //false
    print(trie.containsAllWords(toMake: "as")) //true
    print(trie.containsAllWords(toMake: "as as")) //false
    print(trie.containsAllWords(toMake: "")) //false
    print(trie.containsAllWords(toMake: "deer")) //true
    print(trie.containsAllWords(toMake: "addition addition")) // true
    print(trie.containsAllWords(toMake: "addition addition addition")) //false
    
}
else {
    print("Did not add file")
}

