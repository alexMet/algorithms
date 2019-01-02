# Γλώσσες Προγραμματισμού Ι
My solutions for some algorithms, using multiple programming languages.

Γλώσσες Προγραμματισμού Ι (Programming Languages I)
Προπτυχιακό μάθημα, 6ου εξαμήνου. Υποχρεωτικό στη ροή Λ της ΣΗΜΜΥ
https://courses.softlab.ntua.gr/

## C

```sh
gcc –std=c99 -Wall –Werror -O3 program.c -o el
```

## SML

- Priority queue
- A* algorithm
- Bresenham algorithm
- Binary search
- Merge sort

```sh
sml program.sml
```

## OCaml

```sh
ocamlopt -O3 program.ml -o el
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

## YAP

```sh
yap program.pl
```

YAP is way faster than swipl. On the top of your program you'll need some imports, e.x.

```prolog
:- use_module(library(readutil)).
:- use_module(library(heaps)).
:- use_module(library(assoc)).
:- use_module(library(lists)).
```

### Examples

SML

```sml
- dromoi("testcases/anaptyksi04.txt");
val it = 1952 : int

val kouvadakia = fn : int -> int -> int -> string
- kouvadakia 5 7 6;
val it = "02-21-10-21-02-21-10-21-02-21" : string
```

Prolog

```prolog
?- time(dromoi("testcases/anaptyksi05.txt", ANS)).
% 26,143,024 inferences, 36.835 CPU in 38.045 seconds (97% CPU, 709741 Lips)
ANS = 10435.

?- kouvadakia(5, 7, 6, X).
X = ['02', '21', '10', '21', '02', '21', '10', '21', '02'|...].
```

Java

```sh
time java Bats testcases/testcase1
896.8
java Bats testcases/testcase1  4.74s user 0.13s system 120% cpu 4.052 total

java Kouvadakia 5 7 6
02-21-10-21-02-21-10-21-02-21
```
