import Data.List

--problem 10 code for use in 11
encode :: (Eq a) => [a] -> [(Int, a)]
encode [] = []
encode x  = [(length a, head a) | a <- (group x) ]

--problem 11
data Encoded a = Single a | Multiple Int a

encodeModified :: (Eq a) => [a] -> [Encoded a]
encodeModified x = concatMap (\(b,c) -> if b /= 1 then [(Multiple b c)] else [(Single c)]) (encode x)

--problem 12
decodeModified :: [Encoded a] -> [a]
decodeModified []     = []
decodeModified (x:xs) = case x of
  Multiple a b -> replicate a b ++ decodeModified xs
  Single a -> a : decodeModified xs


-- another solution
decodeModified' :: [Encoded a] -> [a]
decodeModified' x = concatMap helper x where
  helper (Single a) = [a]
  helper (Multiple a b) = replicate a b

--problem 13
encodeDirect :: (Eq a) => [a] -> [Encoded a]
encodeDirect x = helper 1 x
  where
    helper _ [] = []
    helper count q = case q of
      (a:[]) -> [encoder count a]
      (a:as) -> (if a/=(head as) then [encoder count a] ++ helper 1 as else helper (count+1) as)

encoder :: Int -> a -> Encoded a
encoder 1 a = Single a
encoder c a = Multiple c a

--PROBLEM 14
dup :: [a] -> [a]
dup = concatMap (\a -> [a,a])


--PROBLEM 15
repl :: [a] -> Int -> [a]
repl x y = concatMap (replicate y) x


--PROBLEM 16
dropEry :: [a] -> Int -> [a]
--can be rewritten with take instead of splitAt
dropEry x n
  | n > (length x) = x
  | otherwise = fst a ++ (dropEry (drop 1 (snd a)) n)
    where
      a = splitAt (n-1) x


--PROBLEM 17
split :: [a] -> Int -> ([a],[a])
--uses predefined predicates
split = flip splitAt

split' :: [a] -> Int -> ([a],[a])
split' x n = helper n ([],x)
  where
    helper :: Int -> ([a],[a]) -> ([a],[a])
    helper 0 (a,b) = (a++[],b)
    helper n (a,(b:bs)) = helper (n-1) (a++[b],bs)


--PROBLEM 18
slice :: [a] -> Int -> Int -> [a]
slice x i j
  | i > j = x
  | j > length x = snd $ splitAt (i-1) x
  | i < j && j < length x = fst $ splitAt (j-i+1) (snd $ splitAt (i-1) x)

-- I didnt' write this but it's very elegant
slice' xs i k = [x | (x,j) <- zip xs [1..k], i <= j]


--PROBLEM 19
rotate :: [a] -> Int -> [a]
rotate x n
  | abs n > length x = error "rotate: Index too large"
  | otherwise = snd a ++ fst a
    where
      a = splitAt q x
      q = if n > 0 then n else (length x)+n


--PROBLEM 20
removeAt :: [a] -> Int -> (a,[a])
removeAt x n
  | abs n > length x = error "removeAt: Index too large"
  | otherwise = (head $ take 1 (snd a), fst a ++ drop 1 (snd a))
  where
    a = splitAt q x
    q = if n > 0 then n-1 else (length x)+n
