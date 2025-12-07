//
//  main.swift
//  Day 07
//
//  Created by Wladyslaw Kuczynski on 07/12/2025.
//

import Foundation

let url = URL(fileURLWithPath: "input_test.txt")
//let url = URL(fileURLWithPath: "input.txt")

func part1() async throws {
    var matrix = [[Character]]()
    var beamSplits = 0

    for try await line in url.lines {
        matrix.append(Array(line))
        if matrix.count == 1 { continue }
        for (index, character) in (matrix.last!).enumerated() {
            let previousLine = matrix.count - 2
            let currentLine = matrix.count - 1
            if matrix[previousLine][index] == "S" {
                matrix[currentLine][index] = "|"
            }
            if matrix[previousLine][index] == "|" {
                if character == "^" {
                    beamSplits += 1
                    matrix[currentLine][index - 1] = "|"
                    matrix[currentLine][index + 1] = "|"
                } else if character == "." {
                    matrix[currentLine][index] = "|"
                }
            }
        }
    }

//    for i in 0..<matrix.count {
//        print(String(matrix[i]))
//    }
    print(beamSplits)
}

func part2() async throws {
    var matrix = [[String]]()
    for try await line in url.lines {
        matrix.append(Array(line.map { String($0) }))
        if matrix.count == 1 { continue }
        for (index, character) in (matrix.last!).enumerated() {
            let previousLine = matrix.count - 2
            let currentLine = matrix.count - 1
            if matrix[previousLine][index] == "S" {
                matrix[currentLine][index] = "1"
            }
            if let number = Int(String(matrix[previousLine][index])) {
                if character == "^" {
                    let currentLinePrev = Int(String(matrix[currentLine][index - 1])) ?? 0
                    matrix[currentLine][index - 1] = "\(currentLinePrev + number)"
                    matrix[currentLine][index + 1] = matrix[previousLine][index]
                } else if character == "." {
                    let currentLinePrev = Int(String(matrix[currentLine][index])) ?? 0
                    matrix[currentLine][index] = "\(currentLinePrev + number)"
                }
            }
        }
    }

    let result = matrix.last!.compactMap { Int($0) }.reduce(0, +)
//    for i in 0..<matrix.count {
//        print(matrix[i].reduce("", +))
//    }
    print(result)
}

func part2_better() async throws {
    var timelines = [Int]()

    // Build
    for try await line in url.lines.prefix(1) {
        timelines = Array(repeating: 0, count: line.count)
        timelines[line.firstIndex(of: "S")!.utf16Offset(in: line)] = 1
    }

    for try await line in url.lines {
        for (index, character) in line.enumerated() where character == "^" {
            timelines[index - 1] += timelines[index]
            timelines[index + 1] += timelines[index]
            timelines[index] = 0
        }
    }

    let result = timelines.reduce(0, +)
    print(result)
}

try await part1()
try await part2_better()
