SWIFT_BUILD_FLAGS_RELEASE=--configuration release -Xswiftc -gnone -Xswiftc -O

.PHONY: all
all: build

# ==================
# == Usual things ==
# ==================

.PHONY: build build-r test test-hossam-fahmy x run clean

build:
	swift build --build-tests

build-r:
	swift build $(SWIFT_BUILD_FLAGS_RELEASE)

test:
	swift test --parallel

# Run tests from: http://eece.cu.edu.eg/~hfahmy/arith_debug
test-hossam-fahmy:
	swift build --product test-hossam-fahmy $(SWIFT_BUILD_FLAGS_RELEASE)
	@echo "--------------------------------------------------------------------------------"
	@.build/release/test-hossam-fahmy \
		"Test-suites/Hossam-Fahmy-tests" \
		"Test-suites/Oh-my-decimal-tests"

# Run only the tests related to functionality that you are currently working on.
# Most of the time the workflow is: 'make x', 'make x', 'make x', 'make test'.
x:
	swift test --filter IntelAddSubNegateTests

# Run the Experiments.test_main.
# This is the 'playground' used for ad-hoc tests when writing the library.
run:
	swift test --filter DecimalTests.Experiments/test_main

clean:
	swift package clean

# ============
# === Code ===
# ============

.PHONY: gen intel-copy

# Generate code.
gen:
	python3 \
		Scripts/generate-src \
		"Sources/Decimal/Generated"

	python3 \
		Scripts/generate-tests \
		"Test-suites/IntelRDFPMathLib20U2/TESTS" \
		"Test-suites/speleotrove-dectest" \
		"Tests/DecimalTests"

# Create a directory with links to the most important Intel files.
intel-copy:
	python3 \
		Scripts/copy_interesting_intel_files.py \
		"Test-suites/IntelRDFPMathLib20U2" \
		"intel-lib"

# =================
# == Lint/format ==
# =================

.PHONY: lint

lint:
	swiftlint lint
