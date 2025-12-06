//
//  main.swift
//  Day 06
//
//  Created by Wladyslaw Kuczynski on 06/12/2025.
//

import Foundation

//let url = URL(fileURLWithPath: "input_test.txt")
let url = URL(fileURLWithPath: "input.txt")

func part1() async throws {
    var values = [[Int]]()
    var sums = [Int]()

    for try await line in url.lines {
        let split = line.split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
        if Int(split[0]) != nil {
            if values.isEmpty {
                values = (0..<split.count).map { _ in [Int]() }
            }
            for index in 0..<split.count {
                values[index].append(Int(split[index])!)
            }
        } else {
            for (index, operation) in split.enumerated() {
                if operation == "+" {
                    sums.append(values[index].reduce(0, +))
                } else {
                    sums.append(values[index].reduce(1, *))
                }
            }
        }
    }
    print(sums.reduce(0, +))
    print(values)
}

try await part1()
