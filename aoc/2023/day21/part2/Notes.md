# Solving the recurrence

Based on experiments, we found the recurrence:

$$
\boxed{T_k = 2 T_{k-1} - T_{k-2} + 29790},\quad T_0 = 3784,\quad T_1 = 33680
$$

This is a *second order non-homogeneous linear recurrence*, which means it has a closed-form solution!

## Resolve the homogeneous recurrence

$$\begin{align*}
T_k^{(h)} - 2 T_{k-1}^{(h)} + T_{k-2}^{(h)} &= 0 \\
\end{align*}$$

This translates to the characteristic equation:

$$\begin{align*}
a^2 -2a + 1 &= 0 \\
(a-1)^2 &= 0
\end{align*}$$

Oops, this is a special case where the characteristic root of 1 has a multiplicity of 2.  Based on [the standard algorithm](#reference),

$$\boxed{T_k^{(h)} = b_1 + b_2k}$$

for some constants $b_1$ and $b_2$.

## Guess the particular solution

Given the multiplicity of two, we make a guess that $T_k^{(p)} = ck^2$ for some constant $c$.  To find $c$, we substitute this guess to the original recurrence:

$$\begin{align*}
T_k^{(p)} - 2 T_{k-1}^{(p)} + T_{k-2}^{(p)} &= 29790 \\
ck^2 - 2 c(k-1)^2 + c(k-2)^2 &= \\
2c &= \\
c &= 14895 \\
\end{align*}$$

$$\therefore \boxed{T_k^{(p)} = 14895 k^2}$$

## General solution

Adding the homogeneous and particular solution, we get:

$$\begin{align*}
T_k &= b_1 + b_2k + 14895k^2 \\
\end{align*}$$

Finally, we can figure out $b_1$ and $b_2$ using the boundary conditions:

$$\begin{align*}
T_0 &= b_1 = 3784 \\
T_1 &= b_1 + b_2 + 14895 = 33680 \\
b_2 &= 15001 \\
\end{align*}$$

$$\therefore \boxed{T_k = 14895k^2 + 15001k + 3784}$$

# [SageMath](https://www.sagemath.org/)

These days, of course, we can also use the machine to do the heavy-lifting!

```bash
$ cat > solve.sage <<'EOF'
from sympy import Function, rsolve
from sympy.abc import k
T = Function('T')
f = T(k) - 2*T(k-1) + T(k-2) - 29790
g = SR(rsolve(f, T(k), {T(0): 3784, T(1): 33680}))

print('Recurrence: T(K) = 2*T(k-1) - T(k-2) + 29790')
print(f'Solution in LaTeX: ${latex(g)}$')
print(f'Examples: {[g(k=i) for i in range(10)]}')
EOF

$ sage solve.sage
Recurrence: T(K) = 2*T(k-1) - T(k-2) + 29790
Solution in LaTeX: $14895 \, k^{2} + 15001 \, k + 3784$
Examples: [3784, 33680, 93366, 182842, 302108, 451164, 630010, 838646, 1077072, 1345288]
```
Oh, what cheating!

# Reference

* [Applied Discrete Structures - Recursion and Recurrence Relations
](https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Applied_Discrete_Structures_(Doerr_and_Levasseur)/08%3A_Recursion_and_Recurrence_Relations/8.03%3A_Recurrence_Relations?readerView) by Doerr and Levasseur.
  * Fun fact: the recurrance on this page is the same as that of [Eercise 8.3.5](https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Applied_Discrete_Structures_(Doerr_and_Levasseur)/08%3A_Recursion_and_Recurrence_Relations/8.03%3A_Recurrence_Relations?readerView) but with different coefficients.
* [Lecture 36: Symbolic Computation with sympy - Solving Recurrence Relations](https://homepages.math.uic.edu/~jan/mcs320/mcs320notes/lec36.html#solving-recurrence-relations) by University of Illinois at Chicago.
* [Sage, LaTeX and Friends](https://doc.sagemath.org/html/en/tutorial/latex.html)
