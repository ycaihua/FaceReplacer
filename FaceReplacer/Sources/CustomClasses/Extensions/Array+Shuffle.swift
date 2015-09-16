//
//  Array+Shuffle.swift
//  UCranePlayer
//
//  Created by Admin on 10.09.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

/*
// MARK: - For Swift 1.2
extension Array
{
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}*/

// MARK: - For Swift 2.0
extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}
