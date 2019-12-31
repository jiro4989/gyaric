import unittest

include gyaric

suite "proc encode":
  test "あいうえお":
    var wants: seq[string]
    for a in dict["あ"]:
      for i in dict["い"]:
        for u in dict["う"]:
          for e in dict["え"]:
            for o in dict["お"]:
              wants.add(a & i & u & e & o)
    for i in 1..100:
      check encode("あいうえお") in wants

suite "proc decode":
  test "あいうえお":
    # 完全にはデコードできない
    for i in 1..100:
      check encode("あいうえお").decode == "あいうえお"
