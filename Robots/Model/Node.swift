//
//  Node.swift
//  Robots
//
//  Created by Anonymous Account on 14/11/22.
//

import Foundation

struct Node: Equatable {
    var row : Int
    var column : Int

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
