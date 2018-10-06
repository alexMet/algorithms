fun kouvadakia v1 v2 vg =
	let

		fun gcd a 0 = a
			| gcd a b = gcd b (a mod b)

		fun expandLeft (0, cur2, moves1) =
				if v1 > cur2 then
					(cur2, 0, "-21"::moves1)
				else
					(v1, cur2 - v1, "-21"::moves1)
			| expandLeft (cur1, 0, moves1) = (cur1, v2, "-02"::moves1)
			| expandLeft (cur1, cur2, moves1) =
				if cur1 = v1 then
					(0, cur2, "-10"::moves1)
				else
					if (cur1 + cur2) > v1 then
						(v1, cur2 - (v1 - cur1), "-21"::moves1)
					else
						(cur1 + cur2, 0, "-21"::moves1)

		fun expandRight (0, cur4, moves2) =	(v1, cur4, "-01"::moves2)
			| expandRight (cur3, 0, moves2) =
				if v2 > cur3 then
					(0, cur3, "-12"::moves2)
				else
					(cur3 - v2, v2, "-12"::moves2)
			| expandRight (cur3, cur4, moves2) =
				if cur4 = v2 then
					(cur3, 0, "-20"::moves2)
				else
					if (cur3 + cur4) > v2 then
						(cur3 - (v2 - cur4), v2, "-12"::moves2)
					else
						(0, cur3 + cur4, "-12"::moves2)

		fun loop (x1, y1, move1) (x2, y2, move2) =
			if x1 = vg orelse y1 = vg then
				String.concat (rev move1)
			else
				if x2 = vg orelse y2 = vg then
					String.concat (rev move2)
				else
					loop (expandLeft (x1, y1, move1)) (expandRight (x2, y2, move2))
	in
		if vg > v1 andalso vg > v2 then
			"impossible"
		else
			if v1 = vg then
				"01"
			else
				if v2 = vg then
					"02"
				else
					if vg mod (gcd v1 v2) = 0 then
						loop (expandLeft (0, v2, ["02"])) (expandRight (v1, 0, ["01"]))
					else
						"impossible"
	end
