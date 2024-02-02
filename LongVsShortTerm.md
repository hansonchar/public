
# Is it always more tax effective to sell stocks that have been held for over 12 months?

## Summary

The answer is no.  The following
1. provides a counterexample
1. considers all possible scenarios, and
1. points out the conditions necessary to be more tax effective in the selling of stocks that have been held for over 12 months.

Assumptions:
1. Capital gain tax rate at 15%.
1. Income tax rate at 37%.

Suppose in 2024 we have
1. One stock A (long-term) acquired for over 12 months with a cost basis of $90.00
1. One stock B (short-term) acquired for less than 12 months with a cost basis of $150.00

## Selling in 2024

Consider the tax that is incurred if the market price is at $155.00 in 2024:
* Selling A (long-term) in 2024: ($155 -  $90) * 15% = $9.75
* Selling B (short-term) in 2024: ($155 - $150) * 37% = $1.85

## Selling after 2025 (when stock B becomes long-term)

Consider the tax that is incurred if the market price went up to $200.00 in 2026, when both stocks have been held for over 12 months:
* Selling A (long-term) in 2026: ($200 -  $90) * 15% = $16.50
* Selling B (short-term) in 2026: ($200 - $150) * 15% =  $7.50

In both cases, selling B (short-term) is more tax effective. Therefore *the answer is no*.

Furthermore, *in this example, no matter how far into the future, selling B (short-term) is always going to incur less tax than selling A (long-term)*.  The reason is that ($x - $150) * 15% is always less than ($x -  $90) * 15% for all x > 150.

## Break-even price in 2024

The break-even price $x$ is the stock price when selling either A or B does not make a difference in terms of the tax incurred.

$x$ in 2024 can be calculated by:

$$
\begin{align*}
(x-90) \times 0.15 &= (x-150) \times 0.37 \\
x &\approx 191
\end{align*}
$$


## What would be the conditions that selling A (long-term) is more tax effective?

There are a total of five scenarios.
1. x $\le$ 90: Selling A (long-term) is always more tax effective.
   * No tax, plus we maximize the chance of paying less tax in the future.
1. 90 < x $\le$ 150: Selling B (short-term) is always more tax effective.
   * No tax.
1. 150 < x $\le$ 191 in 2024: Selling B (short-term) in 2024 is more tax effective.
   * Details explained in the [earlier example](#selling-in-2024) (using a market price of $155).
1. 191 < x in 2024: Selling A (long-term) in 2024 is more tax effective.
   * Less tax.
1. 150 < x after 2025: Selling B (short-term) after 2025 is always more tax effective.
   * Details explained in the [earlier example](#selling-after-2025-when-stock-b-becomes-long-term) (using a market price of $200).

Therefore, the only two conditions are (1) and (4).
* (1) when the market price drops below $90.
* (4) when the market price went up beyond $191.00 and the selling occurred in 2024.

## Specific Case Study

|| long-term | short-term |
|--- |--- |---|
| Cost basis | $123.31 | $142.71 |
| Tax rate | 15% | 37% |

Break-even price: $155.94.

i.e. It's more tax effective to sell the long-term shares with a cost basis of $123.31 at a market price of over $155.94.  Conversely, it's more tax effective to sell the short-term shares with a cost basis of $142.71 at a market price of below $155.94.


## Appendix

### General Formula

|| long-term | short-term |
|--- |--- |---|
| Cost basis | $l$ | $s$ |
| Tax rate | $t_l$ | $t_s$ |

Let $x$ be the break-even market price.

$$
\begin{aligned}
(x - l) t_l &= (x-s) t_s \\
x &= \frac{s\cdot t_s - l\cdot t_l}{t_s - t_l}
\end{aligned}
$$

### SageMath function

```
sage: var("l tl s ts")
sage: f(l, s, tl, ts) = (s*ts - l*tl) / (ts - tl)
sage:
sage: # For example:
sage: f(123.31, 142.71, 0.15, 0.37)
155.937272727273
```
