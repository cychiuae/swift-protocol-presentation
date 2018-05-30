/*:
 # What is protocol? 🧐
 A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.

 The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements.

 Any type that satisfies the requirements of a protocol is said to conform to that protocol.
 */
protocol Stringable {
    func toString() -> String
}

func consoleDotLog(_ stringable: Stringable) -> String {
    return stringable.toString()
}

enum Direction: Stringable {
    case east
    case south
    case west
    case north

    func toString() -> String {
        switch self {
        case .east:
            return "East"
        case .south:
            return "South"
        case .west:
            return "West"
        case .north:
            return "North"
        }
    }
}

let sunRiseDirect = Direction.east
consoleDotLog(sunRiseDirect)

struct FullName: Stringable {
    let firstName: String
    let lastName: String

    func toString() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
}

let myFullName = FullName(firstName: "YinYin", lastName: "BB")
consoleDotLog(myFullName)

class Person {
    let name: String
    init(named name: String) {
        self.name = name
    }
}

extension Person: Stringable {
    func toString() -> String {
        return self.name
    }
}

let me = Person(named: "Yin")
consoleDotLog(me)

//: [Prev](@previous) | [Next](@next)
