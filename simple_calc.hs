-- 1. take input a from command line
-- 2. show a ++ a 

import IO

main = do x <- hGetLine stdin
          putStr $ x ++ x
