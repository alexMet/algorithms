fun dromoi fileName =
  let
    fun check length _ distance _ telos [] = if (length - telos) > distance then 0 else 1
      | check length stop distance begin telos ((beg, endi, day)::xs) =
        if day > stop then
          check length stop distance begin telos xs
        else
          let
            val keno = if beg > telos then beg - telos else 0
            val new_begin = if keno > 0 then beg else begin
            val new_end = if endi > telos then endi else telos

            val recursion =
              if keno > distance then 0
              else
                if length-new_end <= distance then 1
                else check length stop distance new_begin new_end xs
          in
            recursion
          end

    (* http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#C *)
    fun quicksort [] = []
      | quicksort ((x, z, s)::xs) =
      let
        val (left, right) = List.partition (fn (a, b, c) => a < x) xs
      in
        quicksort left @ [(x, z, s)] @ quicksort right
      end

    fun binary ans n l x low high xs =
      let
        val some =
          if low > high then
            if ans = ~1 then ans
            else ans + 1
          else
            if (check l ((low + high) div 2) x 0 0 xs) = 1 then
              binary ((low + high) div 2) n l x low (((low + high) div 2) - 1)
            else
              binary ans n l x (((low + high) div 2) + 1) high xs
      in
        some
      end

    fun parse file =
      let
        (* a function to read an integer from an input stream *)
        fun next_int input =
          Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        (* open input file and read the two integers in the first line *)
        val stream = TextIO.openIn file
        val n = next_int stream
        val l = next_int stream
        val x = next_int stream
        val _ = TextIO.inputLine stream
        (* a function to read the pair of integer & real in subsequent lines *)
        fun scanner 0 _ acc = acc
          | scanner i k acc =
          let
            val here = next_int stream
            val there = next_int stream
          in
            scanner (i - 1) (k + 1) ((here, there, k) :: acc)
          end
      in
        (n, l, x, rev(scanner n 0 []))
      end

    (* A dummy solver and the function with the requested interface below *)
    fun my_solution (n, l, x, candidates) = if l <= x then 0 else binary (~1) n l x 0 (n - 1) (quicksort candidates)
  in
    my_solution (parse fileName)
  end
