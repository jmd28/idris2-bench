module Main

import B Tree

treesort : Ord a => List a -> List a
treesort xs = BTree.toList $ toTree xs

lincong : Integer -> Stream Integer
lincong = tail . (iterate (\n => (1103515245 * (fromInteger n) + 12345) `mod` 2147483648))

randishInts : Nat -> Integer -> List Integer
randishInts size seed = take size $ lincong seed


doSort : Nat -> IO ()
doSort Z     = putStrLn "Done"
doSort (S k) = do let xs = treesort $ randishInts 1000 k
                  putStrLn $ show $ last xs
                  doSort k

main : IO ()
main = doSort 100




