import XCTest
@testable import Reflect

struct User {
    var name: String
    var height: Double
}

protocol Foo: class {}
protocol Bar {}

class ReflectTests: XCTestCase {

    func testStructs() {

        let ty = reflect(type: User.self) as! StructType

        XCTAssertEqual(ty.numberOfFields, 2)
        XCTAssertEqual(ty.fieldNames, ["name", "height"])
        XCTAssertEqual(ty.fieldOffsets, [0, 24])
    }

    func testExistentials() {

        var ty: ExistentialType

        ty = reflect(type: Any.self) as! ExistentialType
        XCTAssert(!ty.hasClassConstraint)
        XCTAssert(ty.isAnyType)
        XCTAssert(!ty.isAnyClassType)
        XCTAssertEqual(ty.numberOfProtocolsMakingComposition, 0)

        ty = reflect(type: Foo.self) as! ExistentialType
        XCTAssert(ty.hasClassConstraint)
        XCTAssert(!ty.isAnyType)
        XCTAssert(!ty.isAnyClassType)
        XCTAssertEqual(ty.numberOfProtocolsMakingComposition, 1)

        ty = reflect(type: Bar.self) as! ExistentialType
        XCTAssert(!ty.hasClassConstraint)
        XCTAssert(!ty.isAnyType)
        XCTAssert(!ty.isAnyClassType)
        XCTAssertEqual(ty.numberOfProtocolsMakingComposition, 1)

        ty = reflect(type: (Foo & Bar).self) as! ExistentialType
        XCTAssert(ty.hasClassConstraint)
        XCTAssert(!ty.isAnyType)
        XCTAssert(!ty.isAnyClassType)
        XCTAssertEqual(ty.numberOfProtocolsMakingComposition, 2)

        print(ty.numberOfWitnessTables)
        print(ty.mangledName)
        print(ty.hasClassConstraint)
    }

    static var allTests: [(String, (ReflectTests) -> () -> Void)] = [
        ("testStructs", testStructs),
        ("testExistentials", testExistentials),
    ]
}
