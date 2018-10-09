fun agonas fileName =
  let
    fun parse file =
      let
        (* a function to read an integer from an input stream *)
        fun next_int input =
          Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        (* a function to read a real that spans till the end of line *)
        fun next_real input =
          Option.valOf (TextIO.inputLine input)
        (* open input file and read the two integers in the first line *)
        val stream = TextIO.openIn file
        val n = next_int stream
        val l = next_int stream
        val _ = TextIO.inputLine stream
        (* a function to read the pair of integer & real in subsequent lines *)
        fun scanner 0 acc _ = acc
          | scanner i acc num =
          let
            val d = Real.fromInt (next_int stream)
            val (SOME v) = Real.fromString (next_real stream)
          in
            scanner (i - 1) ((d, v, 500000001.0, num) :: acc) (num + 1)
          end
      in
        (n, l,  rev(scanner n [] 1))
      end

    fun my_solution (n, l, candidates) =
      let
        val arr = Array.fromList candidates

        fun solution i =
          let
            val current = Array.sub(arr, i)
            val x1 = #1 current
            val u1 = #2 current

            fun search j = if j > n - 1 then search 0 else
              let
                val x2 = #1 (Array.sub(arr, j))
                val u2 = #2 (Array.sub(arr, j))
                val t2 = #3 (Array.sub(arr, j))
                val num2 = #4 (Array.sub(arr, j))
                val length = Real.fromInt l
                val distance = if x1 > x2 then length - x1 + x2 else x2 - x1
                val t = if u1 > u2 then distance / (u1 - u2) else t2
                val _ = if t < t2 then Array.update(arr, j, (x2, u2, t, num2)) else Array.update(arr, j, (x2, u2, t2, num2))
                (*(if u1>u2 then Array.update(arr,j,(x2,u2,t)) else Array.update(arr,j,(x2,u2,t2)))*)
                val ret = if u1 > u2 then search (j + 1) else 0
              in
                ret
              end

            val _ = search (i + 1)
            val ret1 = if i < n - 1 then solution (i + 1) else 0
          in
            ret1
          end

        val _ = solution 0

        fun arr_to_list acc pos = if pos > n - 1 then rev acc else
          let
            val a = Array.sub(arr, pos)
          in
            arr_to_list (a :: acc) (pos + 1)
          end

        (* http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#C *)
        fun quicksort [] = []
          | quicksort ((x, z, s, num)::xs) =
          let
            val (left, right) = List.partition (fn (a, b, c, n) => c < s) xs
          in
            quicksort left @ [(x, z, s, num)] @ quicksort right
          end

        fun print [] acc = rev acc
          | print ((x, y, z, w)::xs) acc = if z > 500000000.5 then rev acc else print xs (w::acc)

        val dwse = print(quicksort (arr_to_list [] 0)) []
      in
        dwse
      end
  in
    my_solution (parse fileName)
  end
