---
layout: page
title: Expressions
---

# Expressions

This document goes over the specific steps the compiler takes semantically process
expressions. The rest of the document will refer to the following snippet for its
examples.

    module pkg.mod;

    global int var;
    alias aliasType = int;
    alias aliasVar = var;
    int func() { return 4; }
    @property int propGet() { return 4; }
    int ufcs(int val) { return val; }
    int ufcs(Foo f) { return f.val; }

    global Foo fooInstance;

    class Foo
    {
    	global Foo staticVar;

    	int val;
    	Foo field;
    	@property Foo prop() { return this; }
    }

## Glossary
 * **Scope**: Named identifier that you can lookup more identifiers in,
   includes Named types, packages and modules.
 * **UFCS**: Uniform function call syntax
   [wiki](https://en.wikipedia.org/wiki/Uniform_Function_Call_Syntax)

# General Exp Notes

Verify that the expression has a side-effect. This can be done on the Context
if an expression has a side-effect (function calls and the like set the flag).

Verify expression is a value with isValueExp(), should assume that the given
exp's has verified its own children. So BinOp and the so on should be
considered values.

# IdentifierExp

Examples of checking an IdentifierExp. If an identifier isn't found this is an
error, we should not check if the IdentifierExp value is directly turned into a
value since it can be used to lookup types e.g. `aliasType.max`. 

    var = invalidSymbol; // error: No identifier 'invalidSymbol' found.
    var = pkg;           // error: Package 'pkg' used as a value.
    var = pkg.mod;       // error: Module 'pkg.mod' used as a value.
    var = aliasType;     // error: Type 'aliasType' (ake 'int') used as value.
    var = Foo;           // error: Type 'Foo' (ake 'test.Foo') used as value.
    var = aliasVar;
    var = propGet;
    var = func;          // error: <implicit conversion error>
    var = func();

Examples of checking side-effects.

    aliasVar;   // error: Expression has no effect.
    var;        // error: Expression has no effect.
    propGet;
    func;       // error: Expression has no effect.


# PostfixExp

## Identifier

When talking about postifx identifiers we introduce the concept of postfix
identifier chains (in this context known as chains) to better explain and
more clearly show the operations done on postfix identifiers. Consider the
following code, it is a long chain starting with a IdentifierExp and ends
before the call.

    .pkg.mod.Foo.staticVar.field.prop.ufcs();

The first this we need to do is find where the chain goes from looking up
symbols in scopes to a variable or property function, this is done from left
to right. In the IR this is done from the inner most child out.

After that we need to do other types of checking and transformation. In the
case above we should check that the field excist in the Type of staticVar
and that it is not staic/type. For prop we should transform that into a call.
For ufcs we need to have the postfix call to correctly resolve the function
lookup and checking.

## Call

    func();
    fooInstance.foo();
