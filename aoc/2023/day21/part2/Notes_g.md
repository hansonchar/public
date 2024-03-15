# Solving recurrence by Generating function

We can also use *generating function* to solve the recurrence:

$$
\boxed{T_k = 2 T_{k-1} - T_{k-2} + 29790},\quad T_0 = 3784,\quad T_1 = 33680
$$

# Translate into Generating Functions

First, we re-express the recurrence equation to make it easier to work with.  Let $a=3784, b=33680$ and $c=29790$.

$$
\begin{align*}
T_n - 2T_{n-1} + T_{n-2} &= c & T_0=a, T_1=b \\
\sum_{n=2}^\infty\left(T_n - 2T_{n-1} + T_{n-2}\right)z_n &= \sum_{n=2}^\infty cz^n \\
\boxed{\sum_{n=2}^\infty T_nz^n} - 2\boxed{\sum_{n=2}^\infty T_{n-1}z^n} + \boxed{\sum_{n=2}^\infty T_{n-2}z^n} &= c\boxed{\sum_{n=2}^\infty z^n} & (1)\\
\end{align*}
$$

# Solve for the Generating Function

Let $$G(T;z) = \sum_{n=0}^\infty T_nZ^n$$

Let's tackle each sum individually:

$$
\begin{align*}
\sum_{n=2}^\infty T_nz^n &= \left(\sum_{n=0}^\infty T_nz^n\right) - T_1z - T_0 \\
\end{align*}
$$

$$\boxed{\sum_{n=2}^\infty T_nz^n = G(T; z) - bz - a}$$

$$
\begin{align*}
\sum_{n=2}^\infty T_{n-1}z^n &= z\sum_{n=2}^\infty T_{n-1}z^{n-1} = z\sum_{n=2}^\infty T_{n-1}z^{n-1} \\
&= z\sum_{n=1}^\infty T_nz^n = \left(z\sum_{n=0}^\infty T_nz^n\right) - zT_0 \\
\end{align*}
$$

$$\boxed{\sum_{n=2}^\infty T_{n-1}z^n = z\big(G(T;z) - a\big)}$$

$$
\begin{align*}
\sum_{n=2}^\infty T_{n-2}z^n &= z^2\sum_{n=2}^\infty T_{n-2}z^{n-2} &= z^2\sum_{n=0}^\infty T_nz^n \\
\end{align*}
$$

$$\boxed{\sum_{n=2}^\infty T_{n-2}z^n = z^2G(T;z)}$$

$$
\begin{align*}
\sum_{n=2}^\infty z^n &= \sum_{n=0}^\infty z^n - z - 1 \\
\end{align*}
$$

$$\boxed{\sum_{n=2}^\infty z^n = {1\over1-z} - z - 1}$$

Substituting them back to equation (1), and writing $G$ as a short-hand for $G(T;z)$, we get:

$$
\begin{align*}
(G - bz - a) - 2z(G-a) + z^2G &= c\left({1\over1-z} - z - 1\right) \\
G(z^2-2z+1) &= \left({c\over1-z} -cz -c + a \right) + (b-2a)z \\
G(z-1)^2 &= {c\over1-z} + (b-2a-c)z + (a-c) \\
G(T;z) &= {c\over(1-z)^3} + {(b-2a-c)z\over(1-z)^2} + {a-c\over(1-z)^2}
\end{align*}
$$

# Determine the sequence

Here comes the interesting part.  Each term in the last equation above is a commonly known generating function!  Specifically,

$$
\begin{align*}
{1\over(1-z)^3} &= \sum_{n=0}^\infty {(n+1)(n+2)\over2}z^n \\
{z\over(1-z)^2} &= \sum_{n=0}^\infty nz^n \\
{1\over(1-z)^2} &= \sum_{n=0}^\infty (n+1)z^n \\
\end{align*}
$$

Therefore,

$$T_n = {c(n+1)(n+2)\over2} + (b-2a-c)n + (a-c)(n+1)$$

Simplifying using `Sage`,

```bash
a, b, c = 3784, 33680, 29790
T(x) = c*(x+1)*(x+2)/2 + (b-2*a-c)*x + (a-c)*(x+1)
show(T.expand()) # or latex(T.expand())
```

$$x \ {\mapsto}\ 14895 x^{2} + 15001 x + 3784$$

Verifying,

```bash
[T(i) for i in range(10)]
[3784, 33680, 93366, 182842, 302108, 451164, 630010, 838646, 1077072, 1345288]
```

Bingo!