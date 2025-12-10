import Foundation

let url = URL(fileURLWithPath: "input_test.txt")
//let url = URL(fileURLWithPath: "input.txt")

/// n^n
/// where n = toggles.count


/// [1 - 2 - 3 - 4]
/// [11, 12, 13, 14 - 21, 22, 23, 24 - 31, 32, 33, 34 - 41, 42, 43, 44]
/// [111, 112, 113, 114 - 121, 122, 123, 124 - 131, 132, 133, 134...]

struct Machine {
    var indicators = Indicators()
    var joltages = Joltages()
    var toggles = [Sequence]()
}

typealias Indicators = [Bool]
typealias Joltages = [Int]
typealias Sequence = [Int]

extension Indicators {
    func apply(_ toggles: [Int]) -> Indicators {
        var indicators = self
        for toggle in toggles {
            indicators[toggle].toggle()
        }
        return indicators
    }
}

func part1() async throws {
    let indicators = Regex(/[.#]+/)
    let toggles = Regex(/\([\d,]+\)/)
    var machines = [Machine]()
    for try await line in url.lines {
        var machine = Machine()
        if let indicatorMatchRange = line.firstMatch(of: indicators)?.range {
            machine.indicators = line[indicatorMatchRange].map { $0 == "#" }
        }
        machine.toggles = line.matches(of: toggles).map {
            line[$0.range].filter { $0.isNumber || $0 == "," }.split(separator: ",").map { Int($0)! }
        }
        machines.append(machine)
    }

    var allAttempts = 0
    for machine in machines {
        var attempt = 0
        var options = Array(repeating: Array(repeating: false, count: machine.indicators.count), count: machine.toggles.count)

        var finished: Bool = false
        while !finished {
            attempt += 1
            var newVariations = [Indicators]()
            for i in 0..<options.count {
                var vars = [Indicators]()
                for sequence in machine.toggles {
                    let result = options[i].apply(sequence)
                    if result == machine.indicators {
                        finished = true
                        break
                    }
                    vars.append(result)
                }
                newVariations += vars
            }
            options += newVariations
        }
        print(attempt)
        allAttempts += attempt
    }
    print("result: \(allAttempts)")
}

func part2() async throws {
    let joltage = Regex(/\{[\d,]+\}/)
    let toggles = Regex(/\([\d,]+\)/)
    var machines = [Machine]()
    for try await line in url.lines {
        var machine = Machine()
        if let indicatorMatchRange = line.firstMatch(of: joltage)?.range {
            machine.indicators = line[indicatorMatchRange].map { $0 == "#" }
        }
         if let match = line.firstMatch(of: joltage) {
             machine.joltages = line[match.range].filter { $0.isNumber || $0 == "," }.split(separator: ",").map { Int($0)! }
        }

        machine.toggles = line.matches(of: toggles).map {
            line[$0.range].filter { $0.isNumber || $0 == "," }.split(separator: ",").map { Int($0)! }
        }
        machines.append(machine)
    }

//    var allAttempts = 0
//    for machine in machines {
//        var attempt = 0
//        var options = Array(repeating: Array(repeating: false, count: machine.indicators.count), count: machine.toggles.count)
//
//        var finished: Bool = false
//        while !finished {
//            attempt += 1
//            var newVariations = [Indicators]()
//            for i in 0..<options.count {
//                var vars = [Indicators]()
//                for sequence in machine.toggles {
//                    let result = options[i].apply(sequence)
//                    if result == machine.indicators {
//                        finished = true
//                        break
//                    }
//                    vars.append(result)
//                }
//                newVariations += vars
//            }
//            options += newVariations
//        }
//        print(attempt)
//        allAttempts += attempt
//    }
//    print("result: \(allAttempts)")
}

//try await part1()
try await part2()
