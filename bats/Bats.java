import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.PriorityQueue;


// http://keithschwarz.com/interesting/code/?dir=fibonacci-heap
public class Bats {
    static final int INFINITY = Integer.MAX_VALUE;
    static FibonacciHeap<Bats> que = new FibonacciHeap<Bats>();
    static LinkedList<Bats> pq = new LinkedList<Bats>();
    static boolean[][] wall = new boolean[1001][1001];
    static int k;
    public int x, y, node;
    public double cost, h, g;

    public Bats(int nx, int ny) {
        x = nx;
        y = ny;
    }

    public Bats(int nx, int ny, int num, double dist, double ng, double nh) {
        x = nx;
        y = ny;
        node = num;
        cost = dist;
        h = nh;
        g = ng;
    }

    // http://lifc.univ-fcomte.fr/home/~ededu/projects/bresenham/
    public static boolean useVisionLine(int y1, int x1, int y2, int x2) {
        int i;               // loop counter
        int ystep, xstep;    // the step on y and x axis
        int error;           // the error accumulated during the increment
        int errorprev;       // *vision the previous value of the error variable
        int y = y1, x = x1;  // the line points
        int ddy, ddx;        // compulsory variables: the double values of dy and dx
        int dx = x2 - x1;
        int dy = y2 - y1;

        // NB the last point can't be here, because of its previous point (which has to be verified)
        if (dy < 0) {
            ystep = -1;
            dy = -dy;
        }
        else
            ystep = 1;

        if (dx < 0) {
            xstep = -1;
            dx = -dx;
        }
        else
            xstep = 1;

        ddy = 2 * dy;  // work with double values for full precision
        ddx = 2 * dx;
        if (ddx >= ddy) {  // first octant (0 <= slope <= 1)
            // compulsory initialization (even for errorprev, needed when dx==dy)
            errorprev = error = dx;  // start in the middle of the square

            for (i = 0; i < dx; i++) {  // do not use the first point (already done)
                x += xstep;
                error += ddy;

                if (error > ddx) {  // increment y if AFTER the middle ( > )
                    y += ystep;
                    error -= ddx;

                    // three cases (octant == right->right-top for directions below):
                    if (error + errorprev < ddx) {
                        if (wall[y - ystep][x]) return false;
                    }
                    else if (error + errorprev > ddx) {
                        if (wall[y][x - xstep]) return false;
                    }
                    else {  // corner: bottom and left squares also
                        if (wall[y - ystep][x]) return false;
                        if (wall[y][x - xstep]) return false;
                    }
                }

                if (wall[y][x]) return false;
                errorprev = error;
            }
        }
        else {  // the same as above
            errorprev = error = dy;

            for (i = 0; i < dy; i++) {
                y += ystep;
                error += ddx;

                if (error > ddy) {
                    x += xstep;
                    error -= ddy;

                    if (error + errorprev < ddy) {
                        if (wall[y][x - xstep]) return false;
                    }
                    else if (error + errorprev > ddy) {
                        if (wall[y - ystep][x]) return false;
                    }
                    else {
                        if (wall[y][x - xstep]) return false;
                        if (wall[y - ystep][x]) return false;
                    }
                }

                if (wall[y][x]) return false;
                errorprev = error;
            }
        }

        return true;
    }

    /*
     * Find the shortest path across the graph using Dijkstra's algorithm.
    */
    static void dijkstra(Bats destination, int len) {
        Entry<Bats>[] entries = new Entry[len];
        Entry<Bats> kati;
        Iterator<Bats> eq;
        Bats current, check;
        int x1, y1;
        double distcurr, newdist;
        boolean[] visited = new boolean[len];

        while (true) {
            eq = pq.listIterator();
            kati = que.dequeueMin();
            current = kati.getValue();

            if ((current.x == destination.x) && (current.y == destination.y)) {
                System.out.println(Math.round(current.g * 100.0) / 100.0);
                System.exit(0);
            }
            distcurr = current.g;

            while (eq.hasNext()) {
                check = eq.next();

                if (!visited[check.node]) {
                    x1 = check.x - destination.x;
                    y1 = check.y - destination.y;
                    check.h = Math.sqrt(x1 * x1 + y1 * y1);
                }

                x1 = check.x - current.x;
                y1 = check.y - current.y;
                newdist = distcurr + (Math.sqrt(x1 * x1 + y1 * y1));

                if (newdist < check.g) {
                    if (useVisionLine (current.x, current.y, check.x, check.y)) {
                        check.g = newdist;
                        check.cost = newdist + check.h;

                        if (visited[check.node]) {
                            que.decreaseKey(entries[check.node], check.cost);
                        }
                        else {
                            entries[check.node] = que.enqueue(check, check.cost);
                            visited[check.node] = true;
                        }
                    }
                }
            }
        }
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        String line [] = br.readLine().split(" ");
        int N = Integer.parseInt(line[0]);
        int M = Integer.parseInt(line[1]);
        int K = Integer.parseInt(line[2]);
        int x, y, c = 1;

        line = br.readLine().split(" ");
        pq.add(new Bats(1, 1, 0, INFINITY, INFINITY, -1));

        for (int i = 1; i < K; i++) {
            line = br.readLine().split(" ");
            x = Integer.parseInt(line[0]);
            y = Integer.parseInt(line[1]);

            if (line[2].equals("B"))
                pq.add(new Bats(x + 1, y + 1, c++, INFINITY, INFINITY, -1));
            else if (line[2].equals("A"))
                que.enqueue(new Bats(x + 1, y + 1), 0.0);
            else
                wall[x + 1][y + 1] = true;
        }

        dijkstra(new Bats(1, 1), c);
        br.close();
    }
}
