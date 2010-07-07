-- 1. take input a from command line
-- 2. show a ++ a 

import System.IO

showdouble :: [Char] -> IO ()
showdouble = \x -> putStr $ x ++ x

inputline :: IO [Char]
inputline = hGetLine stdin

main = inputline >>= showdouble
