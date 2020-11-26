//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import RxSwift

protocol HasTagsService {
    var tagsService: TagsServiceProtocol { get }
}

protocol TagsServiceProtocol: class {
    func fetchTagsObservable() -> Observable<[Tag]>
}
