// The start-up code for Tiger and the standard library
// String comparisons

#include "../step35/init.c"

// This string equality assumes that input strings are normalized
// (so that we can do simple comparison of UTF-8--coded code points)
bool string_eq(const tistring s1, const tistring s2) {
  if( s1 == s2 )                // physically equal: the same ptr
    return true;
  if( s1->size != s2->size )
    return false;
  return memcmp(s1->body,s2->body,s1->size) == 0;
}

// This function compares UTF-8--coded code points
// It is a proper comparison (pre-order): anti-symmetric, irreflexive,
// transitive
// But it does not compare Unicode characters themselves,
// which is a much more difficult task
bool string_less(const tistring s1, const tistring s2) {
  if( s1 == s2 )                // physically equal: the same ptr
    return false;
  const int cmp = memcmp(s1->body,s2->body,
                         (s1->size < s2->size ? s1->size : s2->size));
  if( cmp < 0 ) 
    return true;
  if( cmp > 0 ) 
    return false;
  return s1->size < s2->size;
}

bool string_greater(const tistring s1, const tistring s2) {
  return string_less(s2,s1);
}
