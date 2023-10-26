from speleotrove_dectest.parse_file import SpeleotroveLine

_ALL_TEST_IDS: set[str] = set()


def fix_invalid_tests(file_name: str, lines: list[SpeleotroveLine]):
    for l in lines:
        # ================
        # === Operands ===
        # ================

        # 'dqRemainderNear' contains a 'remainder' test which should be 'remaindernear'.
        # This is probably a copy paste from 'remainder', as the same test is
        # also present there.
        if file_name == "dqRemainderNear.decTest":
            if l.id == "dqrmn1070" and l.operation == "remainder":
                l.operation = "remaindernear"
                l.result = "-7291E-6176"

        # ==========
        # === Id ===
        # ==========

        # Correct dem identifiers.
        # Not a part of the 'official' module.
        # It may confuse us when we start to look for non-existing test.
        # The 'dqrmn1070' from above is the main thingie.

        # if file_name == "dqPlus.decTest":
        #     if l.id.startswith("ddqls"):
        #         l.id = l.id.replace("ddqls", "dqpls")
        # elif file_name == "ddFMA.decTest":
        #     if l.id.startswith("fma"):
        #         l.id = "dd" + l.id

        # elif file_name == "ddCanonical.decTest":
        #     if l.id == "decan011":
        #         l.id = "ddcan011"

        # if file_name.endswith("Canonical.decTest") or file_name.endswith(
        #     "Encode.decTest"
        # ):
        #     pass
        # elif file_name.startswith("dd"):
        #     assert l.id.startswith("dd"), f"{file_name} -> {l.id}"
        # elif file_name.startswith("dq"):
        #     assert l.id.startswith("dq"), f"{file_name} -> {l.id}"
        # else:
        #     assert False, file_name

        # for l in lines:
        #     assert l.id not in _ALL_TEST_IDS, "Duplicate: " + l.id
        #     _ALL_TEST_IDS.add(l.id)
