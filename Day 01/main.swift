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

func day2(){
    let input = "245284-286195,797927-983972,4949410945-4949555758,115-282,8266093206-8266228431,1-21,483873-655838,419252-466133,6190-13590,3876510-4037577,9946738680-9946889090,99954692-100029290,2398820-2469257,142130432-142157371,9797879567-9798085531,209853-240025,85618-110471,35694994-35766376,4395291-4476150,33658388-33694159,680915-772910,4973452995-4973630970,52-104,984439-1009605,19489345-19604283,22-42,154149-204168,7651663-7807184,287903-402052,2244-5558,587557762-587611332,307-1038,16266-85176,422394377-422468141"
    let ranges = input.split(",")
    var invalidIDs = 0
    for range in ranges {
        let splitRange = range.split("-")
        let minValue = Int(splitRange[0])
        let maxValue = Int(splitRange[1])
        
        let minCount = splitRange[0].count
        let maxCount = splitRange[1].count
        
        let eligableCounts = (minCount...maxcount).filter { $0 % 2 == 0 }
        
        for count in eligableCounts {
            1 * (count / 2) * 10
            clampto(min,max)
            let variations = max - min
            invalidIDs += variations
        }
    }
    
    
    
    
    
    
}
