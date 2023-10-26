.PHONY: test run clean

test:
	swift test

# Run the Experiments.test_main.
# This is the test case used when writing the library.
run:
	swift test --filter DecimalTests.Experiments/test_main

build:
	swift build --build-tests

clean:
	swift package clean

# =============
# === Intel ===
# =============

.PHONY: intel-linux intel-copy c

# Build Intel lib.
intel-linux:
	@chmod +x Scripts/intel/build-linux.sh
	./Scripts/intel/build-linux.sh

# Create a small directory with most important Intel files.
intel-copy:
	python3 \
		Scripts/copy_interesting_intel_files.py \
		"IntelRDFPMathLib20U2" \
		"intel-lib"

# Run C code from 'Scripts/intel_scratchpad.c'.
c:
	gcc \
		-o Scripts/intel_scratchpad.out \
		Scripts/intel_scratchpad.c \
		Sources/Cbid/libbid.a \
		&& Scripts/intel_scratchpad.out

# =====================
# === Generate code ===
# =====================

.PHONY: gen

gen:
	@rm -rf Sources/Decimal/Generated/*.swift
	python3 \
		Scripts/generate-src \
		"Sources/Decimal/Generated"

	@rm -rf Tests/DecimalTests/Intel - generated/*.swift
	python3 \
		Scripts/generate-tests \
		"IntelRDFPMathLib20U2/TESTS" \
		"Tests/DecimalTests/Intel - generated"

# =================
# == Lint/format ==
# =================

.PHONY: lint

# If you are using any other reporter than 'emoji' then you are doing it wrong...
lint:
	swiftlint lint --reporter emoji
