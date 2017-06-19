import XCTest
@testable import Reflect

struct User {
    var name: String
    var height: Double
}

protocol Foo {}
protocol Bar {}

class ReflectTests: XCTestCase {

    func testStructs() {

        let ty = StructType(type: User.self)

        XCTAssertEqual(ty.numberOfFields, 2)
        XCTAssertEqual(ty.fieldNames, ["name", "height"])
        XCTAssertEqual(ty.fieldOffsets, [0, 24])
    }

    func testExistentials() {

        let ty = ExistentialType(type: (Foo & Bar).self)

        print(ty.numberOfWitnessTables)
        print(ty.mangledNames)
        print(ty.sizes)
    }

    static var allTests: [(String, (ReflectTests) -> () -> Void)] = [
        ("testStructs", testStructs),
        ("testExistentials", testExistentials),
    ]
}
