public class Kouvadakia {
	public static int v1, v2, vg;
	private int cur1, cur2;
	private String moves;

	public Kouvadakia(int x, int y, String newM) {
		cur1 = x;
		cur2 = y;
		moves = newM;
	}

	public void setCur(int x, int y, String newM) {
		cur1 = x;
		cur2 = y;
		moves += newM;
	}

	public static int gcd(int a,int b) {
		if (b == 0)
			return a;
		else
			return gcd(b, a % b);
	}

	public void expandLeft() {
		if (cur1 == 0) {
			if (v1 > cur2)
				setCur(cur2, 0, "-21");
			else
				setCur(v1, cur2 - v1, "-21");
		}
		else if (cur2 == 0) {
			setCur(cur1, v2, "-02");
		}
		else {
			if (cur1 == v1)
				setCur(0, cur2, "-10");
			else {
				if ((cur1 + cur2) > v1)
					setCur(v1, cur2 - (v1 - cur1), "-21");
				else
					setCur(cur1 + cur2, 0, "-21");
			}
		}
	}

	public void expandRight() {
		if (cur1 == 0) {
			setCur(v1, cur2, "-01");
		}
		else if (cur2 == 0) {
			if (v2 > cur1)
				setCur(0, cur1, "-12");
			else
				setCur(cur1 - v2, v2, "-12");
		}
		else {
			if (cur2 == v2)
				setCur(cur1, 0, "-20");
			else {
				if ((cur1 + cur2) > v2)
					setCur(cur1 - (v2 - cur2), v2, "-12");
				else
					setCur(0, cur1 + cur2, "-12");
			}
		}
	}

	public void check() {
		if (this.cur1 == vg || this.cur2 == vg) {
			System.out.println(moves);
			System.exit(0);
		}
	}

	public static void main(String[] args) {
	  if (args.length != 3) {
	  	System.err.println("usage: UseArgv number");
	  	System.exit(1);
	  }

	  v1 = Integer.parseInt(args[0].trim());
	  v2 = Integer.parseInt(args[1].trim());
	  vg = Integer.parseInt(args[2].trim());

	  if (((vg % gcd(v1, v2)) != 0) || ((vg > v1) && (vg > v2))) {
	  	System.out.println("impossible");
			System.exit(0);
	  }
	  if (v1 == vg) {
	  	System.out.println("01");
			System.exit(0);
	  }
	  if (v2 == vg) {
	  	System.out.println("02");
			System.exit(0);
	  }

	  Kouvadakia state1 = new Kouvadakia(0, v2, "02");
	  Kouvadakia state2 = new Kouvadakia(v1, 0, "01");

	  while (true) {
	  	state1.expandLeft();
			state1.check();
	  	state2.expandRight();
			state2.check();
	  }
	}
}
