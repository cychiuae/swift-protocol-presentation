import UIKit
/*:
 # Why should we use protocol? 🤔

 ## 1. Reusable
 */

protocol Rectangular {
    var height: CGFloat { get }
    var width: CGFloat { get }
}

extension Rectangular {
    func computeArea() -> CGFloat {
        return self.height * self.width
    }
}

extension UIView: Rectangular {
    var height: CGFloat {
        return self.frame.height
    }
    var width: CGFloat {
        return self.frame.width
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
print(view.computeArea())

extension UIImage: Rectangular {
    var height: CGFloat {
        return self.size.height
    }
    var width: CGFloat {
        return self.size.width
    }
}

let image = UIImage(named: "meow")
print("\(image?.computeArea() ?? -1)")

/*:
 ## 2. Composable
 - Anything can conform multiple protocols (Note: Swift doesn't support multiple inheritance)
 */

protocol ReactDeveloper: class {
    func writeReactCode() -> String
}

protocol IOSDeveloper: class {
    func writeObjCCode() -> String
    func writeSwiftcode() -> String
}

protocol AndroidDeveloper: class {
    func writeJavaCode() -> String
    func writeKotlinCode() -> String
}

class Developer {}

class SomeCompanyDeveloper: Developer {}

extension SomeCompanyDeveloper: IOSDeveloper {
    func writeObjCCode() -> String {
        return "NSString *hello = @\"Hello\";";
    }

    func writeSwiftcode() -> String {
        return "let hello = \"Hello\""
    }
}

class OurskyDeveloper: Developer {}

extension OurskyDeveloper: ReactDeveloper {
    func writeReactCode() -> String {
        return "<Hello />;"
    }
}

extension OurskyDeveloper: IOSDeveloper {
    func writeObjCCode() -> String {
        return "NSString *hello = @\"Hello\";";
    }

    func writeSwiftcode() -> String {
        return "let hello = \"Hello\""
    }
}

extension OurskyDeveloper: AndroidDeveloper {
    func writeJavaCode() -> String {
        return "String hello = \"Hello\";"
    }

    func writeKotlinCode() -> String {
        return "val hello = \"Hello\""
    }
}

/*:
 ## 3. Ensure we make extension to correct `things`
 */
typealias ReactNativeDeveloper = ReactDeveloper & IOSDeveloper & AndroidDeveloper

func doReactNativeProject(with developer: ReactNativeDeveloper) -> String {
    return developer.writeJavaCode() + developer.writeObjCCode() + developer.writeReactCode()
}

let yinBB = OurskyDeveloper()
let someOne = SomeCompanyDeveloper()

doReactNativeProject(with: yinBB)
//doReactNativeProject(with someOne)

/*:
 ## 4. Abstracting actual object
 Don't care what they are as long as they can do the work
 */
extension UIView: ReactDeveloper {
    func writeReactCode() -> String {
        return "<View />;"
    }
}

func doReactProject(with reactDeveloper: ReactDeveloper) -> String {
    return reactDeveloper.writeReactCode()
}

doReactProject(with: yinBB)

let uiView = UIView()
doReactProject(with: uiView)

/*:
 ## 5. Make thing testable
 */
class APIClient {
    func fetchDeveloperByID(_ id: String, completion: ((Developer?) -> Void)) {
        // network call blablabla
        completion(nil)
    }

    func createUser(_ username: String, password: String) {
        // lalala
    }

    func login(_ username: String, password: String) {
        // lalala
    }
}

class SomeActionCreater {
    static func fetchDeveloperByID(_ id: String, apiClient: APIClient) {
        apiClient.fetchDeveloperByID(id) { developer in
            // blablabla
        }
    }
}
/*:
 ### How can we test SomeActionCreater?
 */

protocol APIClientProtocol {
    func fetchDeveloperByID(_ id: String, completion: ((Developer?) -> Void))
    func createUser(_ username: String, password: String)
    func login(_ username: String, password: String)
}

/*:
 ### Actually, we can do better
 */

protocol DeveloperAPI {
    func fetchDeveloperByID(_ id: String, completion: ((Developer?) -> Void))
}

protocol UserAPI {
    func createUser(_ username: String, password: String)
    func login(_ username: String, password: String)
}

class TestableActionCreater {
    static func fetchDeveloperByID(_ id: String, apiClient: DeveloperAPI) {
        apiClient.fetchDeveloperByID(id) { developer in
            // blablabla
        }
    }
}

class MockDeveloperAPI: DeveloperAPI {
    func fetchDeveloperByID(_ id: String, completion: ((Developer?) -> Void)) {
        completion(yinBB)
    }
}

let mockDeveloperAPI = MockDeveloperAPI()
TestableActionCreater.fetchDeveloperByID("id", apiClient: mockDeveloperAPI)

typealias GoodAPIClientType = DeveloperAPI & UserAPI

class OtherTestableActionCreater {
    static func callAllAPI(apiClient: GoodAPIClientType) {
        apiClient.fetchDeveloperByID("id") { developer in
            // blablabla
        }
        apiClient.createUser("username", password: "pw")
        apiClient.login("username", password: "pw")
    }
}

//: [Prev](@previous) | [Next](@next)
