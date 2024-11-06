validator {
  fn always_succeeds(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

test succeeds() {
  always_succeeds(Void, Void, Void)
}

validator {
  fn always_fails(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    False
  }
}

test fails() fail {
  always_fails(Void, Void, Void)
}
