-- 1. take two input a from command line
-- 2. thread one computes (a ++ a)
-- 2. thread two computes (reverse a)
-- 3. a thread collects both and show concatenation.

import System.IO
import Control.Concurrent

-- Communication Channel


-- ThreadOne
threadOneFirst :: MVar [Char] -> IO [Char]
threadOneFirst = \threadOneInput -> takeMVar threadOneInput

threadOneSecond :: MVar [Char] -> [Char] -> IO ()
threadOneSecond threadOneOutput str =
    putMVar threadOneOutput $ str ++ str

threadOne :: MVar[Char] -> MVar[Char] -> IO ()
threadOne inp outp = (threadOneFirst inp) >>= (threadOneSecond outp)

-- ThreadTwo
threadTwoFirst :: MVar[Char] -> IO [Char]
threadTwoFirst = takeMVar

threadTwoSecond :: MVar[Char] -> [Char] -> IO ()
threadTwoSecond threadTwoOutput str = putMVar threadTwoOutput $ reverse str

threadTwo :: MVar[Char] -> MVar[Char] -> IO ()
threadTwo = \input output -> (threadTwoFirst input) >>= (threadTwoSecond output)

-- Main
inputline :: IO [Char]
inputline = hGetLine stdin

feedThreadOne :: MVar[Char] -> [Char] -> IO [Char]
feedThreadOne threadOneInput input =  (putMVar threadOneInput input) >> return input

feedThreadTwo :: MVar[Char] -> [Char] -> IO ()
feedThreadTwo = putMVar

waitThreadOne :: MVar[Char] -> () -> IO [Char]
waitThreadOne = \threadOneOutput x -> takeMVar threadOneOutput

waitThreadTwo :: MVar[Char] -> [Char] -> IO ([Char], [Char])
waitThreadTwo = \threadTwoOutput one -> (takeMVar threadTwoOutput) >>= \two -> (return (one, two))

output :: ([Char], [Char]) -> IO ()
output = \(x,y) -> putStr $ x ++ y

main :: IO ()
main = newEmptyMVar >>= \threadOneInput ->
       newEmptyMVar >>= \threadOneOutput ->
       newEmptyMVar >>= \threadTwoInput ->
       newEmptyMVar >>= \threadTwoOutput ->
       forkIO (threadOne threadOneInput threadOneOutput) >>
       forkIO (threadTwo threadTwoInput threadTwoOutput) >>
       inputline >>=
       (feedThreadOne threadOneInput) >>=
       (feedThreadTwo threadTwoInput) >>= 
       (waitThreadOne threadOneOutput) >>=
       (waitThreadTwo threadTwoOutput) >>= output

-- Instead of writing these above, we should be able to 
