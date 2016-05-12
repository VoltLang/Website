---
title: CTFE in Volt
layout: page
---

CTFE in Volt
===


Rules
---


A `#run` expression is a broundery. The data crossing the boundery is limited, only non-mutable indirect types and arrays of non-mutable indirect types.

Function calls inside of a boundery may internally and in calls to other functions and use mutable indirect types like classes and array of classes. One caveant is that `local` and `global` variables may not be read or assigned. Basically functions need to be `pure`ish since they can mutate given classes and arrays.


Implementation
---

The first implementation doesn't need to support Classes, Structs and other named types. So we don't need to copy them. That leaves inbuilt types, lets focus on PrimitiveTypes and Arrays.


Example
---
Shows all features, some not implemented yet.

```
void internalFunc(Clazz c, u32 f)
{
	if (f < 2) { return; }
	c.mutate();
	// Recursion works as expected in CTFE and run-time.
	internnalFunc(c, f - 1);
}

int[] ctfeFunc(u32 arg)
{
	c := new Class(arg);
	internalFunc(c, 4)
	return c.genArray();
}

enum Arr = #run ctfeFunc(6);

// Normal runtime function.
int[] func()
{
	c := new Clazz();
	c.setArray(Arr);

	// CTFE:able functions can be called at run-time as normal.
	internalFunc(c, 4);
	return c.genArray();
}
```

