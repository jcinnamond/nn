module Value (Value (..), value) where

import Data.Text (Text)
import Data.Vector (Vector)
import Data.Vector qualified as V

data Value a = Value
    { v :: !a
    , grad :: !a
    , prev :: Vector (Value a)
    , label :: !Text
    , op :: !Operation
    }
    deriving stock (Show, Eq, Functor)

instance (Num a) => Num (Value a) where
    v1 + v2 =
        Value
            { v = v1.v + v2.v
            , grad = 0
            , prev = V.fromList [v1, v2]
            , label = v1.label <> " + " <> v2.label
            , op = OpAdd
            }
    v1 - v2 =
        Value
            { v = v1.v - v2.v
            , grad = 0
            , prev = V.fromList [v1, v2]
            , label = v1.label <> " - " <> v2.label
            , op = OpSubtract
            }
    v1 * v2 =
        Value
            { v = v1.v * v2.v
            , grad = 0
            , prev = V.fromList [v1, v2]
            , label = v1.label <> " * " <> v2.label
            , op = OpMultiply
            }
    negate = fmap negate
    abs = fmap abs
    signum = fmap signum
    fromInteger x = value (fromInteger x) ""

instance (Fractional a) => Fractional (Value a) where
    v1 / v2 =
        Value
            { v = v1.v / v2.v
            , grad = 0
            , prev = V.fromList [v1, v2]
            , label = v1.label <> " / " <> v2.label
            , op = OpDivide
            }
    fromRational x = value (fromRational x) ""

data Operation
    = OpNone
    | OpAdd
    | OpSubtract
    | OpMultiply
    | OpDivide
    deriving stock (Show, Eq)

value :: (Num a) => a -> Text -> Value a
value v label = Value{v = v, grad = 0, prev = V.empty, label = label, op = OpNone}
