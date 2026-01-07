## ast-grep(sg)

ast-grep(sg) is a CLI tool for code structural search, lint, and rewriting.

## Introduction
ast-grep is an abstract syntax tree based tool to search code by pattern code. Think of it as your old-friend `grep`, but matching AST nodes instead of text.
You can write patterns as if you are writing ordinary code. It will match all code that has the same syntactical structure.
You can use `$` sign + upper case letters as a wildcard, e.g. `$MATCH`, to match any single AST node. Think of it as regular expression dot `.`, except it is not textual.

## Command line usage example

ast-grep has following form.
```
ast-grep --pattern 'var code = $PATTERN' --rewrite 'let code = new $PATTERN' --lang ts
```

## Feature Highlight

ast-grep's core is an algorithm to search and replace code based on abstract syntax tree produced by tree-sitter.
It can help you to do lightweight static analysis and massive scale code manipulation in an intuitive way.

Key highlights:

* An intuitive pattern to find and replace AST.
ast-grep's pattern looks like ordinary code you would write every day (you could say the pattern is isomorphic to code).

* jQuery like API for AST traversal and manipulation.

* YAML configuration to write new linting rules or code modification.

* Written in compiled language, with tree-sitter based parsing and utilizing multiple cores.

* Beautiful command line interface :)

ast-grep's vision is to democratize abstract syntax tree magic and to liberate one from cumbersome AST programming!

* If you are an open-source library author, ast-grep can help your library users adopt breaking changes more easily.
* if you are a tech lead in your team, ast-grep can help you enforce code best practice tailored to your business need.
* If you are a security researcher, ast-grep can help you write rules much faster.
