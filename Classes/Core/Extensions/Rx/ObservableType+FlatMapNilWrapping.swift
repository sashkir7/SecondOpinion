//
//  Created by Dmitry Frishbuter on 02.10.2018
//  Copyright © 2018 98 Training Pty Limited. All rights reserved.
//

import RxSwift

// swiftlint:disable line_length

public extension ObservableType {

    func flatMap<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        return flatMap { [weak obj] value -> Observable<O.Element> in
            try obj.map { evaluated in
                try selector(evaluated, value).asObservable()
            } ?? .empty()
        }
    }

    func flatMapFirst<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        return flatMapFirst { [weak obj] element -> Observable<O.Element> in
            try obj.map { evaluated in
                try selector(evaluated, element).asObservable()
            } ?? .empty()
        }
    }

    func flatMapWithIndex<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element, Int) throws -> O) -> Observable<O.Element> {
        return enumerated().flatMap { [weak obj] (tuple: (index: Int, element: Element)) -> Observable<O.Element> in
            try obj.map { evaluated in
                try selector(evaluated, tuple.element, tuple.index).asObservable()
            } ?? .empty()
        }
    }

    func flatMapLatest<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        return flatMapLatest { [weak obj] element -> Observable<O.Element> in
            try obj.map { evaluated in
                try selector(evaluated, element).asObservable()
            } ?? .empty()
        }
    }
}

// swiftlint:enable line_length

public extension ObservableType where Element == Void {

    func flatMap<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, selector: @escaping (A) throws -> O) -> Observable<O.Element> {
        return flatMap { [weak obj] in
            try obj.map { evaluated in
                try selector(evaluated).asObservable()
            } ?? .empty()
        }
    }

    func flatMapFirst<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, selector: @escaping (A) throws -> O) -> Observable<O.Element> {
        return flatMapFirst { [weak obj] in
            try obj.map { evaluated in
                try selector(evaluated).asObservable()
            } ?? .empty()
        }
    }

    func flatMapWithIndex<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Int) throws -> O) -> Observable<O.Element> {
        return enumerated().flatMap { [weak obj] (tuple: (index: Int, element: Element)) -> Observable<O.Element> in
            try obj.map { evaluated -> Observable<O.Element> in
                try selector(evaluated, tuple.index).asObservable()
            } ?? .empty()
        }
    }

    func flatMapLatest<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, selector: @escaping (A) throws -> O) -> Observable<O.Element> {
        return flatMapLatest { [weak obj] in
            try obj.map { evaluated in
                try selector(evaluated).asObservable()
            } ?? .empty()
        }
    }
}
