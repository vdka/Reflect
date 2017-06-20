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

        print(ty.mangledName)
        XCTAssertEqual(ty.mangledName, "12ReflectTests4UserV")
        XCTAssertEqual(ty.numberOfFields, 2)
        XCTAssertEqual(ty.fieldNames, ["name", "height"])
        XCTAssertEqual(ty.fieldOffsets, [0, 24])
        XCTAssert(!ty.isGeneric)
    }

    func testTuples() {

        let ty = reflect(type: (String, Double).self) as! TupleType
        XCTAssertEqual(ty.numberOfElements, 2)
        XCTAssertEqual(ty.elementOffsets, [0, 24])
    }

    func testEnums() {
        var ty: EnumType

        ty = reflect(type: Optional<String>.self) as! EnumType
        XCTAssert(ty.isOptionalType)
        XCTAssertEqual(ty.numberOfCases, 2)
        XCTAssertEqual(ty.mangledName, "Sq")
        XCTAssertEqual(ty.numberOfPayloadCases, 1)
        XCTAssertEqual(ty.numberOfNoPayloadCases, 1)
        XCTAssertEqual(ty.payloadSizeOffset, 0)
        XCTAssertEqual(ty.caseNames, ["some", "none"])
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
        print(ty.hasClassConstraint)
    }

    static var allTests: [(String, (ReflectTests) -> () -> Void)] = [
        ("testStructs", testStructs),
        ("testExistentials", testExistentials),
    ]
}
