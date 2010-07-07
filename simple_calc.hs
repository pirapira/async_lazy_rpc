-- 1. take input a from command line
-- 2. show a ++ a 

import IO

main = hGetLine stdin >>= \x -> putStr $ x ++ x
