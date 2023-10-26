Oh-my-decimal is a weird Frankenstein's monster that combines:
- decimal from IEEE 754 2008
- `Swift.Double`

If `Swift.Double` overrides the standard then `Swift.Double` behavior is implemented with the following exceptions:

- sign of `sNaN` follows the same rules as sign of `qNaN` - this is not the case for `Swift.Double`. Note that while the creation of `sNaN` (`copy`, `copySign`, `scaleB` etc.) will give `sNaN`, most of the arithmetic operations will still return `qNaN` with `invalidOperation` flag raised.

- value returned by the `significand` property is always positive. In Swift `(-Double.nan).significand` will return `-nan`. This is needed to make the `scaleB` axiom work: `let y = F(sign: x.sign, exponent: x.exponent, significand: x.significand)` then `x` and `y` [should be equal](https://developer.apple.com/documentation/swift/floatingpoint/init(sign:exponent:significand:)). Obviously `NaNs` are never equal (I'm not sure why documentation is written in this way), but we will have the same sign, signaling bit and payload. Note that:
  - `oh-my-decimal` does not implement `FloatingPoint` protocol from which this requirement comes from.
  - both `oh-my-decimal` and `Swift.Double` will return `sNaN` if the `significand` argument of `scaleB` is `sNaN`. Standard would return `qNaN` and raise `invalidOperation`.

- `minimum/maximum`
  - `oh-my-decimal` implements the standard 2008: if one of the operands is `sNaN` then the result is a `NaN` with `invalidOperation` raised.
  - standard 2019 introduces new operations as there was [a whole debate](https://grouper.ieee.org/groups/msc/ANSI_IEEE-Std-754-2019/background/minNum_maxNum_Removal_Demotion_v3.pdf) about the corner cases of 2008.
  - [Swift documentation](https://developer.apple.com/documentation/swift/double/minimum(_:_:)) says: "If both x and y are NaN, or either x or y is a signaling NaN, the result is NaN", with a link to the standard 2008. In practice for `sNaN` it returns the non-NaN operand.

- no `.awayFromZero` rounding - this is trivial to implement, but only [speleotrove](https://speleotrove.com/decimal/) contains tests for it (they call it `round-up`). Since rounding is present in most of the operations, a single test suite is not enough to be fully sure that everything works correctly. In `oh-my-decimal` most important things are covered by: [Intel](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html), [Speleotrove](https://speleotrove.com/decimal/), [Hossam A. H. Fahmy](http://eece.cu.edu.eg/~hfahmy/arith_debug/) and [oh-my-decimal-tests](https://github.com/LiarPrincess/Oh-my-decimal-tests) tests. Also, IEEE 754 does not require this rounding mode, so 🤷.

- missing protocols:
  - `FloatingPoint` - we have our own `DecimalFloatingPoint`.
  - `ExpressibleByFloatLiteral` - Swift converts to `Float80`/`Double` and then converts to a number. This conversion may not be exact, so it is basically a random number generator.
  - `Strideable` - really quickly it would break the Sterbenz lemma: `y/2 < x < 2y`. What is the distance between `greatestFiniteMagnitude` and `leastNormalMagnitude`?
  - `Random` - apart from a few specific input ranges it would not do what user wants:
    - simple random between 0 and 10 would be skewed towards smaller numbers
      because more of them are representable (tons of possible negative exponents).
    - if we generated truly random (infinitely precise) value and rounded then
      bigger numbers would be more common (they have bigger ulp).

Examples (Intel, this library was not tested on Apple silicon):

```Swift
// Container for IEEE 754 flags: inexact, invalidOperation etc.
var status = DecimalStatus()

// Standard: nan + invalidOperation
// Swift: nan
print(Decimal64.signalingNaN.nextUp(status: &status)) // nan + invalidOperation 🟢
print(Double.signalingNaN.nextUp) // nan 🟢
status.clearAll()

// Standard: nan + invalidOperation
// Swift: nan
print(Decimal64.signalingNaN + Decimal64.signalingNaN) // nan 🟢
print(Decimal64.signalingNaN.adding(Decimal64.signalingNaN, rounding: .towardZero, status: &status)) // nan + invalidOperation 🟢
print(Double.signalingNaN + Double.signalingNaN) // nan 🟢
status.clearAll()

// Standard: nan + invalidOperation
// Swift: https://www.youtube.com/watch?v=nptj1uWFy5s
print((-Decimal64.signalingNaN).magnitude) // snan 🔴
print((-Double.signalingNaN).magnitude) // snan 🔴

// 'scaleB' axiom
let d1 = -Decimal64.nan
print(Decimal64(sign: d1.sign, exponent: 0, significand: d1.significand)) // -nan 🟢
let d2 = -Double.nan
print(Double(sign: d2.sign, exponent: 0, significand: d2.significand)) // nan 🔴

// Standard: canonicalized number
// Swift: number
print(Decimal64.minimum(Decimal64.nan, 1, status: &status)) // 1E+0 🟢
print(Double.minimum(Double.nan, 1)) // 1.0 🟢

// Standard: nan + invalidOperation
// Swift: number
print(Decimal64.minimum(1, Decimal64.signalingNaN, status: &status)) // nan + invalidOperation 🟢
print(Double.minimum(1, Double.signalingNaN)) // 1.0 🔴
```

## Branches
- `mr-darcy` (this branch) - Swift implementation.
- `mr-bingley` - wrapper for [Intel library](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html). It has `pow`, but `DecimalStatus` is not publicly available.

## Code

**`Sources/Decimal`**

- `Generated` - code generated by Python scripts.
  - `Decimal32`
  - `Decimal64`
  - `Decimal128`
  - `DecimalFloatingPoint` - dem protocol.

- `DecimalMixin` - internal protocol on which every operation is defined. All of the methods from `DecimalXX` types will eventually call a method from `DecimalMixin`. Methods start with '`_`' to avoid name clashes with the `public` methods exported from `DecimalXX` types.

- `DecimalFloatingPointRoundingRule` - similar to `FloatingPointRoundingRule` but without `awayFromZero` - not required by IEEE 754, not enough test cases to guarantee correctness.

- `DecimalStatus` - holds IEEE 754 flags: `isInvalidOperation`, `isDivisionByZero`, `isOverflow`, `isUnderflow`, and `isInexact`. Lightweight, you can create as many statuses as you want, they are completely independent. Usually the last argument:

  ```Swift
  public func adding(
    _ other: Self,
    rounding: DecimalFloatingPointRoundingRule,
    status: inout DecimalStatus
  ) -> Self { … }
  ```

**`Sources/test-hossam-fahmy`** - app to run `Hossam-Fahmy-tests` and `Oh-my-decimal-tests`. Use `make test-hossam-fahmy` to run in RELEASE mode. It finishes in ~10min on Intel Pentium G4560. Probably faster if you have better CPU, this thing eats CPU cores like candies.

**`Tests/DecimalTests`**
- `Generated` - unit tests generated by Python scripts.
- `Intel - generated` - unit tests generated from Intel test suite (`Test-suites/IntelRDFPMathLib20U2`).
- `Speleotrove - generated` - unit tests generated from [Speleotrove](https://speleotrove.com/decimal/) test suite (`Test-suites/speleotrove-dectest`).

**`Test-suites`**

- `IntelRDFPMathLib20U2` - put [Intel decimal](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html) here. Or not. This is only used for generating unit tests. Use `make gen` to re-generate and `make test` to run.

- `speleotrove-dectest` - put [Speleotrove](https://speleotrove.com/decimal/) test suite here.  Or not. This is only used for generating unit tests. Use `make gen` to re-generate and `make test` to run.

- `Hossam-Fahmy-tests` - put [Hossam A. H. Fahmy test suite](http://eece.cu.edu.eg/~hfahmy/arith_debug/) here. Use `make test-hossam-fahmy` to run.

- `Oh-my-decimal-tests` - put [oh-my-decimal-test-suite](https://github.com/LiarPrincess/Oh-my-decimal-tests) here. Use `make test-hossam-fahmy` to run.

**`Scripts`** - Python code generators. Use `make gen` to run.

## Makefile

- `make build` - …?
- `make test` - run unit tests.
- `make test-hossam-fahmy` - run `Hossam-Fahmy-tests` and `Oh-my-decimal-tests` tests.
- `make x` - run a subset of unit tests. Remember to modify the `Makefile` to re-define what this subset is.
- `make run` - run `Experiments.test_main` unit test. This is the “playground” used for ad-hoc tests when writing the library.
- `make gen` - run Python scripts to generate code.
- `make intel-copy` - create a directory with links to the most important Intel files.

Most of the time the workflow is: `make x`, `make x`, `make x`, `make test`, and finally `make test-hossam-fahmy`.

## Missing from IEEE 754

- HexCharacter - `Swift.Double` actually has this, but it is not widely used and I am not into writing parsers.
  - convertFrom
  - convertTo
- compareQuiet
  - Ordered
  - Unordered
- compareSignaling - tiny modification of `compareQuiet` that can be added in `extension` if user so desires.
  - Equal
  - NotEqual
  - Greater
  - GreaterEqual
  - GreaterUnordered
  - NotGreater
  - Less
  - LessEqual
  - LessUnordered
  - NotLess

Side note: for compare operations you want to read IEEE 754 2019 instead of 2008. The content is the same, but the language is more approachable.

## Differences between IEEE 754 and `oh-my-decimal`

|          | IEEE 754 | Oh-my-decimal |
|----------|----------|---------------|
| Unary `+`<br/>Unary `-`<br/>`magnitude`<br/>`copy`<br/>`copySign`<br/>`init(sign:exponent:significand:rounding:status:)` (scaleB) | `sNaN` returns `NaN` and raises `invalidOperation`.      | `sNaN` returns `sNaN`, no flags raised.        |

Maybe something else, but in general it follows `Swift.Double`, so you know what to expect.

## Do NOT use

| Operation | Reason |
|-----------|--------|
| Cute operators like `*` or `/`<br/>(maybe even `+` or `-`) | Use the overloads with the `rounding` argument. Bonus points for using `status`. |
|`addingProduct`<br/>(fused multiply add, FMA)| Most of the time you actually want the intermediate rounding.|
|Binary floating point interop| Bullies from IEEE forced us to implement this (`formatOf-convertFormat(source)` operation). **[NEVER EVER](https://www.youtube.com/watch?v=WA4iX5D9Z64) USE THIS THINGIE. MASSIVE 🚩 WHEN YOU SEE SOMEBODY DOING THIS.**|
|`Decimal128._UInt128`| This is not a general purpose `UInt128`. It works for `Decimal`, but it may not work in your specific case. No guarantees.|

## Renames

- `round(decimalDigitCount:)` = `quantized`
  ```Swift
  let d = Decimal128("123.456789")!
  let precision = Decimal128("0.01")!
  var status = DecimalStatus()
  let result = d.quantized(to: precision, rounding: .towardZero, status: &status)
  print(result, status) // 12345E-2, isInexact
  status.clear(.isInexact)

  // Inexact flag will not be raised if the result is… well… exact.
  let d2 = Decimal128("123.450000")!
  let result2 = d2.quantized(to: precision, rounding: .towardZero, status: &status)
  print(result2, status) // 12345E-2, empty

  // But remember that you can't store more digits than supported by a given format.
  // Doing so will result in 'nan' with 'InvalidOperation' raised.
  // For example 'Decimal32' can store only 7 significand digits:
  let d32 = Decimal32("1234567")!
  let precision32 = Decimal32("0.1")!
  let result32 = d32.quantized(to: precision32, rounding: .towardZero, status: &status)
  print(result32, status) // nan, isInvalidOperation
  ```

- multiply by power of 10 = `init(sign:exponent:significand:rounding:status:)` (also known as `scaleB`)

  ```Swift
  let d = Decimal64("1234")!
  var status = DecimalStatus()
  let result = Decimal64(sign: .plus, exponent: 20, significand: d, rounding: .towardZero, status: &status)
  print(d) // 1234E+0
  print(result, status) // 1234E+20, DecimalStatus()
  ```

## Contributions etc.

Oh-my-decimal is feature complete, no new functionalities are planned. At some point I may add `pow` with `Int` argument, but probably not…

Do not submit any of the following PRs - they will NOT be merged:
- `pow` with `Int` argument - I want to write this myself.
- PeRfOrMaNcE - especially any of the `@inlinable/usableFromInline` things. Just don't.

## Code style

- 2-space indents and no tabs at all
- 80 characters per line
    - You will get a [SwiftLint](https://github.com/realm/SwiftLint) warning if you go over 100.
    - Over 120 will result in a compilation error.
    - If 80 doesn't give you enough room to code, your code is too complicated - consider using subroutines (advice from [PEP-7](https://www.python.org/dev/peps/pep-0007/)).
- Required `self` in methods and computed properties
    - All of the other method arguments are named, so we will require it for this one.
    - `Self`/`type name` for static methods is recommended, but not required.
    - I’m sure that they will depreciate the implicit `self` in the next major Swift version 🤞. All of that source breakage is completely justified.
- No whitespace at the end of the line
    - Some editors may remove it as a matter of routine and we don’t want weird git diffs.
- (pet peeve) Try to introduce a named variable for every `if` condition.
    - You can use a single logical operator - something like `if !isPrincess` or `if isDisnepCharacter && isPrincess` is allowed.
    - Do not use `&&` and `||` in the same expression, create a variable for one of them.
    - If you need parens then it is already too complicated.

## License

Oh-my-decimal is distributed under the “GNU General Public License”. You are NOT permitted to copy the code and distribute it solely under MIT.

`Tests/DecimalTests/Intel - generated` is generated from [Intel code](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html). This makes it dual-licensed. Intel license is available in `LICENSE-Intel` file.

`Tests/DecimalTests/Speleotrove - generated` is generated from [Speleotrove test suite](https://speleotrove.com/decimal/). This makes it dual-licensed. Speleotrove license is available in `LICENSE-speleotrove-dectest` file.

`Hossam-Fahmy-tests` are not a part of this repository, but just for completeness their license is available in `LICENSE-Hossam-Fahmy-tests` file.
