# Video 1: The spelled-out intro to neural networks and backpropagation: building micrograd

https://www.youtube.com/watch?v=VMj-3S1tku0&list=PLAqhIrjkxbuWI23v9cThsA9GvCAUhRvKZ&index=1

## Implementing `Value` in Haskell

An implemention of the python code for `Value` in Haskell. It's slightly different because Haskell.

- `Value` "wraps" an underlying numeric value, so it's naturally a Functor.
- Andrej adds methods for add and multiply (and later exponential and divide) so I implemented `Num` and `Fractional` (for divide).

The derived `show` implementation isn't very helpful. It would be nice to add something to draw the graph.
