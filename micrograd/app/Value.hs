module Value (Value, tanh, as, backward) where

import Data.Text (Text)
import Prelude hiding (tanh)
import Prelude qualified

data Value a = Value
    { v :: !a
    , grad :: !a
    , label :: !Text
    , op :: !(Operation a)
    }
    deriving stock (Show, Eq, Functor)

defaultGrad :: (Num a) => a
defaultGrad = 0

instance (Num a, Fractional a) => Num (Value a) where
    v1 + v2 = Value (v1.v + v2.v) defaultGrad "" $ OpAdd v1 v2
    v1 - v2 = Value (v1.v - v2.v) defaultGrad "" $ OpSubtract v1 v2
    v1 * v2 = Value (v1.v * v2.v) defaultGrad "" $ OpMultiply v1 v2
    negate = fmap negate
    abs = fmap abs
    signum = fmap signum
    fromInteger x = Value (fromInteger x) defaultGrad "" OpNone

instance (Fractional a) => Fractional (Value a) where
    v1 / v2 = Value (v1.v / v2.v) defaultGrad "" $ OpDivide v1 v2
    fromRational x = Value (fromRational x) defaultGrad "" OpNone

data Operation a
    = OpNone
    | OpAdd (Value a) (Value a)
    | OpSubtract (Value a) (Value a)
    | OpMultiply (Value a) (Value a)
    | OpDivide (Value a) (Value a)
    | OpTanh (Value a)
    deriving stock (Show, Eq, Functor)

as :: (Num a) => Text -> Value a -> Value a
as label v = v{label}

tanh :: (Floating a) => Value a -> Value a
tanh v =
    Value
        { v = Prelude.tanh v.v
        , grad = 1
        , label = "tanh of " <> v.label
        , op = OpTanh v
        }

backward :: (Num a) => Value a -> Value a
backward = go 1
  where
    go :: (Num a) => a -> Value a -> Value a
    go grad v@Value{op = OpNone} =
        let grad' = v.grad + grad
         in v{grad = grad'}
    go grad v@Value{op = OpAdd c1 c2} =
        let grad' = v.grad + grad
         in v{grad = grad', op = OpAdd (go grad' c1) (go grad' c2)}
    go grad v@Value{op = OpMultiply c1 c2} =
        let grad' = v.grad + grad
            c1grad = grad' * c2.v
            c2grad = grad' * c1.v
         in v{grad = grad', op = OpMultiply (go c1grad c1) (go c2grad c2)}
    go _ _ = undefined
