//
//  Created by Dmitry Frishbuter on 02.10.2018
//  Copyright © 2018 98 Training Pty Limited. All rights reserved.
//

import RxSwift

extension ObservableType {

    var asAny: Observable<AnyObject> {
        return map { $0 as AnyObject }
    }

    var asOptional: Observable<Element?> {
        return map { $0 as Element? }
    }

    var empty: Observable<Void> {
        return self.flatMap { _ -> Observable<Void> in
            return .empty()
        }
    }

    var just: Observable<Void> {
        return self.flatMap { _ -> Observable<Void> in
            return .just(())
        }
    }
}

extension ObservableType {

    func map<T>(by keyPath: KeyPath<Element, T>) -> Observable<T> {
        return map { $0[keyPath: keyPath] }
    }

    func map<T, R>(by keyPath: KeyPath<Element, T>, transform: @escaping (T) -> R) -> Observable<R> {
        return map { transform($0[keyPath: keyPath]) }
    }
}

extension ObservableType {

    func filter<T: Equatable>(by value: T, at keyPath: KeyPath<Element, T>) -> Observable<Element> {
        return filter { element -> Bool in
            element[keyPath: keyPath] == value
        }
    }
}

extension ObservableType {

    func onSubscribe(_ onSubscribe: @escaping () -> Void) -> Observable<Element> {
        return `do`(onSubscribe: onSubscribe)
    }

    func onNext(_ onNext: @escaping (Element) -> Void) -> Observable<Element> {
        return `do`(onNext: onNext)
    }

    func onError(_ onError: @escaping (Error) -> Void) -> Observable<Element> {
        return `do`(onError: onError)
    }

    func onCompleted(_ onCompleted: @escaping () -> Void) -> Observable<Element> {
        return `do`(onCompleted: onCompleted)
    }

    func onDispose(_ onDispose: @escaping () -> Void) -> Observable<Element> {
        return `do`(onDispose: onDispose)
    }

    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }

    func subscribeAndDisposed(by bag: DisposeBag) {
        subscribe().disposed(by: bag)
    }
}

extension ObservableType where Element: OptionalType {

    /// Converts an optional to an observable sequence.
    ///
    /// - Returns: An observable sequence containing the wrapped value or not from source optional.
    func unwrapped() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            return Observable.from(optional: element.asOptional)
        }
    }

    /// Converts an optional to an observable sequence.
    ///
    /// - Returns: An observable sequence containing the wrapped value or send out
    ///            the single `Completed` message if wrapped value is nil.
    func unwrappedOrEmpty() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            switch element.asOptional {
            case .some(let wrapped):
                return Observable.just(wrapped)
            case .none:
                return Observable.empty()
            }
        }
    }
}

extension ObservableType where Element == Bool {

    /// Toggles an observable of Bool type to return an opposite value.
    ///
    /// - Returns: The opposite value of the currently sent value.
    func toggled() -> Observable<Element> {
        return map { !$0 }
    }
}

extension ObservableType where Element == [Bool] {

    func allSatisfy(_ value: Bool) -> Observable<Bool> {
        map { $0.allSatisfy { $0 == value } }
    }
}

extension ObservableType where Element == Void {

    func map<T>(to value: T) -> Observable<T> {
        map { value }
    }
}

extension ObservableType where Element: Collection {

    func allSatisfy(_ predicate: @escaping (Element.Element) -> Bool) -> Observable<Bool> {
        map { $0.allSatisfy(predicate) }
    }
}
