
-- problem 1
lastElem :: [a] -> a
lastElem x = last x

-- problem 2
secondToLast :: [a] -> a
secondToLast x = x !! (length x-2)

-- problem 3
elementAt :: [a] -> Int -> a
elementAt x i = x !! i

-- problem 4
lengthWrapper :: [a] -> Int
lengthWrapper x = length x

-- problem 5
reverseWrapper :: [a] -> [a]
reverseWrapper x = reverse x

--problm 6
isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome xs = case length xs of
 0 -> True
 1 -> True
 _ -> (if head xs == last xs then isPalindrome $ tail $ init xs else False)


data NestedList a = Elem a | List [NestedList a]

--problem 7
flatten :: NestedList a -> [a]
flatten (Elem a) = [a]
flatten (List b) = concatMap flatten b

--problem 8
compress :: (Eq a) => [a] -> [a]
compress x = case x of
  [] -> []
  (x:[]) -> [x]
  (x:xs) -> (if x /= (head xs) then x:(compress xs) else compress xs)

--problem 9
pack :: (Eq a) => [a] -> [[a]]
pack [] = []
pack (x:xs) = (x:(takeWhile (==x) xs)) : pack (dropWhile (==x) xs)

--problem 10
encode :: (Eq a) => [a] -> [(Int, a)]
encode [] = []
encode x  = [(length a, head a) | a <- (pack x) ]





-- Other practice....
doubleMe x = x+x

doubleUs x y = doubleMe x + doubleMe y

doubleSmall x = ( if x > 100 then x*2 else x)

concatenate x y = x ++ y

getByIndex i x = x !! i

removeNonUpperCase :: [Char] -> [Char]
removeNonUpperCase st = [c | c <- st, c `elem` ['A'..'Z']]
