import Foundation

extension Array where Element: Equatable {
    
    var duplicatedElementsIndices: Set<Int> {
        var result: [Element] = []
        var indices = Set<Int>()
        for (index, value) in self.enumerated() {
            if !result.contains(value) {
                result.append(value)
            } else {
                indices.insert(index)
            }
        }
        print(indices)
        return indices
    }
}
