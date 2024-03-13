
# From evaluating a limit

Came across this [quiz](https://www.youtube.com/watch?v=VvWO7_lWprQ):
$$\displaystyle \lim_{n\to\infty}\left({1\over n^3} + {2^2\over n^3} + {3^2\over n^3} + \cdots + {(n-1)^2\over n^3} + {1\over n}\right)$$

which entails an interesting recurrence.  You see, we want to find the closed form expression for $\displaystyle\sum_1^n k^2$ because:

$$\sum_1^n{k^2\over n^3} = {1\over n^3}\sum_1^n k^2$$

Hence the recurrence:

$$T_n = T_{n-1} + n^2,\quad T_1=1$$
$$\boxed{T_n - T_{n-1} = n^2}$$

This is a *first order non-homogeneous linear equation* with a *characteristic root* of 1.  So the *homogeneous solution* is just a constant:

$$\boxed{T_n^{(h)} = d}$$

[Guessing the *particular solution*](https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Applied_Discrete_Structures_(Doerr_and_Levasseur)/08%3A_Recursion_and_Recurrence_Relations/8.03%3A_Recurrence_Relations?readerView) in this case is a little more complicated.  The right hand side is $n^2$.  Trying a second order polynomial didn't work, so we try a third order:

$$T_n^{(p)} = \alpha + an + bn^2 + cn^3$$

Note we can ignore $\alpha$ since subsituting to the recurrence would always cancel it out.  So:

$$\boxed{T_n^{(p)} = an + bn^2 + cn^3}$$

Substituting to the recurrence:

$$T_n - T_{n-1} = n^2$$

$$(an + bn^2 + cn^3) - \left(a(n-1) + b(n-1)^2 + c(n-1)^3\right) = n^2$$

```bash
# Use sage to simplify:
var('a b c n')
f(n) = a*n + b*n^2 + c*n^3
g = f(n) - f(n-1)
latex(g.expand())
```

We get:
$$3 c n^{2} + 2 b n - 3 c n + a - b + c = n^2$$

Matching both sides:

$$\begin{align*}
3c &= 1 \implies c = 1/3 \\
2b - 3c &= 0 \implies b = 1/2 \\
a - b + c &= 0 \implies a = 1/6\\
\end{align*}$$

Therefore,

$$\boxed{T_n^{(p)} = {1\over 6}n + {1\over2}n^2 + {1\over3}n^3}$$

Now add together the homogenous and particular solutions to get the *general solution*:

$$T_n = d + {1\over 6}n + {1\over2}n^2 + {1\over3}n^3$$

But $T_1 = 1 = d + 1/6 + 1/2 + 1/3\implies d=0$.  Therefore,

$$\boxed{T_n = {1\over 6}n + {1\over2}n^2 + {1\over3}n^3}$$

```bash
# Use sage to verify:
var('n')
a, b, c = 1/6, 1/2, 1/3
f(n) = a*n + b*n^2 + c*n^3
g = f(n) - f(n-1)
latex(g.expand())
```

We get $n^2$.  Check!
