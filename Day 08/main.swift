//
//  main.swift
//  Day 08
//
//  Created by Wladyslaw Kuczynski on 08/12/2025.
//

import Foundation

let url = URL(fileURLWithPath: "input_test.txt")
//let url = URL(fileURLWithPath: "input.txt")

struct JBox: Hashable, CustomStringConvertible {
    let x, y, z: Double

    var description: String { "(\(x), \(y), \(z))" }
}

struct Connection: Hashable {
    private(set) var boxes: Set<JBox>
    let distance: Double

    init(b1: JBox, b2: JBox) {
        boxes = [b1, b2]
        self.distance = Connection.calculateDistance(b1, b2)
    }

    static func calculateDistance(_ b1: JBox, _ b2: JBox) -> Double {
        sqrt(pow((b1.x - b2.x), 2) + pow((b1.y - b2.y), 2) + pow((b1.z - b2.z), 2))
    }

    static func == (lhs: Connection, rhs: Connection) -> Bool {
        lhs.boxes == rhs.boxes
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(boxes)
    }
}

func part1() async throws {
    var boxes = [JBox]()

    for try await line in url.lines {
        let coords = line.split(separator: ",").map { Double(Int($0)!) }
        boxes.append(JBox(x: coords[0], y: coords[1], z: coords[2]))
    }

    var circuits = [Set<JBox>]()

    let distances = Set(boxes.flatMap { box1 in
        boxes.map { Connection(b1: box1, b2: $0) }
            .filter { $0.distance > 0 }
    }).sorted(by: { $0.distance < $1.distance })

    var connections = 0
    for distance in distances {
        let connectedCircuits = circuits.enumerated().filter { !distance.boxes.isDisjoint(with: $0.element) }
        if connectedCircuits.count > 0 {
            circuits[connectedCircuits[0].offset] = connectedCircuits.reduce(Set<JBox>(), { $0.union($1.element) }).union(distance.boxes)
            if connectedCircuits.count > 1 {
                for circuit in connectedCircuits[1..<connectedCircuits.count] {
                    circuits.remove(at: circuit.offset)
                }
            }
            connections += 1
        } else {
            circuits.append(distance.boxes)
            connections += 1
        }
        if connections == 10 {
            break
        }
    }

    print(circuits.lazy.map { $0.count }.sorted(by: >).prefix(3))
    print(circuits.lazy.map { $0.count }.sorted(by: >).prefix(3).reduce(1, *))
}

func part2() async throws {
    var boxes = [JBox]()

    for try await line in url.lines {
        let coords = line.split(separator: ",").map { Double(Int($0)!) }
        boxes.append(JBox(x: coords[0], y: coords[1], z: coords[2]))
    }

    let connections = Set(boxes.flatMap { box1 in
        boxes.map { Connection(b1: box1, b2: $0) }
            .filter { $0.distance > 0 }
    }).sorted(by: { $0.distance < $1.distance })

    var circuits = [Set<JBox>]()
    var lastConnection = connections[0]

    for distance in connections {
        let connectedCircuits = circuits.enumerated().filter { !distance.boxes.isDisjoint(with: $0.element) }
        if connectedCircuits.count > 0 {
            circuits[connectedCircuits[0].offset] = connectedCircuits.reduce(Set<JBox>(), { $0.union($1.element) }).union(distance.boxes)
            if connectedCircuits.count > 1 {
                for circuit in connectedCircuits[1..<connectedCircuits.count] {
                    circuits.remove(at: circuit.offset)
                }
            }
        } else {
            circuits.append(distance.boxes)
        }
        circuits.sort(by: { $0.count > $1.count })
        if circuits[0].count == boxes.count {
            lastConnection = distance
            break
        }
    }

    print(lastConnection)
    print(lastConnection.boxes.reduce(1, { $0 * $1.x }))
}

try await part1()
try await part2()
