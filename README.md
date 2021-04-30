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
	* Using a third-party calculator (Vinacal, Casio, Internet!, ...) for <i>reference</i> (which means, absolute error <i>(ulps)</i> and relative error <i>(epsilon)</i> of all above approaches will be based on the result of this final one. <b>(How to convert the result of third-party applications into our double-precision registers? To check stuffs?)</b>
	
For insights about floating point number, <a href="https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html#9921">this paper</a> describes in great details about cancellations, rounding, and much more. 

## What sorcery exists in our MIPS file?
<h3 id="Components"> MIPS Program Components (functions)</h3>

These conditions are given:
* a, b, n: Integers
* a: Left bound of integration (0 ≤ a is given)
* b: Right bound of integration (a ≤ b is given)
* n: Number of sample points (How many dx?) <b>(except for NEWTON_LEIBNIZ)</b> 

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

3. <b>SQUARE</b>: Rewrite the denominator as (x+1)^2 - 2\*x and then integrate

	<i>Maintainer: Tran Lam</i>

	* @param  $a0: a
	* @param  $a1: b
	* @param  $a2: n
	* @return $f26: Double-precision calculation result.

4. <b><a href="https://en.wikipedia.org/wiki/Simpson%27s_rule">SIMPSON</a></b>:
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

### Test Cases

These're tests case for which each integration algorithm will be tested:

<b> Easy peasy: </b>
1. a = 0, b = 2, n = 10 (Example test case)
2. a = 0, b = 4, n = 20 (Project requirement's maximum constraint)

<b> The bugs are coming out: </b>

3. a = 0, b = 0.1, n = 10 
4. a = 0, b = 0.1, n = 1000 (To compare the difference between results with 3. )
5. a = 0, b = 100, n = 1000
6. a = 0, b = 100, n = 10000 (To compare the difference between results with 5. )

<b> Black-belt level:</b> <i>(They may take a while)</i>

7. a = 0, b = 1e6, n = 1e7 
8. a = 0, b = 1e9, n = 1e9 

<b> <a href="https://www.youtube.com/watch?v=9vD2JBq0ns8">So big, So small</a>:</b> <i>(Because I'm not going to wait 30 minutes in an 1-hour test)</i>

9. a = 0, b = 1e9, n = 1e6
10. a = 0, b = 1e9, n = 1e5 

<b><a href="https://ncov.moh.gov.vn/dong-thoi-gian">Covid-19</a>:</b> <i>(I need a microscope!)</i>

11. a = 0, b = 1e-5, n = 10
12. a = 0, b = 1e-5, n = 1000
13. a = 0, b = 1e-7, n = 100

<h3>Some helper functions:</h3>

6. <b>QUICK_SAVE</b>: Quickly saves all [Saved Registers](#SR) onto the Stack. 

	<i>Maintainer: Tran Lam</i>

	<i>(Notes: This subroutine should be placed right on top of the subroutine whom called it. A miss-timed pair of QUICK_SAVE and QUICK_LOAD will jumble up your Stack horribly)</i> 
	* @param: none
	* @return: none

7. <b>QUICK_LOAD</b>: Quickly load all [Saved Registers](#SR) that was saved by QUICK_SAVE back to their right places

	<i>Maintainer: Tran Lam</i>

	<i>(Notes: Be sure to cleanly wipe off the Stack partition you use before you call it. )</i> 
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

2. Eureka

	<i>We'll find out on the go</i> 

