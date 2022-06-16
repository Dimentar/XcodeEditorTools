import Foundation

struct LinesSequenceBuilder {
    func rangeOfSequence(matching isMatching: (String) -> Bool, from lines: [String]) -> CountableClosedRange<Int>? {
        var start: Int?
        var end: Int?

        for (index, line) in lines.enumerated() {
            if isMatching(line) {
                if start == nil {
                    start = index
                    end = index
                } else {
                    end = index
                }
            } else if start != nil, end != nil {
                break
            }
        }

        if let start = start, let end = end {
            return start ... end
        } else {
            return nil
        }
    }
}
