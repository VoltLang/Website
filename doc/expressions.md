---
layout: page
title: Expressions
---

# Expressions

This document goes over the specific steps the parser takes semantically parse
expressions. The below snippet explains some predefined identifiers.

    global int var;
    alias aliasType = int;
    alias aliasVar = var;
    int func() { return 4; }
    @property int propGet() { return 4; }
    int ufcs(int val) { return val; }
    int ufcs(Foo f) { return f.val; }

    class Foo
    {
    	global Foo staticVar;

    	int val;
    	Foo field;
    	@property Foo prop() { return this; }
    }

# General Exp Notes

Verify that the expression has a sideeffect. This can be done on the Context
if a expression has a side-effect (function call and the like set the flag).

Verify expression is a value with isValueExp(), should assume that the given
exp's has varified its own children. So BinOp and the like should be
concidered a value.

# IdentifierExp

Examples of checking on IdentifierExp. If a identifier isn't found this is a
error, we should not check if the IdentifierExp value is directly turned into a
value since it can be used to lookup types e.i. `aliasType.max`. 

    var = invalidSymbol; // error: No identifier 'invalidSymbol' found.
    var = aliasType;  // error: Type 'aliasType' (ake 'int') used as expression.
    var = Foo;        // error: Type 'Foo' (ake 'test.Foo') used as expression.
    var = aliasVar;
    var = propGet;
    var = func;       // Type error (missing call).
    var = func();

Examples of no effect checking.

    aliasVar;   // error: Expression has no effect.
    var;        // error: Expression has no effect.
    propGet;
    func;       // error: Expression has no effect.


# PostifxExp

## Identifier

Concider the code below:

    .pkg.mod.Foo.staticVar.feild.prop.ufcs();
