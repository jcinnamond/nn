# Video 1: The spelled-out intro to neural networks and backpropagation: building micrograd

https://www.youtube.com/watch?v=VMj-3S1tku0&list=PLAqhIrjkxbuWI23v9cThsA9GvCAUhRvKZ&index=1

## 2026-03-02

### Implementing `Value` in Haskell

An implemention of the python code for `Value` in Haskell. It's slightly different because Haskell.

- `Value` "wraps" an underlying numeric value, so it's naturally a Functor.
- Andrej adds methods for add and multiply (and later exponential and divide) so I implemented `Num` and `Fractional` (for divide).

The derived `show` implementation isn't very helpful. It would be nice to add something to draw the graph.

### Improving `grad`

It makes more sense to default to 1 as that is the derivitive of a value with respect to itself.

### Label all the nodes

I didn't have an easy way to label `a*b+c` as `d` (it derived the name from the operation and the names of the operad nodes), so I changed the way nodes are created to rely on `fromInteger` and a helper function to set the label.

## 2026-03-03

### Backpropogation

When starting to implement the backpropogation code I was uncomfortable with assumptions about how many items are in the `prev` vector. For example, for multiplication it assumes that there are two elements in the vector, but nothing enforced this. I'd need to check, and then think about what to do with any error. Instead of this, I'd rather make it correct by construction and store the correct number of operads for each operation. This means pushing more context and more data into the operations.

### Immutable Values

Implementing `backward` _kinda_ works for addition and multiplication, but there is a problem with Values being used multiple times (e.g., `b = a + a`). These are not treated as the same node -- each operad points to its own copy of the Value. This isn't what I want, so I might need to fix it with an ioref, or with an env that maps labels (or some unique id?) to Values.
