//
//  Created by Dmitry Surkov on 07/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct SplashViewModel: Equatable {
    let isLoading: Bool

    init(state: SplashState) {
        isLoading = state.isLoading
    }

    static func == (lhs: SplashViewModel, rhs: SplashViewModel) -> Bool {
        return false
    }
}
