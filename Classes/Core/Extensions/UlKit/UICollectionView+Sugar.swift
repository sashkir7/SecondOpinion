//
//  Created by Dmitry Frishbuter on 08.01.2019
//  Copyright © 2019 Ronas IT. All rights reserved.
//

import UIKit.UICollectionView

extension UICollectionView {

    func registerCellClass(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable cell for indexPath: \((indexPath.section, indexPath.item))")
        }
        return cell
    }

    func scrollCellToVisibleRect(at indexPath: IndexPath, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        func scroll(to indexPath: IndexPath,
                    at scrollPosition: UICollectionView.ScrollPosition,
                    animated: Bool,
                    completion: ((Bool) -> Void)?) {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
            }, completion: completion)
        }

        if let minIndexPath = indexPathsForVisibleItems.min(), indexPath <= minIndexPath {
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                switch flowLayout.scrollDirection {
                case .vertical:
                    scroll(to: indexPath, at: .top, animated: animated, completion: completion)
                case .horizontal:
                    scroll(to: indexPath, at: .left, animated: animated, completion: completion)
                }
            } else {
                scroll(to: indexPath, at: .top, animated: animated, completion: completion)
            }
        } else if let maxIndexPath = indexPathsForVisibleItems.max(), indexPath >= maxIndexPath {
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                switch flowLayout.scrollDirection {
                case .vertical:
                    scroll(to: indexPath, at: .bottom, animated: animated, completion: completion)
                case .horizontal:
                    scroll(to: indexPath, at: .right, animated: animated, completion: completion)
                }
            } else {
                scroll(to: indexPath, at: .bottom, animated: animated, completion: completion)
            }
        }
    }

    func containsAll(_ indexPaths: [IndexPath]) -> Bool {
        return !indexPaths.contains { !contains($0) }
    }

    func contains(_ indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.item < numberOfItems(inSection: indexPath.section)
    }

    func selectCell(_ cell: UICollectionViewCell, animated: Bool, scrollPosition: UICollectionView.ScrollPosition = []) {
        let indexPath = self.indexPath(for: cell)
        selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        cell.isSelected = true
    }

    func deselectCell(_ cell: UICollectionViewCell, animated: Bool) {
        guard let indexPath = self.indexPath(for: cell) else {
            return
        }
        deselectItem(at: indexPath, animated: animated)
        cell.isSelected = false
    }

    func isSectionVisible(with indexPath: IndexPath) -> Bool {
        guard numberOfSections > indexPath.section else {
            return false
        }
        for index in 0...(numberOfItems(inSection: indexPath.section) - 1) {
            let indexPath = IndexPath(item: index, section: indexPath.section)
            let contains = indexPathsForVisibleItems.contains(indexPath)
            if contains {
                return contains
            }
        }
        return false
    }
}
