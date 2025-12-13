//
//  main.swift
//  Day 11
//
//  Created by Wladyslaw Kuczynski on 11/12/2025.
//

import Foundation

//let url = URL(fileURLWithPath: "input_test.txt")
//let url = URL(fileURLWithPath: "input_test_2.txt")
let url = URL(fileURLWithPath: "input.txt")

class Device: Hashable {
    let key: String
    var outputs: Set<Device> = []
    let outs: [String]

    init(key: String, outs: [String]) {
        self.key = key
        self.outs = outs
    }

    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.key == rhs.key
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

func buildDevicesGraph(url: URL) async throws -> [String: Device] {
    var devices = [String: Device]()
    for try await line in url.lines {
        let line = line.split(separator: ":")
        let input = line[0].trimmingCharacters(in: .whitespaces)
        let outputs = line[1].split(separator: " ", omittingEmptySubsequences: true).map { $0.trimmingCharacters(in: .whitespaces) }
        devices[input] = Device(key: input, outs: outputs)
    }

    devices["out"] = Device(key: "out", outs: [])
    for device in devices.values {
        device.outputs = Set(device.outs.compactMap { devices[$0] })
    }
    return devices
}

func part1() async throws {
    func traverse(devices: [String: Device], input: String, count: inout Int) {
        let nextPaths = devices[input]!.outs
        for path in nextPaths {
            if path == "out" {
                count += 1
                return
            } else {
                traverse(devices: devices, input: path, count: &count)
            }
        }
    }

    let devices = try await buildDevicesGraph(url: url)
    var count = 0
    traverse(devices: devices, input: "you", count: &count)
    print(count)
}

func part2() async throws {
    let devices = try await buildDevicesGraph(url: url)
    let start = devices["svr"]!
//    let start = devices["dac"]!
//    let start = devices["fft"]!

//    let end = devices["fft"]!
//    let end = devices["dac"]!
    let end = devices["out"]!

    var current: [Device: Int] = [start: 1]
    var outCount = 0
    while !current.isEmpty {
        let next = current.reduce(into: [:]) { acc, element in
            element.key.outputs.forEach {
                acc[$0, default: 0] += element.value
            }
        }
        outCount += next[end] ?? 0 // count out devices
        current = next
    }
    print(outCount)
}

try await part1()
try await part2()
