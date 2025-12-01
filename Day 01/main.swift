//
//  main.swift
//  day1
//
//  Created by Wladyslaw Kuczynski on 30/11/2025.
//

import Foundation

enum Direction {
    case left, right

    init?(_ c: Character?) {
        if c == "L" {
            self = .left
        } else if c == "R" {
            self = .right
        } else {
            return nil
        }
    }

    var multiplier: Int {
        self == .right ? +1 : -1
    }
}

let url = URL(fileURLWithPath: "input.txt")
var dial = 50
var password = 0

for try await line in url.lines {
    guard let direction = Direction(line.first),
          var rotation = Int(line.dropFirst()) else {
        fatalError("Invalid data")
    }

    password += rotation / 100 // full rotations
    rotation = rotation % 100 // normalise
    var newDial = dial + direction.multiplier * rotation

    var modified = false
    if newDial < 0 {
        newDial += 100
        if dial != 0 {
            password += 1
            modified = true
        }
    } else if newDial > 99 {
        newDial -= 100
        if dial != 0 {
            password += 1
            modified = true
        }
    }

    assert(newDial >= 0 && newDial <= 99)

    if newDial == 0, !modified {
        password += 1
    }
    dial = newDial
}

print("Password: \(password)")
