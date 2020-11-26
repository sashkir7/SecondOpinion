//
//  Created by Dmitry Frishbuter on 11/05/2019.
//  Copyright © 2019 Ronas IT. All rights reserved.
//

// MARK: -  Filter

extension Sequence {

    /// Returns collection of elements that are having value at certain key path equal to value at key path of passed element.
    ///
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be Equatable.
    ///   - element: The element which value at key path must be compared with value at similar key path of elements in sequence.
    /// - Returns: Filtered collection based on key path.
    func filter<T: Equatable>(by keyPath: KeyPath<Element, T>, of element: Element) -> [Element] {
        return filter { entry -> Bool in
            entry[keyPath: keyPath] == element[keyPath: keyPath]
        }
    }

    /// Returns collection of elements that are having specific value at certain key path.
    ///
    /// - Parameters:
    ///   - value: The value, that an element must have to be included in the returned collection.
    ///   - keyPath: Key path to compare, must be Equatable.
    /// - Returns: Filtered collection based on key path.
    func filter<T: Equatable>(by value: T, at keyPath: KeyPath<Element, T>) -> [Element] {
        return filter { entry -> Bool in
            entry[keyPath: keyPath] == value
        }
    }

    /// Returns collection of elements that has value at certain key path that satisfies the given predicate.
    ///
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be Equatable.
    ///   - isIncluded: A closure that takes a value at key path of an element of the sequence as its argument
    ///                 and returns a `Boolean` value indicating whether the element should be included in the returned collection.
    /// - Returns: A collection of the elements for which key paths `isIncluded` allowed.
    func filter<T: Equatable>(by keyPath: KeyPath<Element, T>, isIncluded: (T) -> Bool) -> [Element] {
        return filter { entry -> Bool in
            isIncluded(entry[keyPath: keyPath])
        }
    }
}

// MARK: -  Map

extension Sequence {

    /// Returns collection of values at key paths of contained elements.
    /// - Parameters:
    ///   - keyPath: Key path to map, must be Equatable.
    func map<T: Equatable>(by keyPath: KeyPath<Element, T>) -> [T] {
        return map { entry -> T in
            entry[keyPath: keyPath]
        }
    }

    /// Returns the value of first element in the sequence, using the given key path to get comparable property.
    /// - Parameters:
    ///   - value: The value that an element must have to be returned.
    ///   - keyPath: Key path to compare and map, must be Equatable.
    func mapFirst<T: Comparable>(with value: T, at keyPath: KeyPath<Element, T>) -> T? {
        let first = self.first(with: value, at: keyPath)
        return first?[keyPath: keyPath]
    }

    /// Returns the value of minimum element in the sequence, using the given key path to get comparable property.
    /// - Parameters:
    ///   - keyPath: Key path to map, must be Equatable.
    func mapMin<T: Comparable>(by keyPath: KeyPath<Element, T>) -> T? {
        let min = self.min(by: keyPath)
        return min?[keyPath: keyPath]
    }

    /// Returns the value of maximum element in the sequence, using the given keyPath to get comparable property.
    /// - Parameters:
    ///   - keyPath: Key path to map, must be Equatable.
    func mapMax<T: Comparable>(by keyPath: KeyPath<Element, T>) -> T? {
        let max = self.max(by: keyPath)
        return max?[keyPath: keyPath]
    }
}

// MARK: -  Reduce

extension Sequence {

    /// Returns the result of combining values at key paths of elements of the sequence.
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - keyPath: Key path to get value to accumulate.
    /// - Returns: The final accumulated value. If the sequence has no elements, the result is `initialResult`.
    func reduce<Result: Numeric>(into initialResult: Result, by keyPath: KeyPath<Element, Result>) -> Result {
        return reduce(into: initialResult) { result, element in
            result += element[keyPath: keyPath]
        }
    }

    /// Returns the result of combining values at key paths of elements of the sequence.
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - keyPath: Key path to get value to accumulate.
    /// - Returns: The final accumulated value. If the sequence has no elements, the result is `initialResult`.
    func reduce(into initialResult: String, by keyPath: KeyPath<Element, String>) -> String {
        return reduce(into: initialResult) { result, element in
            result += element[keyPath: keyPath]
        }
    }
}

// MARK: -  First

extension Sequence {

    /// Returns first element in the sequence that has value at certain key path equal to value at key path of passed element.
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be Equatable.
    ///   - element: The element which value at key path must be equal to value at similar key path of element in sequence.
    /// - Returns: The first element of the sequence that satisfies condition, or `nil` if there is no such element.
    func first<T: Equatable>(by keyPath: KeyPath<Element, T>, of element: Element) -> Element? {
        return first { entry -> Bool in
            entry[keyPath: keyPath] == element[keyPath: keyPath]
        }
    }

    /// Returns first element in the sequence which value at certain key path contained in passed collection.
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be Equatable.
    ///   - elements: A collection of acceptable values.
    /// - Returns: The first element of the sequence that satisfies condition, or `nil` if there is no such element.
    func first<T: Equatable>(by keyPath: KeyPath<Element, T>, containedIn elements: [T]) -> Element? {
        return first { entry -> Bool in
            elements.contains(entry[keyPath: keyPath])
        }
    }

    /// Returns first element in the sequence that has specific value at certain key path.
    /// - Parameters:
    ///   - value: The value that an element must have to be returned.
    ///   - keyPath: Key path to compare, must be Equatable.
    func first<T: Equatable>(with value: T, at keyPath: KeyPath<Element, T>) -> Element? {
        return first { entry -> Bool in
            entry[keyPath: keyPath] == value
        }
    }
}

// MARK: -  Contains

extension Sequence {

    // Returns a `Boolean` value indicating whether the sequence contains an element that has value at certain key path equal to value at similar key path of passed element.
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be Equatable.
    ///   - element: The element which value at key path must be equal to value at similar key path of element in sequence.
    /// - Returns: `true` if the sequence contains an element that satisfies condition; otherwise - `false`.
    func contains<T: Equatable>(by keyPath: KeyPath<Element, T>, of element: Element) -> Bool {
        return contains { entry -> Bool in
            entry[keyPath: keyPath] == element[keyPath: keyPath]
        }
    }

    /// Returns a `Boolean` value indicating whether the sequence contains an element that has specific value at certain key path.
    /// - Parameters:
    ///   - value: The value that an element must have to satisfy the condition.
    ///   - keyPath: Key path to compare, must be Equatable.
    /// - Returns: `true` if the sequence contains an element that satisfies condition; otherwise, `false`.
    func contains<T: Equatable>(with value: T, at keyPath: KeyPath<Element, T>) -> Bool {
        return contains { entry -> Bool in
            entry[keyPath: keyPath] == value
        }
    }
}

// MARK: -  Min/Max

extension Sequence {

    /// Returns the minimum element in the sequence, using the given key path to get comparable property.
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be `Comparable`.
    func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        return self.min { first, second -> Bool in
            first[keyPath: keyPath] < second[keyPath: keyPath]
        }
    }

    /// Returns the maximum element in the collection, using the given keyPath to get comparable property.
    /// - Parameters:
    ///   - keyPath: Key path to compare, must be `Comparable`.
    func max<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        return self.max { first, second -> Bool in
            first[keyPath: keyPath] < second[keyPath: keyPath]
        }
    }
}
