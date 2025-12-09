//
//  Day_09_2App.swift
//  Day 09 2
//
//  Created by Wladyslaw Kuczynski on 09/12/2025.
//

import SwiftUI
import UIKit

@main
struct Day_09_2App: App {
//        let url = Bundle.main.url(forResource: "input_test", withExtension: ".txt")!
    let url = Bundle.main.url(forResource: "input", withExtension: ".txt")!

    @State var part1: String = "Part 1: ..."

    @State var part2: String = "Part 2: ..."

    var body: some Scene {
        WindowGroup {
            VStack {
                Text(part1)
                Text(part2)
            }.onAppear() {
                Task {
                    try await part1()
                    try await part2()
                }
            }
        }
    }

    func part1() async throws {
        var points = [CGPoint]()

        for try await line in url.lines {
            let coords = line.split(separator: ",").map { Int($0)! }
            points.append(CGPoint(x: coords[0], y: coords[1]))
        }

        let rects = points.flatMap { p1 in
            points.map { p2 in
                CGRect(p1: p1, p2: p2)
            }
        }

        let biggestRect = rects.max(by: { $0.area < $1.area })!

        print("Part 1 - \(biggestRect.area == 4782268188.0)")
        part1 = part1.replacingOccurrences(of: "...", with: String(Int(biggestRect.area)))
    }

    func part2() async throws {
        var points = [CGPoint]()
        let linePath = CGMutablePath()

        for try await line in url.lines {
            let coords = line.split(separator: ",").map { Double(Int($0)!) }
            let point = CGPoint(x: coords[0], y: coords[1])
            points.append(point)
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
                
            }
        }
        linePath.closeSubpath()

        let rectPath = CGMutablePath()
        for i in 1..<points.count {
            let rect = CGRect(p1: points[i - 1], p2: points[i])
            rectPath.addRect(rect)
        }
        rectPath.addRect(CGRect(p1: points[points.count - 1], p2: points[0]))

        let rects = points.flatMap { p1 in
            points.map { p2 in
                CGRect(p1: p1, p2: p2)
            }
        }.sorted(by: { $0.area > $1.area })

        let theBiggest = rects.first(where: {
            let adjustedRect = $0.insetBy(dx: 1, dy: 1)
            return adjustedRect.vertices.allSatisfy { linePath.contains($0) } && !rectPath.intersects(CGPath(rect: adjustedRect, transform: nil))
        })!

        print("Part 2 - \(theBiggest.area == 1574717268.0)")
        part2 = part2.replacingOccurrences(of: "...", with: String(Int(theBiggest.area)))
    }
}

extension CGRect {
    init(p1: CGPoint, p2: CGPoint) {
        let x = min(p1.x, p2.x)
        let y = min(p1.y, p2.y)
        let width = abs(p2.x - p1.x) + 1
        let height = abs(p2.y - p1.y) + 1

        self = .init(x: x, y: y, width: width, height: height)
    }

    var vertices: [CGPoint] {
        [.init(x: minX, y: maxY), .init(x: maxX, y: maxY), .init(x: minX, y: minY), .init(x: maxX, y: minY)]
    }

    var area: Double {
        width * height
    }
}
