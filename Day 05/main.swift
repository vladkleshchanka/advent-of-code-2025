//
//  main.swift
//  Day 05
//
//  Created by Wladyslaw Kuczynski on 05/12/2025.
//

import Foundation

//let url1 = URL(fileURLWithPath: "input_test_1.txt")
let url1 = URL(fileURLWithPath: "input_1.txt")

func part1() async throws {
    var ranges = [ClosedRange<Int>]()
    var validIngredients = 0
    for try await line in url1.lines {
        if let id = Int("\(line)") {
            if ranges.contains(where: { $0.contains(id) }) {
                validIngredients += 1
            }
        } else {
            let range = line.split(separator:"-")
            ranges.append(Int("\(range[0])")!...Int("\(range[1])")!)
        }
    }
    print(ranges)
    print(validIngredients)
}

//let url2 = URL(fileURLWithPath: "input_test_2.txt")
let url2 = URL(fileURLWithPath: "input_2.txt")

func part2() async throws {
    var ranges = [ClosedRange<Int>]()
    for try await line in url2.lines {
        let rangeLine = line.split(separator:"-")
        let range = Int("\(rangeLine[0])")!...Int("\(rangeLine[1])")!
        ranges.append(range)
    }
    let normalizedRanges = normalize2(ranges: ranges)
    let count = normalizedRanges.reduce(0) { $0 + $1.count }
    print(count)
    assert(count == 332067203034711)
}

func normalize(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    guard ranges.count > 1 else { return ranges }
    let range = ranges[0]
    var slice = ranges.dropFirst()
    if let overlappingRangeIndex = slice.firstIndex(where: { $0.overlaps(range) }) {
        let overlappingRange = slice[overlappingRangeIndex]
        if overlappingRange.contains(range) {
            return normalize(ranges: Array(slice))
        } else if range.contains(overlappingRange)  {
            slice[overlappingRangeIndex] = range
            return normalize(ranges: Array(slice))
        } else {
            if range.upperBound > overlappingRange.upperBound {
                slice[overlappingRangeIndex] = overlappingRange.lowerBound...range.upperBound
            } else {
                slice[overlappingRangeIndex] = range.lowerBound...overlappingRange.upperBound
            }
            return normalize(ranges: Array(slice))
        }
    } else {
        return [range] + normalize(ranges: Array(slice))
    }
}

// Post-solution chatgpt inspired improvement
func normalize2(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    guard !ranges.isEmpty else { return [] }

    // 1. Sort by lower bound
    let sorted = ranges.sorted { $0.lowerBound < $1.lowerBound }

    // 2. Merge in one linear pass
    var merged: [ClosedRange<Int>] = []
    merged.reserveCapacity(sorted.count)

    var current = sorted[0]

    for next in sorted.dropFirst() {
        if next.lowerBound <= current.upperBound {
            // Overlapping or touching: merge
            current = current.lowerBound ... max(current.upperBound, next.upperBound)
        } else {
            // Disjoint: push and continue
            merged.append(current)
            current = next
        }
    }

    // append last range
    merged.append(current)

    return merged
}

//try await part1()
try await part2()
