ROOT_DIR=$PWD
INTEL_DIR="$ROOT_DIR/IntelRDFPMathLib20U2"
OUTPUT_DIR="$ROOT_DIR/Sources/Cbid"

CC="gcc"
CFLAGS="CALL_BY_REF=0 GLOBAL_RND=0 GLOBAL_FLAGS=0"

# ==================
# === Create dir ===
# ==================

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

cd "$ROOT_DIR/Scripts/intel"
cp "header.h" "$OUTPUT_DIR/"
cp "Package.swift" "$OUTPUT_DIR/"
# Skip source control
echo "*" > "$OUTPUT_DIR/.gitignore"
# Things are simpler if we have a full path in 'module.modulemap'.
sed "s|LIBBID_PATH|$OUTPUT_DIR/libbid.a|" "module.modulemap" > "$OUTPUT_DIR/module.modulemap"

# =============
# === Build ===
# =============

cd "$INTEL_DIR/LIBRARY"
make clean
make CC=$CC $CFLAGS UNCHANGED_BINARY_FLAGS=0
cp libbid.a "$OUTPUT_DIR/"

mkdir -p "$OUTPUT_DIR/headers"
cp src/*.h "$OUTPUT_DIR/headers/"

# ============
# === Test ===
# ============

cd "$INTEL_DIR/TESTS"
make clean OS_TYPE=LINUX
make OS_TYPE=LINUX CC=$CC $CFLAGS COPT_ADD=-Wno-format-overflow
./readtest < readtest.in

# ===============
# === Example ===
# ===============

cd "$INTEL_DIR/EXAMPLES"

OUTPUT_EXAMPLE_DIR="$OUTPUT_DIR/example"
mkdir -p "$OUTPUT_EXAMPLE_DIR"

cp decimal.h_000 "$OUTPUT_EXAMPLE_DIR/decimal.h"
cp main.c_000 "$OUTPUT_EXAMPLE_DIR/main.c"

cd "$OUTPUT_EXAMPLE_DIR"
gcc $1 main.c ../libbid.a
./a.out
rm a.out

# ===========
# === End ===
# ===========

cd "$ROOT_DIR"
