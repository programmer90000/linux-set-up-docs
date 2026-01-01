#![cfg(test)]

use super::*;

fn test_match(query: &str, source: &str) {
  use crate::test::test_match_lang;
  test_match_lang(query, source, Php);
}

#[test]
fn test_php_pattern() {
  // dummy example, php pattern actually does not work
  test_match("123", "123");
}
