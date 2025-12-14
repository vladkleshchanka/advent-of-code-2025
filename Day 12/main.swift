//
//  main.swift
//  Day 12
//
//  Created by Wladyslaw Kuczynski on 14/12/2025.
//

import Foundation

//let urlRegions = URL(fileURLWithPath: "input_regions.txt")
//let urlShapes = URL(fileURLWithPath: "input_shapes.txt")
let urlRegions = URL(fileURLWithPath: "input_regions_test.txt")
let urlShapes = URL(fileURLWithPath: "input_shapes_test.txt")

typealias Shape = [[Character]]
struct Region {
    let width: Int
    let height: Int
    let requirements: [Int]
}

func part1() async throws {
    var shapes = [Shape]()
    var shape = Shape()
    for try await line in urlShapes.lines {
        if line.isEmpty {
            shapes.append(shape)
            shape = Shape()
        } else {
            if line.contains(/\d:/) {
                continue
            } else {
                
            }
        }
    }
}

try await part1()
