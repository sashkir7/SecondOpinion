//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol SettingsViewInput: class {
    @discardableResult
    func update(with viewModel: SettingsViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol SettingsViewOutput: class {
    func viewDidLoad()
}

final class SettingsViewController: UIViewController {

    private(set) var viewModel: SettingsViewModel
    let output: SettingsViewOutput

    var needsUpdate: Bool = true

    // MARK: -  Lifecycle

    init(viewModel: SettingsViewModel, output: SettingsViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }

    // MARK: -  Actions
}

// MARK: -  SettingsViewInput

extension SettingsViewController: SettingsViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: SettingsViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        // update view

        needsUpdate = false

        return true
    }
}
