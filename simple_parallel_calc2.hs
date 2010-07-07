import System.IO

main = (hGetLine stdin) >>= \input ->
       (\(x,y) -> putStr $ x ++ y)
       ((\input -> input ++ input) input,
        (\input -> reverse input) input)
