(*http://rosettacode.org/wiki/Binary_search#Standard_ML*)
structure IntArray = struct
  open Array
  type elem = int
  type array = int Array.array
  type vector = int Vector.vector
end

structure IntBSearch = BSearchFn (IntArray)

fun oratotis samiamidia =
  let
    fun parse file =
      let
        fun next_int input =
          Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        fun next_real input =
          Option.valOf (TextIO.inputLine input)

        val stream = TextIO.openIn file
        val n = next_int stream
        val _ = TextIO.inputLine stream

        fun scanner 0 acc acc2 = (acc, acc2)
          | scanner i acc acc2 =
          let
            val x1 = next_int stream
            val y1 = next_int stream
            val x2 = next_int stream
            val y2 = next_int stream
            val (SOME h) = Real.fromString (next_real stream)
          in
            scanner (i - 1) ((x1, x2, y1, h)::acc) (x1::(x1 + 1)::x2::(x2 + 1)::acc2)
          end
      in
        (n, (scanner n [] []))
      end

    (*http://rosettacode.org/wiki/Sorting_algorithms/Merge_sort#Standard_ML*)
    fun merge cmp ([], ys) = ys
      | 	merge cmp (xs, []) = xs
      |	merge cmp (xs as (x1, x2, y1, h)::xs', ys as (x1s, x2s, y1s, hs)::ys') =
        case cmp (y1, y1s) of GREATER => (x1s, x2s, y1s, hs) :: merge cmp (xs, ys')
      | _       => (x1, x2, y1, h) :: merge cmp (xs', ys)

    fun merge_sort cmp [] = []
      |	merge_sort cmp [(x1, x2, y1, h)] = [(x1, x2, y1, h)]
      |	merge_sort cmp xs =
      let
        val ys = List.take (xs, length xs div 2)
        val zs = List.drop (xs, length xs div 2)
      in
        merge cmp (merge_sort cmp ys, merge_sort cmp zs)
      end

    fun merge2 cmp ([], ys) = ys
      | merge2 cmp (xs, []) = xs
      | merge2 cmp (xs as x::xs', ys as y::ys') =
        case cmp (x, y) of GREATER => y :: merge2 cmp (xs, ys')
      | _       => x :: merge2 cmp (xs', ys)

    fun merge_sort2 cmp [] = []
      | merge_sort2 cmp [x] = [x]
      | merge_sort2 cmp xs = let
        val ys = List.take (xs, length xs div 2)
        val zs = List.drop (xs, length xs div 2)
      in
        merge2 cmp (merge_sort2 cmp ys, merge_sort2 cmp zs)
      end

    fun	remove_dup _ [] = []
      |	remove_dup [] acc = rev acc
      |	remove_dup (x::xs) (y::acc) =
        if x = y then remove_dup xs (y::acc)
        else remove_dup xs (x::y::acc)

    fun beer_fix i endx (ypsos:real) cnt dia hei =
      let
        val curx = Array.sub (dia, i)
        val curh = Array.sub (hei, i)
      in
        if curx >= endx then
          if cnt > 0 then true
          else false
        else
          if curh < ypsos then (Array.update (hei, i, ypsos); beer_fix (i + 1) endx ypsos (cnt + 1) dia hei)
          else beer_fix (i + 1) endx ypsos cnt dia hei
      end

    fun foo x dia = let val SOME (i, k) = IntBSearch.bsearch Int.compare (x, dia) in i end

    val (n, (a, b)) = parse samiamidia
    val dia2 = merge_sort2 Int.compare b
    val dia = Array.fromList (remove_dup (tl dia2) [hd dia2])
    val hei = Array.array (Array.length dia, 0.0)
    val ora = merge_sort Int.compare a
  in
    foldl (fn ((x1, x2, y1, h), c) => if beer_fix (foo x1 dia) x2 h 0 dia hei then (c + 1) else c) 0 ora
  end
