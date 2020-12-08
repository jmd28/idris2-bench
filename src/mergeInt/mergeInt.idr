import Data.List

main : IO ()
main = do let x = sort [8,4,5,7,6,1,3,3,2,6,9]
          putStrLn $ show x
         