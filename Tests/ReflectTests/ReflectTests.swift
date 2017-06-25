import XCTest
@testable import Reflect


protocol Foo: class {}
protocol Bar {}

struct User: Bar {
    var name: String
    var height: Double
}

class ReflectTests: XCTestCase {

    func testStructs() {

        let ty = reflect(type: User.self) as! StructType

        print(ty.mangledName)
        XCTAssertEqual(ty.mangledName, "12ReflectTests4UserV")
        XCTAssertEqual(ty.numberOfFields, 2)
        XCTAssertEqual(ty.fieldNames, ["name", "height"])
        XCTAssertEqual(ty.fieldOffsets, [0, 24])
        XCTAssertFalse(ty.isGeneric)
    }

    func testEnums() {
        var ty: EnumType
        
        ty = reflect(type: Optional<String>.self) as! EnumType
        XCTAssertTrue(ty.isOptionalType)
        XCTAssertEqual(ty.numberOfCases, 2)
        XCTAssertEqual(ty.mangledName, "Sq")
        XCTAssertEqual(ty.numberOfPayloadCases, 1)
        XCTAssertEqual(ty.numberOfNoPayloadCases, 1)
        XCTAssertEqual(ty.payloadSizeOffset, 0)
        XCTAssertEqual(ty.caseNames, ["some", "none"])

        enum Ast {
            case num(Double)
            indirect case exprParen(Ast)
            indirect case prefix(String, Ast)
            indirect case infix(String, lhs: Ast, rhs: Ast)
            case invalid
        }

        ty = reflect(type: Ast.self) as! EnumType
        XCTAssertFalse(ty.isOptionalType)
        XCTAssertEqual(ty.numberOfCases, 5)
        XCTAssertEqual(ty.numberOfPayloadCases, 4)
        XCTAssertEqual(ty.numberOfNoPayloadCases, 1)
        XCTAssertEqual(ty.payloadSizeOffset, 0)
        XCTAssertEqual(ty.caseNames, ["num", "exprParen", "prefix", "infix", "invalid"])
//        XCTAssertFalse(ty.isGeneric)
        XCTAssertFalse(ty.isIndirect(at: 0))
        XCTAssertTrue(ty.isIndirect(at: 1))
        XCTAssertTrue(ty.isIndirect(at: 2))
        XCTAssertTrue(ty.isIndirect(at: 3))
        XCTAssertFalse(ty.isIndirect(at: 4))
    }

    func testTuples() {

        let ty = reflect(type: (String, Double).self) as! TupleType
        XCTAssertEqual(ty.numberOfElements, 2)
        XCTAssertEqual(ty.elementOffsets, [0, 24])
    }

    func testFunctions() {
        var ty: FunctionType

        ty = reflect(type: ((Int) -> Int).self) as! FunctionType

        XCTAssertEqual(ty.numberOfArguments, 1)
        XCTAssertEqual(ty.resultType, reflect(type: Int.self))
        XCTAssertEqual(ty.argumentType(at: 0), reflect(type: Int.self))
        XCTAssertEqual(ty.argumentType(at: 0), reflect(type: Int.self))

        XCTAssertFalse(ty.isParamInout(at: 0))
        XCTAssertFalse(ty.hasInoutArguments)

        ty = reflect(type: ((inout Int, inout Int, Float) -> (Float, Bool)).self) as! FunctionType
        XCTAssertEqual(ty.numberOfArguments, 3)
        XCTAssertEqual(ty.resultType, reflect(type: (Float, Bool).self))
        XCTAssertEqual(ty.argumentType(at: 0), reflect(type: Int.self))
        XCTAssertEqual(ty.argumentType(at: 1), reflect(type: Int.self))
        XCTAssertEqual(ty.argumentType(at: 2), reflect(type: Float.self))
        XCTAssertTrue(ty.isParamInout(at: 0))
        XCTAssertTrue(ty.isParamInout(at: 1))
        XCTAssertFalse(ty.isParamInout(at: 2))
        XCTAssertTrue(ty.hasInoutArguments)
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
    }

    static var allTests: [(String, (ReflectTests) -> () -> Void)] = [
        ("testStructs", testStructs),
        ("testExistentials", testExistentials),
    ]
}
