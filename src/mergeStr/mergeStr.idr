import Data.List

main : IO ()
main = do let x = sort [
            "hello",
            "world",
            "well",
            "idris"
          ]
          putStrLn $ show x
        