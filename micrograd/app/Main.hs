module Main (main) where

import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import Value (Value, value)

main :: IO ()
main =
    let a = value 2.0 "a" :: Value Float
        b = value (-3.0) "b" :: Value Float
        c = value 10.0 "c" :: Value Float
        d = a * b + c
     in TIO.putStrLn $ "a*b + c = " <> T.show d
