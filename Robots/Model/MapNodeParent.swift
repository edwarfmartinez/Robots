//
//  QueueModel.swift
//  Robots
//
//  Created by Anonymous Account on 14/11/22.
//

import Foundation

struct MapNodeParent: Equatable {
    var node : Node
    var parent : Node?

    init(node: Node, parent: Node?) {
        self.node = node
        self.parent = parent
    }
}
