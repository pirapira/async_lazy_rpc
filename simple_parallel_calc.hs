-- 1. take two input a from command line
-- 2. thread one computes (a ++ a)
-- 2. thread two computes (reverse a)
-- 3. a thread collects both and show concatenation.

import System.IO
import Control.Concurrent

-- Communication Channel
threadOneInput :: IO (MVar [Char])
threadOneInput = newEmptyMVar

threadOneOutput :: IO (MVar [Char])
threadOneOutput = newEmptyMVar

threadTwoInput :: IO (MVar [Char])
threadTwoInput = newEmptyMVar

threadTwoOutput :: IO (MVar [Char])
threadTwoOutput = newEmptyMVar

-- ThreadOne
threadOneFirst :: IO [Char]
threadOneFirst = threadOneInput >>= takeMVar

threadOneSecond :: [Char] -> IO ()
threadOneSecond str = threadOneOutput >>= (\mvar -> putMVar mvar $ str ++ str)

threadOne :: IO ()
threadOne = threadOneFirst >>= threadOneSecond

-- ThreadTwo
threadTwoFirst :: IO [Char]
threadTwoFirst = threadTwoInput >>= takeMVar

threadTwoSecond :: [Char] -> IO ()
threadTwoSecond str = threadTwoOutput >>= (\mvar -> putMVar mvar $ reverse str)

threadTwo :: IO ()
threadTwo = threadTwoFirst >>= threadTwoSecond

-- Main
inputline :: IO [Char]
inputline = hGetLine stdin

feedThreadOne :: [Char] -> IO [Char]
feedThreadOne input = threadOneInput >>= (\mvar -> putMVar mvar input) >> return input

feedThreadTwo :: [Char] -> IO ()
feedThreadTwo input = threadTwoInput >>= (\mvar -> putMVar mvar input)

waitThreadOne :: () -> IO [Char]
waitThreadOne = \x -> threadOneOutput >>= takeMVar

waitThreadTwo :: [Char] -> IO ([Char], [Char])
waitThreadTwo = \one -> (threadTwoOutput >>= takeMVar) >>= \two -> (return (one, two))

output :: ([Char], [Char]) -> IO ()
output = \(x,y) -> putStr $ x ++ y

main :: IO ()
main = forkIO threadOne >> forkIO threadTwo >>
       inputline >>= feedThreadOne >>=
       feedThreadTwo >>= waitThreadOne >>=
       waitThreadTwo >>= output

-- Instead of writing these above, we should be able to 
