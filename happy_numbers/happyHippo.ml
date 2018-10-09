let happy = [|false;
	true; false; false; false; false; false; true; false; false; true; false; false; true; false; false; false; false; false; true; false;
	false; false; true; false; false; false; false; true; false; false; true; true; false; false; false; false; false; false; false; false;
	false; false; false; true; false; false; false; false; true; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; false; true; false; true; false; false; false; false; false; false; false; false; true; false;
	false; true; false; false; false; true; false; false; false; false; true; false; false; true; false; false; true; false; false; true;
	false; false; true; false; false; false; false; false; true; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; false; false; true; true; false; false; true; false; false; false; false; false; true; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; true; false; false; false; false; false; false; false; false; true; false; false; false; false;
	false; false; false; false; false; false; false; true; false; true; false; true; true; false; false; false; false; false; false; false;
	false; false; true; false; false; false; false; true; false; false; false; false; false; false; false; false; false; false; true; false;
	false; false; false; false; false; true; false; false; false; true; false; false; false; false; false; true; false; false; true; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false;
	false; true; true; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; true;
	false; false; false; false; false; false; false; false; false; false; true; false; true; false; false; false; false; false; false; false;
	true; true; false; false; false; false; false; false; false; true; false; false; true; false; false; false; false; false; true; true;
	false; false; false; false; false; true; false; false; true; false; true; false; false; false; false; false; false; true; false; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; true; false; false; false; false;
	false; true; false; false; true; false; true; true; false; false; false; false; false; false; false; true; false; false; true; false;
	false; false; true; false; false; true; false; false; false; false; true; true; false; false; false; false; true; false; false; false;
	false; false; false; true; false; false; false; false; true; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; true;
	false; false; false; false; false; true; false; false; false; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; true; false; false; false; false; true; false; false; false; false; false; false; false; false; true; false; false;
	false; false; false; false; false; false; true; false; false; true; false; false; false; false; false; true; false; false; false; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; true; false; false; false; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; true; false; false; false; false;
	false; false; true; false; true; true; false; false; false; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false; false;
	false; false; false; false; false; false; false; true; false; false; false; false; false; false; false; false; true; false; false; false;
	false; true; true; false; false; false; false; false; false; false; false; true; false; false; true; false; true; true; false; false;
	false; false; false; true; false; false; false; false; true; false; false; false; true; false; true; true; false; false; false; false;
	false; false; false; false; true; false; false; false; false; false; true; false; true; false; false; false; false; false; false; true;
	false; false; true; false; false; false; false; false; false; false; false; false; false; true; false; false; false; false; false; true;
	false; false; false; false; false; false; false; false; true; false; false; false; false; false; false; true; false; false; false; false;
	false; false; false; false; false; false; false; false; false; |];;

let sums = Array.make 100000 0;;

let rec sum_of_digits num sum =
  if num == 0 then sum
  else
    let digit = num mod 10 in
      sum_of_digits (num / 10) (sum + (digit*digit))
;;

let initari =
  for i = 0 to 99999 do
    sums.(i) <- sum_of_digits i 0
  done;
;;

let calc dl dr ul ur =
  let sum = ref 0 in
    if dl == ul then
      begin
        for i = dr to ur do
          if happy.(sums.(dl) + sums.(i)) then incr sum
        done;
      end
    else
      begin
        for i = dr to 99999 do
          if happy.(sums.(dl) + sums.(i)) then incr sum
          done;
        for i = (dl+1) to (ul-1) do
          for j = 0 to 99999 do
            if happy.(sums.(i) + sums.(j)) then incr sum
          done;
        done;
        for i = 0 to ur do
          if happy.(sums.(ul) + sums.(i)) then incr sum
        done;
    end;
  !sum
;;

let cat filename =
  let chan = open_in filename in
    let rd() = Scanf.fscanf chan " %d " (fun a->a) in
      let down = rd() in
        let up = rd() in
          close_in chan;
          print_int(calc (down / 100000) (down mod 100000) (up / 100000) (up mod 100000));
          print_string("\n");
          ()
;;

let main () =
  initari;
  cat Sys.argv.(1);
;;

let _ = main();;
