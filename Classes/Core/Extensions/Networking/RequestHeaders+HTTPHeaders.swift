//
//  Created by Artem Sokurenko on 22.06.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

extension Collection where Iterator.Element == RequestHeader {

    var httpHeaders: HTTPHeaders {
        return reduce(into: HTTPHeaders()) { headers, element in
            headers[element.key] = element.value
        }
    }
}
