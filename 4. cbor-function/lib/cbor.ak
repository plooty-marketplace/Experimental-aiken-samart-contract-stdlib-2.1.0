use aiken
use aiken/builtin.{decode_utf8, serialise_data}
 
pub fn serialise(self: Data) -> ByteArray {
  serialise_data(self)
}

test serialise_1() {
  serialise(42) == #"182a"
}

test serialise_2() {
  serialise(#"a1b2") == #"42a1b2"
}

test serialise_3() {
  serialise([]) == #"80"
}

test serialise_4() {
  serialise((1, 2)) == #"9f0102ff"
}

test serialise_5() {
  serialise((1, #"ff", 3)) == #"9f0141ff03ff"
}

test serialise_6() {
  serialise([(1, #"ff")]) == #"9f9f0141ffffff"
}

test serialise_7() {
  serialise(Some(42)) == #"d8799f182aff"
}

test serialise_8() {
  serialise(None) == #"d87a80"
}

test serialise_9() {
  serialise([Pair(1, #"ff")]) == #"a10141ff"
}

pub fn diagnostic(self: Data) -> String {
  aiken.diagnostic(self, #"")
    |> decode_utf8
}

test diagnostic_1() {
  diagnostic(42) == @"42"
}

test diagnostic_2() {
  diagnostic(#"a1b2") == @"h'A1B2'"
}

test diagnostic_3() {
  diagnostic([1, 2, 3]) == @"[_ 1, 2, 3]"
}

test diagnostic_4() {
  diagnostic([]) == @"[]"
}

test diagnostic_5() {
  diagnostic((1, 2)) == @"[_ 1, 2]"
}

test diagnostic_6() {
  diagnostic((1, #"ff", 3)) == @"[_ 1, h'FF', 3]"
}

test diagnostic_7() {
  diagnostic([(1, #"ff")]) == @"[_ [_ 1, h'FF']]"
}

test diagnostic_7_alt() {
  diagnostic([Pair(1, #"ff")]) == @"{_ 1: h'FF' }"
}

test diagnostic_8() {
  diagnostic(Some(42)) == @"121([_ 42])"
}

test diagnostic_9() {
  diagnostic(None) == @"122([])"
}

test diagnostic_10() {
  let xs: List<(Int, Int)> =
    []
  diagnostic(xs) == @"[]"
}

test diagnostic_10_alt() {
  let xs: Pairs<Int, Int> =
    []
  diagnostic(xs) == @"{}"
}

type Foo {
  foo: Bar,
}

type Bar {
  A
  B(Int)
}

test diagnostic_11() {
  diagnostic(Foo { foo: A }) == @"121([_ 121([])])"
}

test diagnostic_12() {
  diagnostic(Foo { foo: B(42) }) == @"121([_ 122([_ 42])])"
}

type Baz {
  a0: Int,
  b0: ByteArray,
}

test diagnostic_13() {
  diagnostic(Baz { a0: 14, b0: #"ff" }) == @"121([_ 14, h'FF'])"
}

test diagnostic_14() {
  diagnostic([0]) == @"[_ 0]"
}

test diagnostic_15() {
  diagnostic(-42) == @"-42"
}

test diagnostic_16() {
  diagnostic([-1, 0, 1]) == @"[_ -1, 0, 1]"
}
