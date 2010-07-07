-- 1. take two input a from command line
-- 2. thread one computes (a ++ a)
-- 2. thread two computes (reverse a)
-- 3. a thread collects both and show concatenation.

import System.IO
import Control.Concurrent

showdouble :: [Char] -> IO ()
showdouble = \x -> putStr $ x ++ x

threadOneFirst :: IO [Char]
threadOneFirst = threadOneInput >>= takeMVar

threadOneSecond :: [Char] -> IO ()
threadOneSecond str = threadOneOutput >>= (\mvar -> putMVar mvar $ str ++ str)

threadOne :: IO ()
threadOne = threadOneFirst >>= threadOneSecond

threadOneInput :: IO (MVar [Char])
threadOneInput = newEmptyMVar
threadOneOutput :: IO (MVar [Char])
threadOneOutput = newEmptyMVar

threadTwoFirst :: IO [Char]
threadTwoFirst = threadTwoInput >>= takeMVar

threadTwoSecond :: [Char] -> IO ()
threadTwoSecond str = threadOneOutput >>= (\mvar -> putMVar mvar $ reverse str)

threadTwo :: IO ()
threadTwo = threadTwoFirst >>= threadTwoSecond

threadTwoInput :: IO (MVar [Char])
threadTwoInput = newEmptyMVar
threadTwoOutput :: IO (MVar [Char])
threadTwoOutput = newEmptyMVar

inputline :: IO [Char]
inputline = hGetLine stdin

main = inputline >>= showdouble



-- Instead of writing these above, we should be able to 