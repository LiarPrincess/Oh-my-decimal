Wrapper for [Intel decimal library](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html). Compared to Swift implementation (`mr-darcy` branch) it has `pow`, but `DecimalStatus` is not publicly available.

## Instructions

1. Download [Intel library](https://www.intel.com/content/www/us/en/developer/articles/tool/intel-decimal-floating-point-math-library.html)
2. Put it inside the `IntelRDFPMathLib20U2` directory
3. `make intel-linux` - this will build the library. Only Linux is supported.
4. `make test`

## Contributions

No contributions are accepted to this branch.

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
