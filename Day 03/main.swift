//
//  main.swift
//  Day 03
//
//  Created by Wladyslaw Kuczynski on 03/12/2025.
//

import Foundation

//let url = URL(fileURLWithPath: "input_test.txt")
let url = URL(fileURLWithPath: "input.txt")
var totalVoltage = 0

struct Battery: Comparable {
    let index: Int
    let voltage: Character

    static func < (lhs: Battery, rhs: Battery) -> Bool {
        lhs.voltage < rhs.voltage
    }
}

extension String {
    var batteries: [Battery] {
        enumerated().map { Battery(index: $0.offset, voltage: $0.element) }
    }
}

func part1() async throws -> Int {
    var voltage = 0

    for try await line in url.lines {
        let batteries = line.batteries

        let firstMax = batteries.dropLast().max()!
        let lastMax = batteries[firstMax.index + 1..<batteries.count].max()!

        voltage += Int("\(firstMax.voltage)\(lastMax.voltage)")!
    }
    return voltage
}

func part2(numberOfBatteries: Int = 12) async throws -> Int {
    var voltage = 0
    for try await line in url.lines {
        let batteries = line.batteries

        let batteryRow = (1...numberOfBatteries).reduce([Battery](), { batteryRow, i in
            let start = (batteryRow.last?.index ?? -1) + 1
            let end = batteries.count - numberOfBatteries + i
            let max = batteries[start..<end].max()!
            return batteryRow + [max]
        })

        voltage += Int(String(batteryRow.map(\.voltage)))!
    }
    return voltage
}

let p1 = try await part1()
print(p1)
assert(p1 == 17445)

let p2 = try await part2()
print(p2)
assert(p2 == 173229689350551)
