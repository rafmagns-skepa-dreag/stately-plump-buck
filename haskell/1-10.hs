import           Data.List

-- problem 1
lastElem :: [a] -> a
lastElem = last

-- problem 2
secondToLast :: [a] -> a
secondToLast x = x !! (length x-2)

-- problem 3
elementAt :: [a] -> Int -> a
elementAt x i = x !! i

-- problem 4
lengthWrapper :: [a] -> Int
lengthWrapper = length

-- problem 5
reverseWrapper :: [a] -> [a]
reverseWrapper = reverse

--problm 6
isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome xs = case length xs of
    0 -> True
    1 -> True
    _ -> (head xs == last xs) && isPalindrome  (tail $ init xs)


data NestedList a = Elem a | List [NestedList a]

--problem 7
flatten :: NestedList a -> [a]
flatten (Elem a) = [a]
flatten (List b) = concatMap flatten b

--problem 8
compress :: (Eq a) => [a] -> [a]
compress x = case x of
  [] -> []
  [x] -> [x]
  (x:xs) -> if x /= head xs then x:compress xs else compress xs

--problem 9
pack :: (Eq a) => [a] -> [[a]]
pack [] = []
pack (x:xs) = x:takeWhile (==x) xs : pack (dropWhile (==x) xs)

--alternatively
pack' = group

--problem 10
encode :: (Eq a) => [a] -> [(Int, a)]
encode [] = []
encode x  = [(length a, head a) | a <- pack x ]





-- Other practice....
doubleMe x = x+x

doubleUs x y = doubleMe x + doubleMe y

doubleSmall x = if x > 100 then x*2 else x

concatenate = (++)

getByIndex i x = x !! i

removeNonUpperCase :: String -> String
removeNonUpperCase st = [c | c <- st, c `elem` ['A'..'Z']]



permute :: Int -> String -> [String]
permute count (x:xs) = if length xs == count then [] else (x:xs) : permute (count+1) (xs++[x])

printer :: String -> [String] -> String
printer acc x = case x of
    [] -> acc ++ "\n"
    [a] -> printer (acc++a) []
    (a:as) -> printer (acc++" "++a) as

main = do
    n <- getLine
    input <- getContents
    --putStrLn input
    print $ map (printer "" . permute 1) (lines input)
