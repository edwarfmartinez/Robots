//
//  Queue.swift
//  Robots
//
//  Created by Anonymous Account on 14/11/22.
//

import Foundation

struct Queue<T>: Sequence, IteratorProtocol {
    var storage:[T] = []
    
    func isEmpty() -> Bool {
        return storage.isEmpty
    }
    
    var peek:T? {
        return storage.first
    }
        
    init() {}
    
    mutating func enQueue(_ element: T) {
        storage.append(element)
    }
    
    mutating func deQueue() -> T? {
        guard !isEmpty() else {
            print(K.errorDequeue)
            return nil
        }
        return storage.removeFirst()
    }
    
    var current = 0
    mutating func next() -> Int? {
        if storage.count == current {
            return nil
        } else {
            defer { current += 1 }
            return current
        }
    }
    
}

//MARK: - Extensions

extension Queue: CustomStringConvertible {
    var description: String {
        return String.init(describing: storage)
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
