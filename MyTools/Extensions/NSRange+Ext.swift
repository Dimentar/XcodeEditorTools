import Foundation

extension NSRange {
    init(_ range: CountableClosedRange<Int>) {
        self = NSRange(location: range.lowerBound, length: range.upperBound - range.lowerBound + 1)
    }
}
