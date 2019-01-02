import java.util.HashSet;
import java.util.LinkedList;


public class Diapragmateysi {
  public Diapragmateysi parent;
	public String state;
	public int moves;

	public static LinkedList<Diapragmateysi> Flist1 = new LinkedList<Diapragmateysi>();
	public static LinkedList<Diapragmateysi> Blist1 = new LinkedList<Diapragmateysi>();
	public static HashSet<Diapragmateysi> hashF = new HashSet<Diapragmateysi>();
	public static HashSet<Diapragmateysi> hashB = new HashSet<Diapragmateysi>();
	public static LinkedList<Diapragmateysi> Flist2 = new LinkedList<Diapragmateysi>();
	public static LinkedList<Diapragmateysi> Blist2 = new LinkedList<Diapragmateysi>();

	public static Diapragmateysi answer;
	public static boolean forw;

	public Diapragmateysi(String s, int m, Diapragmateysi p) {
		state = s;
		moves = m;
		parent = p;
	}

	public static void addState (HashSet<Diapragmateysi> hash1, LinkedList<Diapragmateysi> list, Diapragmateysi d) {
		if (!hash1.contains(d)) {
			list.add(d);
			hash1.add(d);
		}
	}

	public static void bfs(Diapragmateysi som, HashSet<Diapragmateysi> set1, LinkedList<Diapragmateysi> listo) {
		String state1, state2, state3, state4;

		if (forw) {
			state1 = som.state.charAt(2) + "" + som.state.charAt(1) + "" + som.state.charAt(5) + "" +
						som.state.charAt(0) + "" + som.state.charAt(4) + "" + som.state.charAt(3) + som.state.substring(6, 12);

			state2 = som.state.charAt(0) + "" + som.state.charAt(3) + "" + som.state.charAt(2) + "" +
						som.state.charAt(6) + "" + som.state.charAt(1) + "" + som.state.charAt(5) + "" +
						som.state.charAt(4) + som.state.substring(7, 12);

			state3 = som.state.substring(0, 5) + som.state.charAt(7) + "" + som.state.charAt(6) + "" +
						som.state.charAt(10) + "" + som.state.charAt(5) + "" + som.state.charAt(9) + "" +
						som.state.charAt(8) + "" + som.state.charAt(11);

			state4 = som.state.substring(0, 6) + som.state.charAt(8) + "" + som.state.charAt(7) + "" +
						som.state.charAt(11) + "" + som.state.charAt(6) + "" + som.state.charAt(10) + "" +
						som.state.charAt(9);
		}
		else {
			state1 = som.state.charAt(3) + "" + som.state.charAt(1) + "" + som.state.charAt(0) + "" +
						som.state.charAt(5) + "" + som.state.charAt(4) + "" + som.state.charAt(2) + som.state.substring(6, 12);

			state2 = som.state.charAt(0) + "" + som.state.charAt(4) + "" + som.state.charAt(2) + "" +
						som.state.charAt(1) + "" + som.state.charAt(6) + "" + som.state.charAt(5) + "" +
						som.state.charAt(3) + som.state.substring(7, 12);

			state3 = som.state.substring(0, 5) + som.state.charAt(8) + "" + som.state.charAt(6) + "" +
						som.state.charAt(5) + "" + som.state.charAt(10) + "" + som.state.charAt(9) + "" +
						som.state.charAt(7) + "" + som.state.charAt(11);

			state4 = som.state.substring(0, 6) + som.state.charAt(9) + "" + som.state.charAt(7) + "" +
						som.state.charAt(6) + "" + som.state.charAt(11) + "" + som.state.charAt(10) + "" +
						som.state.charAt(8);
		}

		addState(set1, listo, new Diapragmateysi(state1, 1, som));
		addState(set1, listo, new Diapragmateysi(state2, 2, som));
		addState(set1, listo, new Diapragmateysi(state3, 3, som));
		addState(set1, listo, new Diapragmateysi(state4, 4, som));
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.state == null) ? 0 : this.state.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null) return false;
		if (getClass() != obj.getClass()) return false;
		Diapragmateysi other = (Diapragmateysi) obj;
		if (state.equals(other.state)) {
			answer = other;
			return true;
		}
		return false;
	}

	public static void show(Diapragmateysi ans) {
    Diapragmateysi cur = ans;
		String a = "";

		while (cur.parent != null) {
			a = cur.moves + a;
			cur = cur.parent;
		}

		System.out.print(a);
	}

	public static void show_rev(Diapragmateysi ans) {
    Diapragmateysi cur = ans;
		String a = "";

		while (cur.parent != null) {
			a = a + cur.moves;
			cur = cur.parent;
		}

		System.out.print(a);
	}

	public static void main(String[] args) {
		LinkedList<Diapragmateysi> tmp;
		Diapragmateysi cur, cur2;

		if (args.length != 1) {
			System.out.println("Usage: java Node string_to_solve");
			System.exit(1);
		}

		cur = new Diapragmateysi(args[0], 9, null);
		Flist1.add(cur);
		hashF.add(cur);

		cur2 = new Diapragmateysi("bgbGgGGrGyry", 10, null);
		Blist1.add(cur2);
		hashB.add(cur2);

		if (cur.state.equals("bgbGgGGrGyry")) {
			System.out.println("");
			System.exit(0);
		}

		while (true) {
			forw = true;
			if (Flist1.isEmpty()) {
				tmp = Flist1;
				Flist1 = Flist2;
				Flist2 = tmp;
			}

			cur = Flist1.remove();
			if (hashB.contains(cur)) {
				show(cur);
				show_rev(answer);
				System.out.print("\n");
				System.exit(0);
			}
			bfs(cur, hashF, Flist2);

			forw = false;
			if (Blist1.isEmpty()) {
				tmp = Blist1;
				Blist1 = Blist2;
				Blist2 = tmp;
			}

			cur = Blist1.remove();
			if (hashF.contains(cur)) {
				show(answer);
				show_rev(cur);
				System.out.print("\n");
				System.exit(0);
			}
			bfs(cur, hashB, Blist2);
		}
	}
}
