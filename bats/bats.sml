(*http://rosettacode.org/wiki/Priority_queue#Standard_ML*)
structure TaskPriority = struct
  val compare = Real.compare
  type priority = real
  type item = int * int * real * real * real
  val priority : item -> real = #5
end

structure PQ = LeftPriorityQFn (TaskPriority);

fun bats fileName =
  let
    fun parse file =
      let
        (* a function to read an integer from an input stream *)
        fun next_int input =
          Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        (* a function to read a real that spans till the end of line *)
        fun next_char input =
          Option.valOf (TextIO.scanStream (Char.scan) input)
        (* open input file and read the two integers in the first line *)
        val stream = TextIO.openIn file
        val N = next_int stream
        val M = next_int stream
        val wall = Array2.array(N, M, false)
        val K = next_int stream
        val _ = TextIO.inputLine stream

        (* a function to read the pair of integer & real in subsequent lines *)
        fun scanner 0 acc openset = (acc, openset, wall)
          | scanner i acc openset =
          let
            val x = next_int stream
            val y = next_int stream
            val _ = next_char stream
            val z = next_char stream
            val _ = TextIO.inputLine stream
          in
            (* val posInf : real or val maxFinite : real *)
            if z = #"-" then
              let
                val _ = Array2.update (wall, x, y, true)
              in
                scanner (i - 1) acc openset
              end
            else
              if z = #"A" then
                scanner (i - 1) acc ((x, y, 0.0, Math.sqrt((real)(x * x) + (real)(y * y)), 0.0)::openset)
              else
                scanner (i - 1) ((x, y, Real.posInf, Math.sqrt((real)(x * x) + (real)(y * y)), Real.negInf)::acc) openset
          end
        in
          scanner K [] []
        end

    val input = parse fileName
    val wall = #3(input)
    val bats = #1(input)
    val openset = #2(input)

    (* http://lifc.univ-fcomte.fr/home/~ededu/projects/bresenham/ *)
    fun vision y1 x1 y2 x2 =
      let
        fun greater i error errorprev x y count ddx ddy xstep ystep =
          if i = count then true
          else
            if error + ddy > ddx then
              if error - ddx + ddy + errorprev < ddx then
                if Array2.sub(wall, y, x + xstep) orelse Array2.sub(wall, y + ystep, x + xstep) then false
                else greater (i + 1) (error + ddy - ddx) (error + ddy-ddx) (x + xstep) (y + ystep) count ddx ddy xstep ystep
              else
                if error + ddy - ddx + errorprev > ddx then
                  if Array2.sub(wall, y + ystep, x) orelse Array2.sub(wall, y + ystep, x + xstep) then false
                  else greater (i + 1) (error + ddy - ddx) (error + ddy-ddx) (x + xstep) (y + ystep) count ddx ddy xstep ystep
                else
                  if Array2.sub(wall, y, x + xstep) orelse Array2.sub(wall, y + ystep, x) orelse Array2.sub(wall, y + ystep, x + xstep) then false
                  else greater (i + 1) (error + ddy - ddx) (error + ddy - ddx) (x + xstep) (y + ystep) count ddx ddy xstep ystep
            else
              if Array2.sub(wall, y, x + xstep) then false
              else greater (i + 1) (error + ddy) (error + ddy) (x + xstep) y count ddx ddy xstep ystep

        fun greater2 i error errorprev x y count ddx ddy xstep ystep =
          if i = count then true
          else
            if error + ddy > ddx then
              if error - ddx + ddy + errorprev < ddx then
                if Array2.sub(wall, x + xstep, y) orelse Array2.sub(wall, x + xstep, y + ystep) then false
                else greater2 (i + 1) (error + ddy - ddx) (error + ddy - ddx) (x + xstep) (y + ystep) count ddx ddy xstep ystep
              else
                if error + ddy - ddx + errorprev > ddx then
                  if Array2.sub(wall, x, y + ystep) orelse Array2.sub(wall, x + xstep, y + ystep) then false
                  else greater2 (i + 1) (error + ddy - ddx) (error + ddy - ddx) (x + xstep) (y + ystep) count ddx ddy xstep ystep
                else
                  if Array2.sub(wall, x + xstep, y) orelse Array2.sub(wall, x, y + ystep) orelse Array2.sub(wall, x + xstep, y + ystep) then false
                  else greater2 (i + 1) (error + ddy - ddx) (error + ddy - ddx) (x + xstep) (y + ystep) count ddx ddy xstep ystep
            else
              if Array2.sub(wall, x + xstep, y) then false
              else greater2 (i + 1) (error + ddy) (error + ddy) (x + xstep) y count ddx ddy xstep ystep

        val (xstep1, dx) = if x2 - x1 < 0 then (~1, x1 - x2) else (1, x2 - x1)
        val (ystep1, dy) = if y2 - y1 < 0 then (~1, y1 - y2) else (1, y2 - y1)
        val ddx1 = 2 * dx
        val ddy1 = 2 * dy
        val result =
          if ddx1 >= ddy1 then
            greater 0 dx dx x1 y1 dx ddx1 ddy1 xstep1 ystep1
          else
            greater2 0 dy dy y1 x1 dy ddy1 ddx1 ystep1 xstep1
      in
        result
      end

    fun astar nyxt queue =
      let
        fun aux pq' =
          case PQ.next pq' of
            NONE => ((1, 1, 0.0, 0.0, 0.0), PQ.empty)
          | SOME ((x, y, g, h, prio), pq'') => ((x, y, g, h, prio), pq'')

        val (mx, my, mg, mh, mf) = #1(aux queue)

        fun foo ((x, y, g, h, f), (ls, ks)) =
          let
            val x1 = x - mx;
            val y1 = y - my;
            val newdist = mg + (Math.sqrt((real)(x1 * x1) + (real)(y1 * y1)))
          in
            if x = mx andalso y = my then
              (ls, ks)
            else
              if newdist < g then
                if vision mx my x y then
                  ((x, y, newdist, h, (~1.0) * (newdist + h))::ls, (x, y, newdist, h, (~1.0) * (newdist + h))::ks)
                else
                  if f > Real.negInf then
                    ((x, y, g, h, f)::ls, (x, y, g, h, f)::ks)
                  else
                    ((x, y, g, h, f)::ls, ks)
              else
                if f > Real.negInf then
                  ((x, y, g, h, f)::ls, (x, y, g, h, f)::ks)
                else
                  ((x, y, g, h, f)::ls, ks)
          end

        val (newnyxt, newpq) = foldr foo ([], []) nyxt
      in
        if mx = 0 andalso my = 0 then
          Real.realRound(mg * 100.0) / 100.0
        else
          astar newnyxt (foldl PQ.insert PQ.empty newpq)
      end
  in
    astar bats (foldl PQ.insert PQ.empty openset)
  end
