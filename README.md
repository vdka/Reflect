# Reflect

Reflect aims to expose the powerful runtime type info included in your swift binaries in an interface similar to that of Golangs [reflect](https://golang.org/pkg/reflect/).

Currenctly we have support for:

# Type Reflections
- [ ] Struct types
    - [x] Mangled name
    - [x] Fields
        - [x] Count
        - [x] Offsets
        - [x] Names
        - [x] Types
    - [x] isGeneric
- [ ] Tuple types
    - [x] Elements
        - [x] Count
        - [x] Offsets
        - [x] Labels (currently not included in the ABI)
        - [x] Types
- [ ] Enum types
    - [ ] isGeneric
    - [x] isOptional
    - [x] Mangled name
    - [x] Cases
        - [x] Number of cases (with and without payloads)
        - [x] Payload size offset
        - [x] Case names
        - [x] Case types
        - [ ] isIndirect
- [ ] Protocol Composition types (Existentials)
    - [x] Mangled names
    - [x] hasClassConstraint (`protocol Foo: class`)
    - [x] Number of protocols in composition
    - [x] isAnyType
    - [ ] inherited protocol list
    - [ ] objc compatibility information
    - [ ] size
    - [ ] flags
        - [ ] Swift defined
        - [ ] dispatch via witness table or objc_msgSend
- [ ] Generic Parameter Types (and WitnessTables if constrained)
- [ ] Function Types
- [ ] Class types
    - [ ] isGeneric
    - [ ] Fields
        - [ ] Count
        - [ ] Offsets
        - [ ] Names
        - [ ] Types
    - [ ] Destructor
    - [ ] Super Type
    - [ ] Instance Address
    - [ ] Instance Size
    - [ ] Instance aligment mask
    - [ ] VTable



