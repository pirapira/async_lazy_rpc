-- 1. take two input a from command line
-- 2. thread one computes (a ++ a)
-- 2. thread two computes (reverse a)
-- 3. a thread collects both and show concatenation.

import System.IO
import Control.Concurrent

showdouble :: [Char] -> IO ()
showdouble = \x -> putStr $ x ++ x

forkIO' :: IO [Char] -> (IO ThreadId, IO [Char])
forkIO' = \x -> (forkIO (return ()), x)
-- yes, we can create a thread. but what can a thread do?

inputline :: IO [Char]
inputline = hGetLine stdin

main = inputline >>= showdouble
