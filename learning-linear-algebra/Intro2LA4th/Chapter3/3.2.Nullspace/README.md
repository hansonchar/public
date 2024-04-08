# Linearly dependent column

In a square matrix, why is it true that if the last column of a square matrix is a linear combination of the other columns, then the last row of the matrix must also be a linear combination of the other rows?

Suppose we have a 3 by 3 matrix:

$$
A=\begin{bmatrix}
a&b&ax+by\\
c&d&cx+dy\\
e&f&ex+fy
\end{bmatrix}
$$

where

1. $a\ne 0$
1. column 1 and 2 are independent to each other
1. column 3 is a linear combination of the first two columns.

If we perform Gaussian elimination and get the third row to become zero, then we know the row must be a linear combination of the rows above!  Let's try:

$$
A=\begin{bmatrix}
a&b&ax+by\\
c&d&cx+dy\\
e&f&ex+fy
\end{bmatrix}
\stackrel{E_{31}E_{21}A}{\xrightarrow{\mkern80mu}}
\begin{bmatrix}
a&b&ax+by\\
0&d'&d'y\\
0&f'&f'y
\end{bmatrix}
\stackrel{E_{32}E_{31}E_{21}A}{\xrightarrow{\mkern80mu}}
\begin{bmatrix}
a&b&ax+by\\
0&d'&d'y\\
0&0&0
\end{bmatrix}
$$

where

$$d'=d-{bc\over a}\qquad f'=f-{be\over a}$$

and

$$
E_{31}E_{21}=\begin{bmatrix}
1\\
-c/a&1\\
-e/a&0&1\\
\end{bmatrix}
\quad
E_{32}=\begin{bmatrix}
1\\
0&1\\
0&-f'/d'&1\\
\end{bmatrix}
$$

The third row becomes zeros as expected.

$\blacksquare$

Observe how the linear dependency of the 3rd column is always maintained during the elimination.
