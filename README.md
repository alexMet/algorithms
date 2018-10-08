# programming-languages-shmmy
My solutions for some algorithms, using multiple programming languages.

## C
```sh
gcc –std=c99 -Wall –Werror -O3 program.c -o el
```
## SML
- Priority queue
- A* algorithm
- Bresenham algorithm
```sh
sml program.sml
```
## JAVA
- Fibonacci Heap
- Dijkstra
- Bresenham algorithm
```sh
javac Program.java
```
## Prolog
- Binary search
```sh
swipl program.pl
```
### agones
SML
```sml
- dromoi("testcases/anaptyksi04.txt");
val it = 1952 : int
```
Prolog
```prolog
?- time(dromoi("testcases/anaptyksi05.txt", ANS)).
% 26,143,024 inferences, 36.835 CPU in 38.045 seconds (97% CPU, 709741 Lips)
ANS = 10435.
```
### bats
Java
```sh
time java Bats testcases/testcase1
896.8
java Bats testcases/testcase1  4.74s user 0.13s system 120% cpu 4.052 total
```
### kouvadakia
```sml
val kouvadakia = fn : int -> int -> int -> string
- kouvadakia 5 7 6;
val it = "02-21-10-21-02-21-10-21-02-21" : string
```
java Kouvadakia 5 7 6
02-21-10-21-02-21-10-21-02-21
```
```prolog
?- kouvadakia(5, 7, 6, X).
X = ['02', '21', '10', '21', '02', '21', '10', '21', '02'|...].
```


