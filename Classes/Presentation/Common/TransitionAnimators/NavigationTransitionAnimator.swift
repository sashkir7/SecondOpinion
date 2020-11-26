//
//  Created by Alx Krw on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol NavigationTransitionAnimator: UIViewControllerAnimatedTransitioning {
    var animationDuration: TimeInterval { get set }
    var operation: UINavigationController.Operation { get }
}
