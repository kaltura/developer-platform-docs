---
layout: page
title: Coding Guidelines for Web Player
weight: 110
---

Use the following coding guidelines when creating and editing players.

## Naming

Use the following naming conventions:

| Convention | Explanation                                                                                     |
| ---------- | ----------------------------------------------------------------------------------------------- |
| Function   | `functionNamesLikeThis`                                                                         |
| Variable   | `variableNamesLikeThis`                                                                         |
| Class      | `ClassNamesLikeThis`                                                                            |
| Enum       | `EnumNamesLikeThis`                                                                             |
| Constant   | `CONSTANT_VALUES_LIKE_THIS`                                                                     |
| Private    | Private properties and methods should be named **with** a leading underscore: `_myPrivateVar`  |
| Public     | Public properties and methods should be named **without** a leading underscore: `myPublicVar`. |

## Strings

Prefer `'` over `"`

For consistency's sake, single-quotes (') are preferable to double-quotes ("). This is especially important when creating strings that include HTML:

```javascript
var h1 = '<h1>This is some HTML</h1>';
```

## Functions

### Parameters

Function parameters must be declared with their types:

```javascript
function exampleFunction(text: String, obj: Object, ... )
```

Function parameters must be typed with JSDoc annotations in the JSDoc preceding the function’s definition.

### Return Value

The functions return value type _must_ be appear in the function declaration:

```javascript
function exampleFunction( ... ): Promise<*> {
  ...
}
```

The function return types must be specified in the JSDoc directly above the function definition.

### Arrow Functions

- It's better to use arrow functions over `f.bind(this)`, and especially over `kalt.bind(f, this)`.
- Avoid writing `var self = this`.
- Arrow functions are particularly useful for callbacks, which sometimes pass unexpected additional arguments.

## Braces

Braces are requires for all control structures (e.g., `if`, `else`, `for`, `do`, `while` as well as any others), even if the body contains only a single statement. The first statement of a non-empty block must begin in its own line.

Short if statements that look like this are ill-advised:

```javascript
if (someCondition) doSomething();

for (let i = 0; i < foo.length; i++) bar(foo[i]);
```

Instead use brackets like this: 

```javascript 
if (someCondition) {

   doSomething();

}
```

## Block Indentation

Block indentation is +2 spaces. Each time a new block or block-like construct is opened, the indent increases by two spaces. When the block ends, the indent returns to the previous indent level. The indent level applies to both code and comments throughout the block.

## Flow

Type names must start with a Capital letter (pascal case), e.g.:

```javascript
type CategoryType = {[category: string]: number};
export type {CategoryType};
```
