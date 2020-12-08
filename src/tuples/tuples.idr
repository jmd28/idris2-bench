module Main

-- note that  this is not a benchmark, rather 
-- a simple example used to help get to grips with
-- the refc compiler output

pair : Nat -> (Nat, Nat)
pair x = (x,x)

addpair : (Nat, Nat) -> Nat
addpair (x,y) = x + y

main : IO ()
main = let x = pair 4 in putStrLn ( show ( addpair x ))