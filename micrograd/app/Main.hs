module Main (main) where

import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import Value (Value, as)

main :: IO ()
main =
    let a = as "a" 2.0
        b = as "b" (-3.0)
        c = as "c" 10.0
        d = as "d" $ a * b + c :: Value Float
     in TIO.putStrLn $ "a*b + c = " <> T.show d
