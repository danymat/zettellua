# Zettellua

A small parser for Zettelkasten, all in Lua!

## Usage

- Find tags in directory

```lua
tags = require('tags').parse_tags({ directory = "path/to/dir" })
```

- Sort tags by most used

```lua
sorted = require('tags').sort_tags(tags)
```

To display the sorted tags:

```lua
P(sorted, { count = true })
```
