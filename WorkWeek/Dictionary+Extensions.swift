//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

extension Dictionary {
    mutating func merge(_ input: Dictionary) {
        for (key, value) in input {
            self[key] = value
        }
    }
}
