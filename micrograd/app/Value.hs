module Value (Value, tanh, as) where

import Data.Text (Text)
import Data.Vector (Vector)
import Data.Vector qualified as V
import Prelude hiding (tanh)
import Prelude qualified

data Value a = Value
    { v :: !a
    , grad :: !a
    , prev :: Vector (Value a)
    , label :: !Text
    , op :: !Operation
    }
    deriving stock (Show, Eq, Functor)

instance (Num a, Fractional a) => Num (Value a) where
    (+) = applyOp OpAdd
    (-) = applyOp OpSubtract
    (*) = applyOp OpMultiply
    negate = fmap negate
    abs = fmap abs
    signum = fmap signum
    fromInteger x = value (fromInteger x) ""

instance (Fractional a) => Fractional (Value a) where
    (/) = applyOp OpDivide
    fromRational x = value (fromRational x) ""

applyOp :: (Num a, Fractional a) => Operation -> Value a -> Value a -> Value a
applyOp op v1 v2 =
    Value
        { v = opToFn op v1.v v2.v
        , grad = 1
        , prev = V.fromList [v1, v2]
        , label = ""
        , op = op
        }

opToFn :: (Num a, Fractional a) => Operation -> (a -> a -> a)
opToFn OpAdd = (+)
opToFn OpSubtract = (-)
opToFn OpMultiply = (*)
opToFn OpDivide = (/)
opToFn OpTanh = const
opToFn OpNone = const

data Operation
    = OpNone
    | OpAdd
    | OpSubtract
    | OpMultiply
    | OpDivide
    | OpTanh
    deriving stock (Show, Eq)

value :: (Num a) => a -> Text -> Value a
value v label = Value{v = v, grad = 1, prev = V.empty, label = label, op = OpNone}

as :: (Num a) => Text -> Value a -> Value a
as label v = v{label}

tanh :: (Floating a) => Value a -> Value a
tanh v =
    Value
        { v = Prelude.tanh v.v
        , grad = 1
        , prev = V.singleton v
        , label = "tanh of " <> v.label
        , op = OpTanh
        }
