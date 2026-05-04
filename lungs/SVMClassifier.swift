//
//  SVMClassifier.swift
//  lungs
//

import Foundation

final class SVMClassifier {

    private var supportVectors: [[Double]] = []
    private var dualCoef: [[Double]] = []
    private var intercept: [Double] = []
    private var classLabels: [String] = []
    private var nSupport: [Int] = []
    private var gamma: Double = 0.001

    private var probA: [Double] = []
    private var probB: [Double] = []

    init() {
        loadModelFiles()
    }

    // MARK: - JSON

    private func loadJSON<T: Decodable>(_ filename: String, as type: T.Type) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            let files = (try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath)) ?? []
            print("❌ Missing file: \(filename).json")
            print("📦 Files in bundle:", files)
            fatalError("Missing file: \(filename).json")
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(filename).json: \(error)")
        }
    }

    // MARK: - Load Files

    private func loadModelFiles() {
        supportVectors = loadJSON("support_vectors", as: [[Double]].self)
        dualCoef = loadJSON("dual_coef", as: [[Double]].self)
        intercept = loadJSON("intercept", as: [Double].self)
        nSupport = loadJSON("n_support", as: [Int].self)
        classLabels = loadJSON("class_labels", as: [String].self)
        probA = loadJSON("probA", as: [Double].self)
        probB = loadJSON("probB", as: [Double].self)

        struct Config: Decodable {
            let gamma: Double
        }

        let config = loadJSON("svm_config", as: Config.self)
        gamma = config.gamma

        validateModelFiles()
    }

    // MARK: - Validation

    private func validateModelFiles() {
        guard !supportVectors.isEmpty else { fatalError("support_vectors.json is empty") }
        guard !dualCoef.isEmpty else { fatalError("dual_coef.json is empty") }
        guard !intercept.isEmpty else { fatalError("intercept.json is empty") }
        guard !classLabels.isEmpty else { fatalError("class_labels.json is empty") }
        guard !nSupport.isEmpty else { fatalError("n_support.json is empty") }
        guard !probA.isEmpty else { fatalError("probA.json is empty") }
        guard !probB.isEmpty else { fatalError("probB.json is empty") }

        let totalNSupport = nSupport.reduce(0, +)
        guard totalNSupport == supportVectors.count else {
            fatalError("n_support sum (\(totalNSupport)) does not match support vector count (\(supportVectors.count))")
        }

        guard nSupport.count == classLabels.count else {
            fatalError("n_support count does not match number of classes")
        }

        let expectedRows = classLabels.count - 1
        guard dualCoef.count == expectedRows else {
            fatalError("dual_coef row count \(dualCoef.count) does not match expected \(expectedRows)")
        }

        let expectedPairs = classLabels.count * (classLabels.count - 1) / 2
        guard intercept.count == expectedPairs else {
            fatalError("intercept count \(intercept.count) does not match expected \(expectedPairs)")
        }
        guard probA.count == expectedPairs else {
            fatalError("probA count \(probA.count) does not match expected \(expectedPairs)")
        }
        guard probB.count == expectedPairs else {
            fatalError("probB count \(probB.count) does not match expected \(expectedPairs)")
        }

        let featureCount = supportVectors.first?.count ?? 0
        guard featureCount > 0 else {
            fatalError("Invalid support vector feature size")
        }

        for (idx, sv) in supportVectors.enumerated() {
            if sv.count != featureCount {
                fatalError("Support vector \(idx) has inconsistent feature size")
            }
        }

        for (row, coeffs) in dualCoef.enumerated() {
            if coeffs.count != supportVectors.count {
                fatalError("dual_coef row \(row) length \(coeffs.count) does not match support vector count \(supportVectors.count)")
            }
        }

        print("✅ SVM + probability loaded")
        print("Classes:", classLabels)
        print("nSupport:", nSupport)
        print("Support vectors:", supportVectors.count)
        print("dualCoef shape: \(dualCoef.count) x \(dualCoef.first?.count ?? 0)")
        print("Intercepts:", intercept.count)
        print("probA count:", probA.count)
        print("probB count:", probB.count)
        print("Gamma:", gamma)
    }

    // MARK: - Kernel

    private func rbfKernel(_ x: [Double], _ y: [Double]) -> Double {
        guard x.count == y.count else {
            fatalError("Kernel feature mismatch: \(x.count) vs \(y.count)")
        }

        var sum = 0.0
        for i in 0..<x.count {
            let d = x[i] - y[i]
            sum += d * d
        }
        return exp(-gamma * sum)
    }

    // MARK: - Debug

    func debugScores(featureVector: [Double]) {
        let nClasses = classLabels.count
        var votes = Array(repeating: 0, count: nClasses)

        var kernels = Array(repeating: 0.0, count: supportVectors.count)
        for s in 0..<supportVectors.count {
            kernels[s] = rbfKernel(featureVector, supportVectors[s])
        }

        var starts = Array(repeating: 0, count: nClasses)
        for i in 1..<nClasses {
            starts[i] = starts[i - 1] + nSupport[i - 1]
        }

        var pairIndex = 0

        for i in 0..<(nClasses - 1) {
            for j in (i + 1)..<nClasses {
                var sum = 0.0

                let si = starts[i]
                let ci = nSupport[i]
                if ci > 0 {
                    for k in 0..<ci {
                        let svIndex = si + k
                        sum += dualCoef[j - 1][svIndex] * kernels[svIndex]
                    }
                }

                let sj = starts[j]
                let cj = nSupport[j]
                if cj > 0 {
                    for k in 0..<cj {
                        let svIndex = sj + k
                        sum += dualCoef[i][svIndex] * kernels[svIndex]
                    }
                }

                sum += intercept[pairIndex]

                print("Pair (\(i), \(j)) score:", sum)

                if sum > 0 {
                    votes[i] += 1
                } else {
                    votes[j] += 1
                }

                pairIndex += 1
            }
        }

        print("Votes:", votes)
    }

    // MARK: - Predict

    func predictWithConfidence(featureVector: [Double]) -> (label: String, confidence: Double) {
        let nClasses = classLabels.count

        var kernels = Array(repeating: 0.0, count: supportVectors.count)
        for s in 0..<supportVectors.count {
            kernels[s] = rbfKernel(featureVector, supportVectors[s])
        }

        var starts = Array(repeating: 0, count: nClasses)
        for i in 1..<nClasses {
            starts[i] = starts[i - 1] + nSupport[i - 1]
        }

        var votes = Array(repeating: 0, count: nClasses)
        var pairIndex = 0

        var pairProb = Array(
            repeating: Array(repeating: 0.0, count: nClasses),
            count: nClasses
        )

        for i in 0..<(nClasses - 1) {
            for j in (i + 1)..<nClasses {
                var sum = 0.0

                let si = starts[i]
                let ci = nSupport[i]
                if ci > 0 {
                    for k in 0..<ci {
                        let idx = si + k
                        sum += dualCoef[j - 1][idx] * kernels[idx]
                    }
                }

                let sj = starts[j]
                let cj = nSupport[j]
                if cj > 0 {
                    for k in 0..<cj {
                        let idx = sj + k
                        sum += dualCoef[i][idx] * kernels[idx]
                    }
                }

                sum += intercept[pairIndex]

                // Keep original one-vs-one vote logic for class prediction
                if sum > 0 {
                    votes[i] += 1
                } else {
                    votes[j] += 1
                }

                // Calibrated probability for confidence only
                let p = 1.0 / (1.0 + exp(probA[pairIndex] * sum + probB[pairIndex]))
                pairProb[i][j] = p
                pairProb[j][i] = 1.0 - p

                pairIndex += 1
            }
        }

        let predictedClass = votes.enumerated().max(by: { $0.element < $1.element })?.offset ?? 0

        var confidenceSum = 0.0
        for j in 0..<nClasses {
            if j != predictedClass {
                confidenceSum += pairProb[predictedClass][j]
            }
        }

        let confidence = confidenceSum / Double(nClasses - 1)

        print("Votes:", votes)
        print("Predicted class index:", predictedClass, "label:", classLabels[predictedClass])
        print("Confidence:", confidence)

        return (classLabels[predictedClass], confidence)
    }
}
