# MEEPS
We're integrating an innocent function. Don't mind us.

## Description (From the instructor)
Numerical integration is widely employed to calculate the numerical value of a definite integral. One engineering application of numerical integration is to approximate the area bounded by a curve and lines.
In this project, you have to develop an algorithm (or technique) to approximate the area between the curve defined by the function f(x), the x-axis, and the two lines x = 0 and x = b, where b ⁝ 2, 2 ≤ b ≤ 4, i.e. the stripped area in the following figure.

<img src="misc/Example.png" alt="A curvy curve">

### Requirements

1. Write an MIPS assembly program to calculate the stripped area using any area
approximation methods (e.g. rectangle/trapezoid method, Simpson’s method, etc.).
	* Input:
		* b (b ⁝ 2, 2 ≤ b ≤ 4)
		* n – the number of small rectangles/trapezoids that shape the stripped area to adjust the accuracy of area calculation, n ⸦ N, 10 ≤ n ≤ 20.
	* Output:
		* The stripped area.
2. Write a report and submit a hard copy that includes:
	* The study on floating-point arithmetic on an MIPS computer.
	* The proposed algorithm/implementation and analysis in the state of the MIPS computer (e.g. the state of memory and registers).

## What We Are Going To Do:

### Our goals

1. To extends the constraints of b and n. 
	* 0 ≤ b ≤ 1.000.000.000
	* n ⸦ N, 10 ≤ n ≤ 1.000.000.000
	* (We may not be able to reach 1 billion, but that's the limit we strive to achieve.)

2. Comparing the results of different approaches:
	* Calculate directly using <b>Newton-Leibniz</b> theorem (a.k.a. finding anti-derivative) (which involve <a href="https://math.stackexchange.com/questions/29649/why-is-arctanx-x-x3-3x5-5-x7-7-dots">infinite series for arctan(x)</a>).
	* Naively integrate the function as-is
	* Rewrite the denominator as <b>(x+1)^2 - 2x</b>
	* Approximately summing ranges using <b>Simpson's rule</b>.
	* Using a third-party calculator (Vinacal, Casio, Internet!, ...) for <i>reference</i> (which means, absolute error <i>(ulps)</i> and relative error <i>(epsilon)</i> of all above approaches will be based on the result of this final one). 
	
For insights about floating point number, <a href="https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html#9921">this paper</a> describes in great details about cancellations, rounding, and much more. 

## What sorcery exists in our MIPS file?
<h3 id="Components"> MIPS Program Components (functions)</h3>

These conditions are given:
* a, b: single-precision float numbers
* n: Integer
* a: Begin bound of integration (0 ≤ a)
* b: End bound of integration (0 ≤ b)
* n: Number of sample points (How many dx?) <b>(except for NEWTON_LEIBNIZ)</b> 

Note that:
* If <b>a ≤ b</b>, we integrate from <b>left to right</b> of x-axis
* If <b>b ≤ a</b>, the direction is from <b>right to left</b>
This detail is useful for accuracy loss comparison when taking into account smaller terms' bits shifting.
 
1. <b><a href="https://math.stackexchange.com/questions/29649/why-is-arctanx-x-x3-3x5-5-x7-7-dots">NEWTON_LEIBNIZ</a></b>: 
Calculate with Newton-Leibniz theorem.

	<i>Maintainer: Minh Chau</i>

	<i>(Psst! The result is <b>4.(arctan(b) - arctan(a))</b>)</i>
	* @param  $a0: a
	* @param  $a1: b 	
	* @param  $a2: n. Number of terms this series contains (put it simply, accuracy)
	* @return $f30: Double-precision calculation result.

2. <b>NAIVE</b>: Calculate normally like every normal person do.

	<i>Maintainer: Thach Thao</i>

	* @param  $a0: a
	* @param  $a1: b
	* @param  $a2: n
	* @return $f28: Double-precision calculation result.

3. <b>SQUARE</b>: Rewrite the denominator as (x+1)^2 - 2x and then integrate

	<i>Maintainer: Tran Lam</i>

	* @param  $a0: a
	* @param  $a1: b
	* @param  $a2: n
	* @return $f26: Double-precision calculation result.

4. <b><a href="https://www.freecodecamp.org/news/simpsons-rule/">SIMPSON</a></b>:
Calculate by summing approximations of each sub-range.

	<i>Maintainer: ???</i>

	* @param  $a0: a
	* @param  $a1: b
	* @param  $a2: n
	* @return $f24: Double-precision calculation result.

5. <b>ANNOUNCE</b>:
Print to the console (or screen) in the format:

	<i>Maintainer: Minh Chau</i>

	> The integration using <i>technique</i> yields <i>result</i>

	> It's in error by ??? ulps

	> With the relative error of ??? eps

	And the following arguments are taken:

	* @param  $a0: technique. Pointer to the technique string name (Square, Naive, Newton-Leibniz)
	* @param  $a1: result. Double-precision result calculated by <i>technique</i>	
	* @param  $a2: reference. Double-precision result calculated by <i>reference</i> (Newton-Leibniz? Vinacal? Casio?)

	On how to calculate absolute error <i>ulps</i> and relative error <i>eps</i>, refers to <a href="https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html#9921">this paper</a>.

## Test Cases

There're 13 test cases in total, written in testcases.txt. Results are referred from <a href="https://www.integral-calculator.com/">integral-calculator</a> and <a href="https://www.fahasa.com/may-tinh-vinacal-570es-plus-ii-hong-trang.html">VINACAL 570ES PLUS II</a>.

For the first 4 test cases (Before <b>Black belt</b>), we'll do three separate tests on each of NAIVE, SQUARE, and SIMPSON:
* <b>Even division</b> (all dx are equals), integrates from <b>left to right</b>.
* <b>Even division</b>, integrates from <b>right to left</b>.
* <b>Sloppily Small</b> (the nearer x is to 0, the smaller each dx is), integrates from <b>right to left</b>.

After that, the most precise method will be employed for the remaining tests.

## Some helper functions:

6. <b>QUICK_SAVE</b>: Quickly saves all [Saved Registers](#SR), Argument Registers ($a?) and Return Register ($v0, $v1)  onto the Stack. 

	<i>Maintainer: Tran Lam</i>

	<i>(Notes: Aim carefully. A miss-timed pair of QUICK_SAVE and QUICK_LOAD will jumble up your Stack horribly)</i> 

	* @param: none
	* @return: none

7. <b>QUICK_LOAD</b>: Quickly load all [Saved Registers](#SR) that was saved by QUICK\_SAVE back to their right places

	<i>Maintainer: Tran Lam</i>

	<i>(Notes: Aim carefully. A miss-timed pair of QUICK_SAVE and QUICK_LOAD will jumble up your Stack horribly)</i> 

	* @param: none
	* @return: none


### Working With Registers
1. <i>Temporary Registers</i>
	
	Temporary registers are registers whose names are prefixed with $t ($t0, $t1, $t2,...).  <b>Don't expect them to stay loyal to you after a subroutine call</b> (with "jal", "jr", "beq", "bgt",... to name a few).

2. <i id="SR">Saved Registers</i>

	Prefixed with $s ($s0, $s1, $s2,...). <b>They are NOT yours to modify.</b> Save them to the Stack, or on .data, $t, anywhere you want before you use them. Remember to put them back in proper places after use.

3. <i>Reserved Registers</i>

	Floating-point registers from $f24 to $f31 are reserved by subroutines, as described at [MIPS Program Components](#Components). <b>You're not allowed to use them</b> (unless you are the subroutine's maintainer, of course).

## DEADLINES  (eeeEeEEEKKKKK)
+ 7/5:  Actually a live line. Obstacles bumped on the way are discussed and solved here.
+ 14/5: All Functions should be ready to be used
+ 21/5: The fully functioning program should be assembled and running at this point.

## Final Notes 
1. On coding integrations and series 
Calculate from the smallest terms first, because if you do from the biggest ones, the smaller terms' bits might get shifted into oblivion.

2. Sloppily small
As x -> +INF, the rate of changes between f(x) and f(x+dx) become so small. Thus, it's wiser if we stretch out dx when x is large, and compress dx when x->0

3. Eureka
	<i>We'll find out on the go</i> 

