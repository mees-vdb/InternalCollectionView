## Goal
The goal is to create a custom `UICollectionView` and `UITableView` class (or alternative way of reaching the same goal) that can listen to `didEndDisplaying` and `willDisplay` methods on the `delegate` to implement some logic.

## How to reproduce
Reproduction is pretty simple

- Open the XCode project
- Launch the app for simulator of your choice
- Scroll and see that nothing is printed in the console
- Uncomment `func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)` in `ViewController.swift`
- Launch the app again
- See that `didEndDisplaying` is called from both the internal and external delegate.

What i'm looking for is that `CustomCollectionView.didEnd(item: Int)` is also called when `collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)` on `ViewController.swift` is *NOT* implemented
