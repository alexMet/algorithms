import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedList;

public class Oratotis {
  public static LinkedList<Oratotis> tispi = new LinkedList<Oratotis>();
  public static LinkedList<Diasthmata> diast = new LinkedList<Diasthmata>();
  public static int countBuilding;
  public int x1, x2, y1;
  public double h;

  public Oratotis (int xe, int xs, int ye, double hei) {
    x1 = xe;
    x2 = xs;
    y1 = ye;
    h = hei;
  }

  // http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Java
  static int partition(Oratotis arr[], int left, int right) {
    int i = left, j = right;
    Oratotis tmp;
    int pivot = arr[(left + right) / 2].y1;

    while (i <= j) {
      while (arr[i].y1 < pivot)
        i++;

      while (arr[j].y1 > pivot)
        j--;

      if (i <= j) {
        tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
        i++;
        j--;
      }
    }

    return i;
  }

  static void quickSort(Oratotis arr[], int left, int right) {
    int index = partition(arr, left, right);

    if (left < index - 1)
      quickSort(arr, left, index - 1);

    if (index < right)
      quickSort(arr, index, right);
  }

  static int partition(Diasthmata arr[], int left, int right) {
    int i = left, j = right;
    Diasthmata tmp;
    int pivot = arr[(left + right) / 2].xi;

    while (i <= j) {
      while (arr[i].xi < pivot)
        i++;

      while (arr[j].xi > pivot)
        j--;

      if (i <= j) {
        tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
        i++;
        j--;
      }
    }

    return i;
  }

  static void quickSort(Diasthmata arr[], int left, int right) {
    int index = partition(arr, left, right);

    if (left < index - 1)
      quickSort(arr, left, index - 1);

    if (index < right)
      quickSort(arr, index, right);
  }

  // http://rosettacode.org/wiki/Binary_search#Java
  public static int binary (Diasthmata[] nums, int check, int n) {
    int hi = n - 1;
    int lo = 0;

    while(hi >= lo) {
      int guess = lo + ((hi - lo) / 2);

      if (nums[guess].xi > check)
        hi = guess - 1;
      else if (nums[guess].xi < check)
        lo = guess + 1;
      else
        return guess;
    }

    return -1;
  }

  public static void main(String[] args) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(args[0]));
    int xe, ye, xs;
    double hei;
    String line [] = br.readLine().split(" ");
    int N = Integer.parseInt(line[0]);
    Oratotis[] ora = new Oratotis[N];

    for (int i = 0; i < N; i++) {
      line = br.readLine().split(" ");
      xe = Integer.parseInt(line[0]);
      ye = Integer.parseInt(line[1]);
      xs = Integer.parseInt(line[2]);
      hei = Double.parseDouble(line[4]);

      ora[i] = new Oratotis(xe, xs, ye, hei);
      diast.add(new Diasthmata(xe, 0.0));
      diast.add(new Diasthmata(xe + 1, 0.0));
      diast.add(new Diasthmata(xs, 0.0));
      diast.add(new Diasthmata(xs + 1, 0.0));
    }
    br.close();

    Diasthmata[] dia = diast.toArray(new Diasthmata[diast.size()]);
    quickSort(ora, 0, N - 1);
    quickSort(dia, 0, diast.size() - 1);

    int ld = diast.size();
    int ls = N;
    int poio, apo, mexri;
    double ypsos;
    boolean toEida;

    int g = 0, p = 0;
    while (p < ld) {
      dia[g].xi = dia[p].xi;
      while (p < ld && dia[g].xi == dia[p].xi) p++;
      g++;
    }

    ld = g;
    countBuilding = 0;

    for (int i = 0; i < ls; i++) {
      apo = ora[i].x1;
      mexri = ora[i].x2;
      ypsos = ora[i].h;
      toEida = true;

      poio = binary(dia, apo, ld);

      for (int j = poio; j < ld; j++) {
        if (dia[j].xi >= mexri) break;

        if (ypsos > dia[j].hi) {
          dia[j].hi = ypsos;
          
          if (toEida) {
            countBuilding++;
            toEida = false;
          }
        }
      }
    }

    System.out.println(countBuilding);
  }
}
