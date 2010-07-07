-- 1. take two input a from command line
-- 2. thread one computes (a ++ a)
-- 2. thread two computes (reverse a)
-- 3. a thread collects both and show concatenation.

import System.IO

showdouble :: [Char] -> IO ()
showdouble = \x -> putStr $ x ++ x

inputline :: IO [Char]
inputline = hGetLine stdin

main = inputline >>= showdouble
