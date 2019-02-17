---
layout: like_page
title: "What I like about Volt: Symbols"
tags: [main, like]
short_title: "Part 1 - Symbols"
---

We will start the first post of this series in a light way talking about
symbols and how the module based symbol lookup makes things easier for the
coder. While there are other languages that also use a similar module & symbol
as Volt, a comparison to C lets us illustrate why this is a system to like.

In this example we see that in order for the `calling` function be able to call
`the_function` it needs to be pre-declared.

```c
static int the_function();

int calling()
{
	return the_function() + 3;
}

int the_function(int arg)
{
	return calling() + 39;
}
```

But in Volt thanks to the module & symbol system Volt this is not neccassery
since semantically all symboles are declared at the same time.

```volt
fn calling() i32
{
	return the_function() + 3;
}

fn the_function() i32
{
	return 39;
}
```
