//
//  main.swift
//  AdventOfCode
//
//  Created by Wladyslaw Kuczynski on 30/11/2025.
//

import Foundation

//try await day1_p1()
//try await day1_p2()
//try await day10()
try await Day2().main()

func day1_p1() async throws {
    let url = URL(fileURLWithPath: "input.txt")

    var array1 = [Int]()
    var array2 = [Int]()
    for try await line in url.lines {
        let components = line.split(separator: " ", omittingEmptySubsequences: true)
        array1.append(Int(components[0])!)
        array2.append(Int(components[1])!)
    }
    array1.sort()
    array2.sort()

    var sum = 0
    for i in 0..<array1.count {
        let diff = abs(array1[i] - array2[i])
        sum += diff
    }
    print(sum)
}

func day1_p2() async throws {
    let url = URL(fileURLWithPath: "input.txt")
    var sum = 0

    var leftList = [Int: Int]()
    var rightList = [Int: Int]()
    for try await line in url.lines {
        let components = line.split(separator: " ", omittingEmptySubsequences: true)
        let left = Int(components[0])!
        let right = Int(components[1])!
        leftList[left] = (leftList[left] ?? 0) + 1
        rightList[right] = (rightList[right] ?? 0) + 1
    }

    for left in leftList {
        guard let right = rightList[left.key] else { continue }
        sum += left.key * left.value * right
    }
    print(sum)
}

func day10() async throws {
    struct Coordinate: Hashable {
        let x: Int
        let y: Int

        func advanced(dx: Int = 0, dy: Int = 0) -> Coordinate {
            Coordinate(x: x + dx, y: y + dy)
        }
    }

    let url = URL(fileURLWithPath: "input3.txt")
    var map = [[Int]]()
    for try await line in url.lines {
        var row = [Int]()
        for char in line {
            row.append(Int(String(char))!)
        }
        map.append(row)
    }

    print(map)

    let maxX = map[0].count - 1
    let maxY = map.count - 1
    var trailheads = [Coordinate: Int]()

    for y in 0..<map.count {
        for x in 0..<map[y].count {
            if map[y][x] == 0 {
                trailheads[Coordinate(x: x, y: y)] = 0
            }
        }
    }

    for trailhead in trailheads {
//        print(explore(point: trailhead.key))
        investigate(map: map, startingPoint: trailhead.key)
    }

    func investigate(map: [[Int]], startingPoint: Coordinate) -> Int {
        var visited = Set<Coordinate>()
        var count = 0

        func explore(point: Coordinate, previousElevation: Int? = nil) {
            guard point.x >= 0, point.x <= maxX, point.y >= 0, point.y <= maxY else { return }
            // check if eligible path
            let currentElevation = map[point.y][point.x]
            if let previousElevation {
                guard (currentElevation - previousElevation) == 1, !visited.contains(point) else { return }
            }
            print("current point: \(point) value: \(currentElevation), previous \(previousElevation)")
            if map[point.y][point.x] == 9 {
                count += 1
                return
            }

            visited.insert(point)

            let nextSteps = [
                point.advanced(dx: -1), // left
                point.advanced(dx: 1),  // right
                point.advanced(dy: -1), // up
                point.advanced(dy: 1)   // down
            ]

            for nextStep in nextSteps {
                explore(point: nextStep, previousElevation: currentElevation)
            }

//            visited.dropLast()
        }

        explore(point: startingPoint)
        return count
    }
}
