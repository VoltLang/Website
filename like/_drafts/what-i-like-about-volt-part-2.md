---
layout: like_page
title: "What I like about Volt: Imports"
tags: [main, like]
short_title: "Part 2 - Imports"
---

```volt
import toml = watt.toml;
import json = watt.json;

// Usage
toml.parse(content);
json.parse(content);
```

```volt
import watt.toml : parseTOML = parse;
import watt.json : parseJOSN = parse;

// Usage
parseTOML(content);
parseJOSN(content);
```
