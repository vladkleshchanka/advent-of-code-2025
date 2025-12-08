import Foundation

struct Day2 {
//    let url = URL(fileURLWithPath: "2024_day2_test.txt")
    let url = URL(fileURLWithPath: "2024_day2.txt")

    func main() async throws {
        try await part1()
    }

    func part1() async throws {
        var safeReports = 0

        for try await line in url.lines {
            let levels = line.split(separator: " ", omittingEmptySubsequences: true)
                .map { Int($0)! }
            guard levels[1] - levels[0] != 0 else { continue }
            let isIncreasing = levels[1] - levels[0] >= 0
            var base = levels[0]
            var isSafe = true
            var usedProblemDampener = false
            for level in levels[1..<levels.count] {
                let diff = level - base
                if diff == 0 || abs(diff) > 3 {
                    if !usedProblemDampener {
                        usedProblemDampener = true
                        continue
                    } else {
                        isSafe = false
                        break
                    }
                }
                if isIncreasing && diff < 0 {
                    if !usedProblemDampener {
                        usedProblemDampener = true
                        continue
                    } else {
                        isSafe = false
                        break
                    }
                }
                if !isIncreasing && diff > 0 {
                    if !usedProblemDampener {
                        usedProblemDampener = true
                        continue
                    } else {
                        isSafe = false
                        break
                    }
                }
                base = level
            }
            if isSafe {
                safeReports += 1
            }
        }

        print(safeReports)
    }
}
