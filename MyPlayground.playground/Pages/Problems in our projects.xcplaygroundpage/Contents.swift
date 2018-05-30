import UIKit
import PlaygroundSupport
/*:
 An common problem in our projects

 Redux store can be globally accessed

 [ET]
 ````
 class Store {
     static var appStore: ReduxStore {
        if let store = Store.myCustomStore {
            return store
        }
        let s = configureStore()
        Store.myCustomStore = s
        return s
     }
 }
 ````

 [WP]
 ````
 extension UIViewController {
    var reduxStore: ReduxStore {
        return self.appDelegate.reduxStore
    }
 }
 ````

 - Problems
     - Hard to test
 - Some idea
     - We should inject redux store to view controller or better only inject observable into view controller
     - How? Use a VC factory
 */

// step 2
protocol ViewControllerAFactory {
    func makeViewControllerA() -> ViewControllerA
}

class LandingViewController: UIViewController {
    // step 3
    private let viewControllerAFactory: ViewControllerAFactory

    lazy private var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 500))
        button.setTitle("Go to next page", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(gotoNextPage), for: .touchUpInside)
        return button
    }()

    // step 4
    init(viewControllerAFactory: ViewControllerAFactory) {
        self.viewControllerAFactory = viewControllerAFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        self.view.addSubview(self.button)
    }

    @objc func gotoNextPage() {
        // Step 1
        let vc = self.viewControllerAFactory.makeViewControllerA()
        self.present(vc, animated: true)
    }
}

struct Ourbservable<T> {
    let data: T
}

protocol Console {
    func log(_ message: String)
}

// step 1
class ViewControllerA: UIViewController {
    let countFromStore: Ourbservable<Int>
    let console: Console

    lazy private var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 500))
        button.setTitle("Log Count", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(logCount), for: .touchUpInside)
        return button
    }()

    init(countFromStore: Ourbservable<Int>, console: Console) {
        self.countFromStore = countFromStore
        self.console = console
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        self.view.addSubview(self.button)
    }

    @objc func logCount() {
        self.console.log("Count is \(self.countFromStore.data)")
    }
}

// Our concret class
class AppContainer: ViewControllerAFactory, Console {
    func log(_ message: String) {
        print(message)
    }

    func createOurbservableInt() -> Ourbservable<Int> {
        return Ourbservable<Int>(data: 10)
    }

    func makeViewControllerA() -> ViewControllerA {
        let countFromStore = self.createOurbservableInt()
        let viewControllerA = ViewControllerA(countFromStore: countFromStore, console: self)
        return viewControllerA
    }
}

let appContainer = AppContainer()
let landingVC = LandingViewController(viewControllerAFactory: appContainer)

PlaygroundPage.current.liveView = landingVC

/*:
 An other problem

 Make extension globally visually

 ### Is this really necessary?
 [ATM]
 ````
 extension UIViewController {
     func startSomeFlow(
         data0: Data0,
         data1: Data1,
         delegate: Delegate,
         viewController: UIViewController
     ) {
        // blablabla
     }
 }
 ````

 ### Better sol'n
 ````
 protocol CanStartSomeFlow {
     func startSomeFlow(
         data0: Data0,
         data1: Data1,
         delegate: Delegate,
         viewController: UIViewController
     )
 }

 extension CanStartSomeFlow where Self: UIViewController {
     func startSomeFlow(
         data0: Data0,
         data1: Data1,
         delegate: Delegate,
         viewController: UIViewController
     ) {
        // blablabla
     }
 }

 class SomeViewController: UIViewController, CanStartSomeFlow {
     func didPressSomeButton() {
        self.startSomeFlow(......)
     }
 }
 ````

 This make implementation of VC more clear and make sure developer knows what they are doing

 [Prev](@previous) | [Next](@next)
 */
