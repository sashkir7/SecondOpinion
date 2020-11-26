//
//  Created by Dmitry Frishbuter on 30/08/2019
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

protocol OptionalType {
    associatedtype Wrapped
    var asOptional: Wrapped? { get }
}

extension Optional: OptionalType {

    var asOptional: Wrapped? {
        return self
    }
}
