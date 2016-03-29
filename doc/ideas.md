
New syntax
---

The idea is that when we are introducing symbols into a context you always start with a keyword followed by a identifier. Tho its debatable if requiring `var` for all variables is desirable.

```
// As it is now
int x;
int func1() {}
alias al = int;
import io = watt.io;
class Class {}
struct Struct {}

// New unified syntax
var x : int;
fn func1() int {}
alias al = int;
import io = watt.io;
class Class {}
struct Struct {}
```


Optional GC
---

Adding a option for the compiler to change the default of functions to `@nogc`. Make sure we can compile runtime and watt with option enabled.


Explicit this
---

Explicit `this` arguments to member functions. It also removes the need to tag functions with `static`, `global` or `local`.

```
// As it is now
int func1(int arg) {...}
int func2(int arg) const {...}

// With explicit this
int func1(this, int arg) {...}
int func2(const this, int arg) {...}

// Different syntax
fn func1(this, int arg) int {...}
fn func2(const this, int arg) int {...}
```


Better reference control
---

Building on top the explicit `this` idea we can now control if this is a copy or reference. For classes references would be required.  Maybe we should move away from `ref` to `&` for brevity.

```
fn func1(ref this, int arg) int {...}
// vs
fn func2(this&, int arg) int {...}
```


Inbuilt string
---

Making `string` be a inbuilt type allows for several optimizations to be made. Since string is immutable it allows us to cache the hash for the string. The string length is now in the `object`instead leading to less memory usage at referee site. It allows for transparent [interning](https://en.wikipedia.org/wiki/String_interning) of strings, this gives two benefits: one equality becomes a pointer compare; applications that uses many common strings (like a compiler) can see memory savings.

```
struct __String
{
	size_t hash;
	size_t length;
	// Followed by length + 1 bytes of string data.
	// Inbuilt strings are always zero terminated.
}
```

Building referencing counting strings on the regular gc string would be easy.

It would also be possible to implicitly cast the new string to `immutable(char)[]` and  `const(char)[]`.


Bitcast (aka recast)
---

In both Volt and D cast is a semantical smart cast. But sometimes you just want to take the bits you have and changing the interpretation of them.

```
// Notice 32 vs 64 bits.
int foo = -1;
long minusOne = cast(long)foo; // Sign extend.
long uintMax = recast(long)foo; // No sign extend.

assert (minusOne == -1);
assert (uintMax == uint.max);

// Without recast
long uintMax2 = cast(long)cast(uint)foo;
```

This opens up a bit of a rabbit hole, certain casts should only be recasts and not semantic casts: pointers to and from integers; signed to and from unsigned. Should we error on these and require the use of recast? (hint yes)
