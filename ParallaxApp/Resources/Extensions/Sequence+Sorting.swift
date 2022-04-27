//
//  Sequence+Sorting.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import Foundation

public extension Collection {
    
    func sorted<T>(by keyPath: KeyPath<Element, T>, with sorting: (T, T) -> Bool) -> [Element] {
        sorted { sorting($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
}
