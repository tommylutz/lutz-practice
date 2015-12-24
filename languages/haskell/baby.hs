-- Learn you a Haskell for greater good
-- :cd e:\root\dev\Haskell
doubleMe x = x + x

--doubleUs x y = x*2 + y*2
doubleUs x y = doubleMe x + doubleMe y

doubleSmallNumber x = (if x > 100 then 2.1 else x*2) + 6

legalFunction = "Hello There"

boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]

test xs = [ if x < 10 then "small" else "large" | x <- xs, x /= 12 && x/= 13 ]

length' xs = sum [1 | farfenugin <- xs ]

noUppers :: String -> String
noUppers xs = [ x | x <- xs, not (x `elem` ['A'..'Z']) ]

factorial :: Integer -> Integer
factorial 0 = 1
factorial x = x * factorial (x - 1)

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER, SEVEN!"
lucky x = "Not seven...unlucky"

sayMe :: (Integral a) => a -> String
sayMe 1 = "One"
sayMe 2 = "Two"
sayMe 3 = "Three"
sayMe x = "pppp"

sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum'(xs)

bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
    | d <= 18.5 = "Under"
    | d <= 25.0 = "Normal"
    | d <= 30.0 = "Over"
    | True = "Obese"
    where d = 2 * bmi
    
max' :: (Ord a) => a -> a -> a
max' val1 val2
    | val1 > val2 = val1
    | otherwise = val2

getInitials :: String -> String -> String
--getInitials firstname lastname = [f] ++ ". " ++ [l] ++ "."
--    where (f:_) = firstname
--          (l:_) = lastname
getInitials firstname@(f:_) (l:_) = [f] ++ ". " ++ [l] ++ ".: "++firstname

-- Quicksort
-- Pick a divider
-- Everything less than the divider goes to the left
-- Everything greater than the divider goes to the right
-- Nominally pick index 0 as the divider
quickSort :: Ord a => [a] -> [a]
quickSort []  = []
quickSort [a] = [a]
quickSort xs  = quickSort([x | x <- tail xs, x <  partition ]) ++ 
                [partition] ++ 
                quickSort([x | x <- tail xs, x >= partition ])
             where partition = head xs

-- quickSort( [3,1,2] ) = 
--  quickSort([1,2]) ++     quickSort([3])
--  [] + quickSort([1,2])   [3]
             
maximum' :: (Ord a) => [a] -> a
-- This implementation can't handle 16 million items
maximum' [] = error "Maximum of empty list"
maximum' [x] = x
maximum' (x:xs) 
    | x > maxTail = x
    | otherwise = maxTail
    where maxTail = maximum' xs

-- This implementation *can*  
max2' :: (Ord a) => [a] -> a
max2' [] = error "Max of empty list"
max2' (x:xs) = maxh x xs
    where maxh :: (Ord a) => a -> [a] -> a
          maxh x []  = x
          maxh x (y:ys)
              | x > y = maxh x ys
              | otherwise  = maxh y ys
              
partialFunc :: (Integral a) => String -> a -> String
partialFunc str 0 = str
partialFunc str n = str ++ " " ++ (partialFunc str (n - 1))

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' func [] _  = []
zipWith' func _  [] = []
zipWith' func (a:ax) (b:bx) = func a b : (zipWith' func ax bx)

flipper' :: (a -> b -> c) -> b -> a -> c
flipper' func arg1 arg2 = func arg2 arg1 


