# [Secretary Problem](https://en.wikipedia.org/wiki/Secretary_problem)

Also known as the Marriage Problem, Best Choice Problem, Optimal Stopping, and 37% rule.

## Problem Statement

We have $n$ distinct, totally ordered candidates arriving sequentially in a uniformly random order.  Upon each arrival, we must irrevocably accept or reject the candidate based on its relative rank among the candidates seen so far.  We may reject any number of candidates, but can accept at most one.  How do we maximize the probability of selecting the very best candidate?

## FAQ

* Couldn't we just wait until all candidates have arrived, and then pick the best one?

  No — the rules require that a decision be made irrevocably as each candidate arrives.  If we wait until the end, we'll have rejected every candidate except the last.  Given that the arrival order is uniformly random, the last candidate has $1/n$ chance of being the very best.

## Thoughts

* The decision of accepting a candidate can happen at most once — it can happen at any one of the arrivals in sequential order, or none at all.
* The secretary problem can be characterized as making one-shot decisions under uncertainty with no recall.
* If we randomly choose to accept the $i$-th candidate (regardless of its observed rank), the probability that this candidate is the very best has probability of exactly $1/n$.
* Can we do better?  Obviously, if we are evaluating at the $(r+1)$-th candidate, then we must have rejected the previous $r$ candidates, and therefore we have the knowledge of all the distinct ranks of the $r+1$ candidates seen so far.  Could we somehow leverage on this information to improve our odds?

## Strategy

Here's the idea.  Suppose we arbitrarily divide the selection process into two phases — a *rejection phase* followed by an *acceptance phase*.  In the initial phase, we deliberately reject the first $r$ candidates purely to gather information about their ranks.  In the second phase, starting from $r+1$, we accept the first candidate better than all previously observed so far. (Note that we cannot know which candidate is the very best until we've seen all $n$ candidates, but by then it would likely be too late, as we would have rejected all except the last.)

Let

* $n > 0$ be the number of candidates.
* $r$ be the number of candidates to be rejected in the initial phase.  Note that $0\le r<n$.
* $B_k$ be the best among the first $k$ candidates that have already arrived.
* $i$ be the position where the very best candidate arrives in the sequence.

Consider some cases,

* Case $r=0$.  No candidate is rejected in the initial phase, so the first candidate is accepted.  The probability of the first candidate being the best is $P(i=1) = 1/n$.
* Case $r=n-1$. All candidates except the last is rejected in the initial phase.  In this case, the last candidate is accepted only if it is the very best.  The probability is $P(i=n) = 1/n$.
* Case $0 < i\le r < n$.  The very best candidate gets rejected in the initial phase, so there is zero probability of accepting the best.
* Case $0<r< i\le n$.
  * If $i=r+1$, $P(i=r+1) = 1/n$, the probability of having the very best at position $r+1$ is exactly $1/n$.
  * If $i=r+\delta$, where $\delta > 1$.  This case is possible only if $B_{i-1}$, the best among the first $i-1$ candidates, is positioned inside the initial rejection phase.  Otherwise, $B_{i-1}$ would have been accepted before the arrival of the very best.
  This leads to the key question: given $i-1$ candidates, what is the probability that the best among them appeared in the initial rejection phase of size $r$?  The answer is $\displaystyle{r\over i-1}$.  Simple, critical, and perhaps a little surprising.
  The probability of the very best at position $r+\delta$ is therefore $\displaystyle P(i=r+\delta) = {r\over i-1}\cdot{1\over n}$.  Namely, the relative best among the first $i-1$ candidates is positioned inside the rejection phase, and the very best candidate is positioned exactly at position $i$.

## Putting it together

Using the above strategy, we aim to compute $P_n(r)$, the probability of successfully picking the very best among $n$ candidates with a rejection phase of size $r$.

* Case: $r=0$. There is no candidate to reject.  Since there is no rejected candidate to compare against, the first candidate that arrives is, by definition, the best so far and get accepted.  The probability that this candidate is the very best is exactly $1/n$.  Therefore, $$P_n(0) = {1\over n}.$$

* Case: $0 < r < n$.  After rejecting $r$ candidates in the initial phase, we are now in the acceptance phase.  If the next candidate is better than all previously observed candidates, we accept it immediately (and terminate the process).  Otherwise, we keep going until all $n$ candidates are exhausted.  In other words, given a specific $n$ and $r$, the acceptance of an candidate could occur at position $i$ where $i\in[r+1,n]$.
As pointed out earlier, each such occurence is only possible if $B_{i-1}$, the best among the first $i-1$ candidates, arrived during in the rejection phase.
Therefore,

$$
\begin{align*}
P_n(r) &= \sum_{i=r+1}^n\left({r\over i-1}\cdot{1\over n}\right) \\
       &= {r\over n}\sum_{i=r+1}^n{1\over i-1}.\\
\end{align*}
$$

$\qquad$ Let $j=i-1$,

$$
\begin{align*}
P_n(r) &= {r\over n}\sum_{j=r}^{n-1}{1\over j} & \qquad(1)\\
&= {r\over n}\left(H_{n-1} - H_r\right). & \qquad(2) \\
\end{align*}
$$

$\qquad$ using the [harmonic number](https://en.wikipedia.org/wiki/Harmonic_number):

$$H_n = \sum_{k=1}^n{1\over k}.$$

## Asymptotic behavior

Using [the fact](https://en.wikipedia.org/wiki/Harmonic_number#Calculation) that

$$\lim_{n\rightarrow\infty}(H_n - \ln n) = \gamma \qquad\qquad\qquad$$

or

$$\lim_{n\rightarrow\infty} H_n = \ln(n) + \gamma \qquad\qquad (3)$$

where $\gamma$ is a constant (called the [Euler-Mascheroni constant](https://en.wikipedia.org/wiki/Euler%E2%80%93Mascheroni_constant)),

$$
\begin{align*}
P_n(r) &= {r\over n}\left(H_{n-1} - H_r\right) & [\text{from (2)}]\\
P_n(r) &\approx {r\over n}\left(\ln(n-1) + \gamma - (\ln(r)+ \gamma)\right) &\qquad[\text{applying (3)}]\\
P_n(r) &\approx {r\over n}\ln\left({n-1\over r}\right).
\end{align*}
$$

## Maximal $P_n(r)$

Given $P_n(r)$ has a closed form approximation when $n$ is large, we can find the value $r$ that maximizes $P_n(r)$ by taking its derivative and setting it to zero.

$$
\begin{align*}
P_n'(r) &\approx {1\over n}\ln\left({n-1\over r}\right) - {r\over n}\cdot{r\over n-1}\cdot{n-1\over r^2}\\
&\approx {1\over n}\left[\ln\left({n-1\over r}\right) - 1\right].\\
\end{align*}
$$

Then set $P_n'(r) = 0$,

$$
\begin{align*}
0 &= {1\over n}\left[\ln\left({n-1\over r}\right) - 1\right] \\
1 &= \ln\left({n-1\over r}\right) \\
e &= {n-1\over r} \\
r &= {n-1\over e} \approx {n\over e}.
\end{align*}
$$

To find the maximum probability,

$$
\begin{align*}
P_n\left({n-1\over e}\right) &\approx {(n-1)/e\over n}\ln\left({n-1\over (n-1)/e}\right) \\
&\approx {n-1\over n}\cdot{1\over e} \\
&\approx {1\over e}.
\end{align*}
$$

## Notes

1. The maximum probability of successfully picking the overall best candidate using this strategy is approximately $1/e\approx$ 37%, when $n$ is large.  The number of candidates to reject automatically would be roughly $n/e$.  Of course, this doesn't mean we will accept the next candidate immediately after the rejection phase — it depends. We will accept the next candidate only if it is the best among all we have seen so far.  Otherwise, we keep going until all candidates are exhausted.
1. When $n$ is small, we can compute the exact solutions by using the discrete sum formula (1) above.

## Reference

* [Probability, Mathematical Statistics, and Stochastic Processes](https://stats.libretexts.org/Bookshelves/Probability_Theory/Probability_Mathematical_Statistics_and_Stochastic_Processes_(Siegrist)/12%3A_Finite_Sampling_Models/12.09%3A_The_Secretary_Problem?readerView#Statement_of_the_Problem) by Kyle Siegrist
* [Secretary Problem](https://en.wikipedia.org/wiki/Secretary_problem) — Wikipedia
