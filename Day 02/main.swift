//
//  main.swift
//  Day 02
//
//  Created by Wladyslaw Kuczynski on 02/12/2025.
//

import Foundation

let test = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
let input = "245284-286195,797927-983972,4949410945-4949555758,115-282,8266093206-8266228431,1-21,483873-655838,419252-466133,6190-13590,3876510-4037577,9946738680-9946889090,99954692-100029290,2398820-2469257,142130432-142157371,9797879567-9798085531,209853-240025,85618-110471,35694994-35766376,4395291-4476150,33658388-33694159,680915-772910,4973452995-4973630970,52-104,984439-1009605,19489345-19604283,22-42,154149-204168,7651663-7807184,287903-402052,2244-5558,587557762-587611332,307-1038,16266-85176,422394377-422468141"
let ranges = input.split(separator: ",")

func part1() {
    var invalidIDs = 0
    for range in ranges {
        let splitRange = range.split(separator: "-")
        for id in Int(splitRange[0])!...Int(splitRange[1])! {
            let stringID = String(id)
            guard stringID.count % 2 == 0 else { continue }
            if stringID.dropFirst(stringID.count / 2) == stringID.dropLast(stringID.count / 2) {
                invalidIDs += id
            }
        }
    }
    print("Part 1 - invalidIDs: \(invalidIDs)")
}

func part2() {
    var invalidIDs = 0
    for range in ranges {
        let splitRange = range.split(separator: "-")
        let minValue = Int(splitRange[0])!
        let maxValue = Int(splitRange[1])!

        for id in minValue...maxValue {
            guard id > 10 else { continue }
            let digits = Array(String(id))

            let isInvalid = (1...digits.count / 2).contains(where: { step in
                guard digits.count % step == 0 else { return false }
                let sequence = digits[0..<step]
                let repeatingSequence = (1..<(digits.count / step)).allSatisfy {
                    let start = $0 * step
                    let end = start + step
                    return digits[start..<end] == sequence
                }
                return repeatingSequence
            })

            if isInvalid {
                invalidIDs += id
            }
        }
    }
    print("Part 2 - invalidIDs: \(invalidIDs)")
}

part1()
part2()
