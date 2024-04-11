# Alternative to Complete Solution to $Ax=b$

A seemingly obvious question hit me when I saw $Ax=b$.  Why don't we move $b$ to the left hand side, so that we can reuse the same techniques of finding nullspace to find the complete solution?

Specifically, let

$$
A'=\begin{bmatrix}
A&-b
\end{bmatrix}
\qquad
x'=\begin{bmatrix}
x\\
1
\end{bmatrix}
$$

So

$$Ax-b=0
\quad\iff\quad
A'x'=0
$$

The idea is that in resolving the nullspace of this augmented matrix and variable vector, the special solution for the extra "free" variable will become a particular solution, $x_p$, whereas the special solutions of the other free variables will become the homogeneous solution $x_n$.

Observe that $x$ is the complete solution to $Ax=b$ precisely because

$$
\begin{bmatrix}
x_p\\
1
\end{bmatrix}
+\begin{bmatrix}
x_n\\
0
\end{bmatrix}
$$

is the nullspace of $A'x'=0$.

## Example

For example, let's find the complete solution using this approach for:

$$
\begin{bmatrix}
1&1&1\\
1&2&-1
\end{bmatrix}
\begin{bmatrix}
x_1\\
x_2
\end{bmatrix}=
\begin{bmatrix}
3\\
4
\end{bmatrix}
$$

We move stuff to the left, turning it into a problem of finding nullspace:

$$
\begin{bmatrix}
1&1&1&-3\\
1&2&-1&-4
\end{bmatrix}
\begin{bmatrix}
x_1\\
x_2\\
x_3\\
1
\end{bmatrix}=0
$$

$$
A'=\begin{bmatrix}
1&1&1&-3\\
1&2&-1&-4
\end{bmatrix}
\xrightarrow{E_{21}A'}
\begin{bmatrix}
1&1&1&-3\\
0&1&-2&-1
\end{bmatrix}
\xrightarrow{E_{12}E_{21}A'}
\begin{bmatrix}
1&0&3&-2\\
0&1&-2&-1
\end{bmatrix}=R=
\begin{bmatrix}
I&F
\end{bmatrix}
$$

Applying the usual techniques, we get the special solutions for $A'$:

$$
N=
\begin{bmatrix}
-F\\
I
\end{bmatrix}=
\begin{bmatrix}
-3&2\\
2&1\\
1&0\\
0&1\\
\end{bmatrix}
$$

Note, however, the second column of $N$ isn't really the special solution of a free variable.  Rather, it's a particular solution!  At this point, we have the complete solution by reading off the values from $N$ (dropping the last row):

$$
x=x_3
\begin{bmatrix}
-3\\
2\\
1\\
\end{bmatrix}+
\begin{bmatrix}
2\\
1\\
0\\
\end{bmatrix}
$$

$\blacksquare$
