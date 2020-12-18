module Main

import Data.Stream

lincong : Integer -> Stream Integer
lincong = tail . (iterate (\n => (1103515245 * (fromInteger n) + 12345) `mod` 2147483648))

randishInts : Nat -> Integer -> List Integer
randishInts n seed = take n $ lincong seed
