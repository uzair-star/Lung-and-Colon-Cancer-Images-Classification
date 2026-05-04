////
////  MLMultiArray+Helpers.swift
////  lungs
////
//
//import CoreML
//
//extension MLMultiArray {
//    func toDoubleArray() -> [Double] {
//        switch self.dataType {
//        case .double:
//            let ptr = UnsafeMutablePointer<Double>(OpaquePointer(self.dataPointer))
//            return Array(UnsafeBufferPointer(start: ptr, count: self.count))
//
//        case .float32:
//            let ptr = UnsafeMutablePointer<Float32>(OpaquePointer(self.dataPointer))
//            return Array(UnsafeBufferPointer(start: ptr, count: self.count)).map { Double($0) }
//
//        case .float16:
//            return (0..<self.count).map { self[$0].doubleValue }
//
//        default:
//            return (0..<self.count).map { self[$0].doubleValue }
//        }
//    }
//}
//
//  MLMultiArray+Helpers.swift
//  lungs
//

import CoreML

extension MLMultiArray {
    func toDoubleArray() -> [Double] {
        switch self.dataType {
        case .double:
            let ptr = UnsafeMutablePointer<Double>(OpaquePointer(self.dataPointer))
            return Array(UnsafeBufferPointer(start: ptr, count: self.count))

        case .float32:
            let ptr = UnsafeMutablePointer<Float32>(OpaquePointer(self.dataPointer))
            return Array(UnsafeBufferPointer(start: ptr, count: self.count)).map { Double($0) }

        case .float16:
            return (0..<self.count).map { self[$0].doubleValue }

        default:
            return (0..<self.count).map { self[$0].doubleValue }
        }
    }
}
