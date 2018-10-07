#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_N 500000
#define EPSILON 0.000001L       // this looks fine

long long int N, L;
long long int start_pos[MAX_N];
long double velocity[MAX_N];
long long int previous[MAX_N];
long long int next[MAX_N];

int main(int argc, char *argv[]) {

    if (argc != 3) {
        fprintf(stderr, "Usage: ./validator <input-file> <output-file>\n");
        exit(1);
    }

    long long int i, maxc = 0;
    long double maxv = 0;
    FILE *in, *out;


    // read the testcase
    in = fopen(argv[1], "r");
    fscanf(in, "%lld %lld", &N, &L);
    for (i=0; i<N; i++) {
        fscanf(in, "%lld %Lf", &start_pos[i], &velocity[i]);
        if ( velocity[i] > 5 || velocity[i] == 0 ) {
            fprintf(stderr, "Wrong input. Runner %lld is running with speed %.2Lf\n", i+1, velocity[i]);
            exit(1);
        }
        if ( velocity[i] > maxv ) {
            maxv = velocity[i];
            maxc = 1;
        }
        else if ( velocity[i] == maxv )
            maxc++;
    }
    fclose(in);


    // initialize helper arrays
    previous[0] = N-1;
    for (i=1; i<N; i++) {
        previous[i] = i-1;
        next[i-1] = i;
    }
    next[N-1] = 0;


    // count eliminators and eliminated from the "solution" file
    long long int eliminated, outc = 0;
    out = fopen(argv[2], "r");
    while ( fscanf(out, "%lld", &eliminated) == 1 ) outc++;
    if ( outc != N - maxc ) {
        fprintf(stderr, "Validation failed.\n");
        fprintf(stderr, "There are %lld runners with speed %.2Lf\n", maxc, maxv);
        fprintf(stderr, "And %lld runners out of %lld were eliminated\n", outc, N);
        exit(1);
    }
    fclose(out);


    // check "solution" for valid overtakings
    long long int eliminator, distance;
    long double time_of_elimination, time_of_last_elimination;
    int alpha;

    out = fopen(argv[2], "r");
    time_of_last_elimination = 0;
    while ( fscanf(out, "%lld ", &eliminated) == 1 ) {
        eliminated--;   // zero-based array indexing
        eliminator = previous[eliminated];
        distance = start_pos[eliminated] - start_pos[eliminator];
        if ( distance <= 0 ) distance += L;
        time_of_elimination = ( (long double) distance ) / ( velocity[eliminator] - velocity[eliminated] );

        alpha = time_of_elimination < time_of_last_elimination - EPSILON;
        if ( alpha ) {
            fprintf(stderr, "Validation failed.\n");
            fprintf(stderr, "%lld to kill %lld\n", eliminator+1, eliminated+1);
            fprintf(stderr, "eliminator : (%lld,%.2Lf)\n", start_pos[eliminator], velocity[eliminator]);
            fprintf(stderr, "eliminated : (%lld,%.2Lf)\n", start_pos[eliminated], velocity[eliminated]);
            fprintf(stderr, "%.15Lf <-- time of elimination\n", time_of_elimination);
            fprintf(stderr, "%.15Lf <-- time of last elimination\n", time_of_last_elimination);
            fprintf(stderr, "%.15Lf <-- time diff\n", time_of_elimination - time_of_last_elimination);
            fprintf(stderr, "%.15Lf <-- Precision\n", EPSILON);
            exit(1);
        }

        time_of_last_elimination = time_of_elimination;

        next[eliminator] = next[eliminated];
        previous[ next[eliminator] ] = eliminator;
    }
    fclose(out);

    return 0;
}
