#include <stdio.h>
#include <stdlib.h>

static int place[500000], d[500000];
static long double t[500000];
static float v[500000];


// http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#C
void quick_sort (long double *a, int *b, int n) {
  if (n < 2) return;

  long double p = a[n / 2];
  long double *l = a;
  int *l2 = b;
  long double *r = a + n - 1;
  int *r2 = b + n - 1;

  while (l <= r) {
    if (*l - p < 0.0) {
      l++;
      l2++;
      continue;
    }
    // we need to check the condition (l <= r)
    // every time we change the value of l or r
    if (p - *r < 0.0) {
      r--;
      r2--;
      continue;
    }

    long double t = *l;
    int t2 = *l2;

    *l++ = *r;
    *l2++ = *r2;
    *r-- = t;
    *r2-- = t2;
  }

  quick_sort(a, b, r - a + 1);
  quick_sort(l, l2, a + n - l);
}

int main(int argc, char **argv) {
	FILE *fd;
	int n, l, i, j, dist;
	long double temp;

	fd = fopen(argv[1], "r");
	if (fd == NULL) {
		fprintf(stderr, "Failed to open file\n");
		exit(1);
	}

	if ((fscanf(fd, "%d %d", &n, &l)) != 2) {
		fprintf(stderr,"Failed to read\n");
		exit(1);
	}

	for (i = 0; i < n; i++) {
		if ((fscanf(fd, "%d %f", &d[i], &v[i])) != 2) {
			fprintf(stderr,"Failed to read\n");
			exit(1);
		}
		place[i] = i + 1;
		t[i] = -1.0L;
	}

	fclose(fd);

	for (i = 0; i < n; i++) {
		j = (i + 1) % n;

		while (v[j] < v[i]) {
			if (d[j] > d[i]) dist = d[j] - d[i];
			else dist = l - d[i] + d[j];
			temp =  ((long double) dist) / (v[i] - v[j]);
			if ((t[j] < 0) || (temp < t[j])) t[j] = temp;
			j = (j + 1) % n;
		}
	}

	quick_sort(t, place, n);

	for (i = 0; i < n - 1; i++) {
		if (t[i] < 0) continue;
		else printf("%d ", place[i]);
	}
	printf("%d\n", place[n-1]);

	return 0;
}
