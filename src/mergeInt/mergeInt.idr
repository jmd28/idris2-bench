import Data.List

import Data.Stream

lincong : Integral a => a -> Stream a
lincong = tail . (iterate (\n => (1103515245 * n + 12345) `mod` 2147483648))

randishInts : Nat -> Integer -> List Integer
randishInts size seed = take size $ lincong seed


doSort : Nat -> IO ()
doSort Z     = putStrLn "Done"
doSort (S k) = do let xs = sort $ randishInts 1000 $ natToInteger k
                  putStrLn $ show $ last xs
                  doSort k

main : IO ()
main = doSort 100
