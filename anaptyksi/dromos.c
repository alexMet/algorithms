#include <stdio.h>
#include <stdlib.h>

static int beg[1000000], end[1000000], days[1000000];
int n;


// http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#C
void quick_sort (int *a, int *b, int *c, int n) {
  if (n < 2) return;

  int p = a[n / 2];
  int *l = a, *l2 = b, *l3 = c;
  int *r = a + n - 1, *r2 = b + n - 1, *r3 = c + n - 1;

  while (l <= r) {
    if (*l < p) {
      l++;
      l2++;
      l3++;
      continue;
    }
    // we need to check the condition (l <= r)
    // every time we change the value of l or r
    if (*r > p) {
      r--;
      r2--;
      r3--;
      continue;
    }
    int t = *l, t2 = *l2, t3 = *l3;

    *l++ = *r;
    *l2++ = *r2;
    *l3++ = *r3;
    *r-- = t;
    *r2-- = t2;
    *r3-- = t3;
  }

  quick_sort(a, b, c, r - a + 1);
  quick_sort(l, l2, l3, a + n - l);
}


int search(int *x, int *x2, int *x3, int stop, int this, int length) {
	int i, begin, temp = 0;

	while (x3[temp] > stop) temp++;

	if (x[temp] > this) return 0;
	begin = x2[temp];

	for (i = temp + 1; i < n; i++) {
		if (x3[i] > stop) continue;

		if (x[i] <= begin) {
			if (x2[i] > begin) begin = x2[i];
		}
		else {
			if (x[i] - begin > this) return 0;
			begin = x2[i];
		}

		if (length - begin <= this) return 1;
	}
	if (length - begin > this) return 0;

	return 1;
}


int binary(int low, int high, int target, int length) {
	int ans = -1, mid, temp;

	while (low <= high) {
		mid = (low + high) / 2;

		temp = search(beg, end, days, mid, target, length);

		if (temp) {
			ans = mid;
			high = mid - 1;
		}
		else {
			low = mid + 1;
		}
	}
	return ans;
}


int main(int argc, char **argv) {
	FILE *fd;
	int l, x, i, day;

	fd = fopen(argv[1], "r");
	if (fd == NULL) {
		fprintf(stderr, "File not found\n");
		exit(1);
	}

	if (fscanf(fd, "%d %d %d", &n, &l, &x) != 3) {
		fprintf(stderr, "Failed to read from file\n");
		exit(1);
	}

	if (l <= x) {
		printf("0\n");
		return 0;
	}

	for (i = 0; i < n; i++) {
		if (fscanf(fd, "%d %d", &beg[i], &end[i]) != 2) {
			fprintf(stderr, "Failed to read from file\n");
			exit(1);
		}

		days[i] = i;
	}

	quick_sort(beg, end, days, n);

	if ((day = binary(0, n - 1, x, l)) != -1) day++;
	printf("%d\n", day);

  fclose(fd);
	return 0;
}
