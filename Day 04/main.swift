//
//  main.swift
//  Day 04
//
//  Created by Wladyslaw Kuczynski on 04/12/2025.
//

import Foundation

//let url = URL(fileURLWithPath: "input_test.txt")
let url = URL(fileURLWithPath: "input.txt")

@MainActor
func getInput() async throws -> [[Character]] {
    var grid = [[Character]]()
    for try await line in url.lines {
        grid.append(Array(line))
    }
    return grid
}

typealias Index = (i: Int, j: Int)

let indexes: [Index] = [
    (0, -1), // left
    (-1, -1), // top - left
    (-1, 0), // top
    (-1, 1), // top - right
    (0, 1), // right
    (1, 1), // bottom - right
    (1, 0), // bottom
    (1, -1), // bottom - left
]

func part1() async throws {
    let grid = try await getInput()

    var accessibleRolls = 0

    for i in 0..<grid.count {
        for j in 0..<grid[i].count where grid[i][j] == "@" {
            let indexes: [Index] = indexes.filter {
                i + $0.i >= 0 && i + $0.i < grid.count && j + $0.j >= 0 && j + $0.j < grid[j].count
            }

            let neighbours = indexes.reduce(0) { sum, next in
                sum + (grid[i + next.i][j + next.j] == "@" ? 1 : 0)
            }

            if neighbours < 4 {
                accessibleRolls += 1
            }
        }
    }
    print(accessibleRolls)
    assert(accessibleRolls == 1569)
}

@MainActor
func part2() async throws {
    var grid = try await getInput()

    var totalRemoved = 0
    var removed = true

    while removed {
        removed = false
        for i in 0..<grid.count {
            for j in 0..<grid[i].count where grid[i][j] == "@" {
                let indexes: [Index] = indexes.filter {
                    i + $0.i >= 0 && i + $0.i < grid.count && j + $0.j >= 0 && j + $0.j < grid[j].count
                }

                let neighbours = indexes.reduce(0) { sum, next in
                    sum + (grid[i + next.i][j + next.j] == "@" ? 1 : 0)
                }

                if neighbours < 4 {
                    grid[i][j] = "."
                    totalRemoved += 1
                    removed = true
                }
            }
        }
    }
    print(totalRemoved)
    assert(totalRemoved == 9280)
}

try await part1()
try await part2()
