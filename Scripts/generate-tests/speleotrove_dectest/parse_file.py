from dataclasses import dataclass


_INVALID_PRECISION = -1
_INVALID_ROUNDING = ""
_INVALID_MAX_EXPONENT = -1
_INVALID_MIN_EXPONENT = -1

SPELEOTROVE_ROUNDING_CEILING = "ceiling"
SPELEOTROVE_ROUNDING_DOWN = "down"
SPELEOTROVE_ROUNDING_FLOOR = "floor"
SPELEOTROVE_ROUNDING_HALF_DOWN = "half_down"
SPELEOTROVE_ROUNDING_HALF_EVEN = "half_even"
SPELEOTROVE_ROUNDING_HALF_UP = "half_up"
SPELEOTROVE_ROUNDING_UP = "up"
SPELEOTROVE_ROUNDING_05UP = "05up"


@dataclass
class SpeleotroveConfig:
    precision: int = _INVALID_PRECISION
    rounding: str = _INVALID_ROUNDING
    max_exponent: int = _INVALID_MAX_EXPONENT
    min_exponent: int = _INVALID_MIN_EXPONENT
    version: str = ""
    extended: bool = False
    clamp: bool = False

    @property
    def is_valid(self) -> bool:
        return (
            self.precision != _INVALID_PRECISION
            and self.rounding != _INVALID_ROUNDING
            and self.max_exponent != _INVALID_MAX_EXPONENT
            and self.min_exponent != _INVALID_MIN_EXPONENT
        )

    def copy(self) -> "SpeleotroveConfig":
        return SpeleotroveConfig(
            precision=self.precision,
            rounding=self.rounding,
            max_exponent=self.max_exponent,
            min_exponent=self.min_exponent,
            version=self.version,
            extended=self.extended,
            clamp=self.clamp,
        )


@dataclass
class SpeleotroveConditions:
    clamped: bool = False
    conversion_syntax: bool = False
    division_by_zero: bool = False
    division_impossible: bool = False
    division_undefined: bool = False
    inexact: bool = False
    insufficient_storage: bool = False
    invalid_context: bool = False
    invalid_operation: bool = False
    lost_digits: bool = False
    overflow: bool = False
    rounded: bool = False
    subnormal: bool = False
    underflow: bool = False

    @property
    def is_ieee_invalid_operation(self) -> bool:
        return (
            self.conversion_syntax
            or self.division_impossible
            or self.division_undefined
            or self.insufficient_storage
            or self.invalid_context
            or self.invalid_operation
        )

    @property
    def is_ieee_division_by_zero(self) -> bool:
        return self.division_by_zero

    @property
    def is_ieee_overflow(self) -> bool:
        return self.overflow

    @property
    def is_ieee_underflow(self) -> bool:
        return self.underflow

    @property
    def is_ieee_inexact(self) -> bool:
        return self.inexact


@dataclass
class SpeleotroveLine:
    id: str
    operation: str
    arg0: str
    arg1: str | None
    arg2: str | None
    result: str
    config: SpeleotroveConfig
    conditions: SpeleotroveConditions


class _LineParser:
    def __init__(self, line: str) -> None:
        self.line = line
        self.line_len = len(line)
        self.index = 0

    @property
    def peek(self) -> str:
        return self.line[self.index]

    @property
    def is_end(self) -> bool:
        return self.index == self.line_len

    def advance(self) -> str:
        end_index = self.line.find(" ", self.index)
        end_index = self.line_len if end_index == -1 else end_index
        value = self.line[self.index : end_index]
        self.index = end_index
        return value.strip()

    def consume_whitespaces(self):
        while self.index != self.line_len and self.line[self.index].isspace():
            self.index += 1


def parse_file(path: str) -> list[SpeleotroveLine]:
    config = SpeleotroveConfig()
    result: list[SpeleotroveLine] = []

    with open(path, "r") as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("--"):
                continue

            p = _LineParser(line)
            first = p.advance()

            if first.endswith(":"):
                config = config.copy()

                directive = first.replace(":", "").lower()
                p.consume_whitespaces()
                value = p.advance()

                if directive == "precision":
                    config.precision = int(value)
                elif directive == "rounding":
                    if value == "ceiling":
                        config.rounding = SPELEOTROVE_ROUNDING_CEILING
                    elif value == "down":
                        config.rounding = SPELEOTROVE_ROUNDING_DOWN
                    elif value == "floor":
                        config.rounding = SPELEOTROVE_ROUNDING_FLOOR
                    elif value == "half_down":
                        config.rounding = SPELEOTROVE_ROUNDING_HALF_DOWN
                    elif value == "half_even":
                        config.rounding = SPELEOTROVE_ROUNDING_HALF_EVEN
                    elif value == "half_up":
                        config.rounding = SPELEOTROVE_ROUNDING_HALF_UP
                    elif value == "up":
                        config.rounding = SPELEOTROVE_ROUNDING_UP
                    elif value == "05up":
                        config.rounding = SPELEOTROVE_ROUNDING_05UP
                    else:
                        assert False, "Unknown rounding: " + value
                elif directive == "maxexponent":
                    config.max_exponent = int(value)
                elif directive == "minexponent":
                    config.min_exponent = int(value)
                elif directive == "version":
                    config.version = value
                elif directive == "extended":
                    config.extended = value == "1"
                elif directive == "clamp":
                    config.clamp = value == "1"
                else:
                    assert False, "Invalid directive: " + directive

                assert p.is_end, line
                continue

            assert "->" in line, "Not test: " + line

            id = first

            p.consume_whitespaces()
            operation = p.advance()

            p.consume_whitespaces()
            arg0 = p.advance()

            arg1: str | None = None
            arg2: str | None = None

            p.consume_whitespaces()
            tmp = p.advance()

            if tmp != "->":
                arg1 = tmp

                p.consume_whitespaces()
                tmp = p.advance()

                if tmp != "->":
                    arg2 = tmp

                    p.consume_whitespaces()
                    tmp = p.advance()

                assert tmp == "->", "More than 3 args? " + line

            # We are after '->'
            p.consume_whitespaces()
            expected = p.advance()

            conditions = SpeleotroveConditions()

            while not p.is_end:
                p.consume_whitespaces()
                c = p.advance().lower()

                if c == "clamped":
                    conditions.clamped = True
                elif c == "conversion_syntax":
                    conditions.conversion_syntax = True
                elif c == "division_by_zero":
                    conditions.division_by_zero = True
                elif c == "division_impossible":
                    conditions.division_impossible = True
                elif c == "division_undefined":
                    conditions.division_undefined = True
                elif c == "inexact":
                    conditions.inexact = True
                elif c == "insufficient_storage":
                    conditions.insufficient_storage = True
                elif c == "invalid_context":
                    conditions.invalid_context = True
                elif c == "invalid_operation":
                    conditions.invalid_operation = True
                elif c == "lost_digits":
                    conditions.lost_digits = True
                elif c == "overflow":
                    conditions.overflow = True
                elif c == "rounded":
                    conditions.rounded = True
                elif c == "subnormal":
                    conditions.subnormal = True
                elif c == "underflow":
                    conditions.underflow = True
                elif c == "--":
                    # Comment to the end of the line
                    break
                else:
                    assert False, f"Unknown condition: '{c}' in {line}"

            assert config.is_valid, str(config)
            t = SpeleotroveLine(
                id, operation, arg0, arg1, arg2, expected, config, conditions
            )
            result.append(t)

    return result


def parse_container_file(path: str) -> list[str]:
    result: list[str] = []

    with open(path, "r") as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("--"):
                continue

            p = _LineParser(line)
            first = p.advance()

            if first == "version:":
                continue

            assert first == "dectest:", first

            p.consume_whitespaces()
            file_name = p.advance()
            result.append(file_name)

    return result
