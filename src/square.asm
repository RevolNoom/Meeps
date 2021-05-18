#--------------------SQUARE----------------
# Maintainer: Tran Lam
#
# Integrate f(x) = 4/((x+1)^2 - 2x)
# @param $a0: (int) begin bound
# @param $a1: (int) end bound
# @param $a2: (int) number of sample points
# @return $f26: (double) integration result

# How this works:
# 
# Set x to $a0 (begin)
# Calculate length of one step dx
# Loop until x reach $a1 (end):
#	Calculate sample point value
#	Calculate f(x)dx
#	Add f(x)dx to $f26
#

.data 
one.d: .double 1.0
two.d: .double 2.0
four.d:.double 4.0


#ratio.d:.double 0	# LINEAR_METHOD: the ratio between 
			# the first and the last operands
			# of the dx-length series 
.text
	li	$a0 0
	li	$a1 100
	li	$a2 10000

SQUARE:
	# REGISTERS LOOKUP TABLE
	# $s0 = integration counter (from 0 to n-1)
	# $f0 = a = x
	# $f2 = b
	# $f4 = n
	# $f6= 1.0
	# $f8= 2.0
	# $f10= 4.0
	l.d	$f6 one.d($zero)
	l.d	$f8 two.d($zero)
	l.d	$f10 four.d($zero)
	
	# a and b is float 32. Convert to double 64
	# Because float 32 has 24 bits precision, 
	# it can only represent integers precisely up to 16.777.215
	# Converting to double will push the boundary to 1.000.000.000
	
	mtc1	$a0 $f0		# $f0 = a  = $a0 = x
	cvt.d.w	$f0 $f0		
	
	mtc1	$a1 $f2		# $f2 = b  = $a1
	cvt.d.w	$f2 $f2
	
	
	mtc1	$a2 $f4		# $f4 = n  = $a2 
	cvt.d.w	$f4 $f4	
	
	
	mtc1	$zero $f26	# Reset output $f26 to zero
	mtc1	$zero $f27 
	
	li	$s0 0	# Reset counter
	
	
	#j	CONSTANT_DX_METHOD
	j	LINEAR_DX_METHOD
	DONE_INTEGRATION:
	#j	SLOPER_SMALLER_METHOD	# Abandoned. See Appendix for more details
	
	li	$v0 10
	syscall		#Terminate program
	

#========================= LINEAR DX =========================
# Integrate f(x)dx, with dx varies by a linear function:
# dx = cx + c1
# where c and c1 are some constants
#		
# c1 = the initial value of dx 
#
# c1 = (b-a)/(n+r/2)
# c  = c1 / (n-1)
#==========================================
LINEAR_DX_METHOD:
	# REGISTERS LOOKUP TABLE
	# $f12 = current dx
	# $f14 = f(x)
	# $f16 = f(x)dx
	# $f18 = dx step
	# $f20 = ratio
	# $f22 = temporary
	
	SET_RATIO:
	
	jal	CALCULATE_FX	# Calculate f(a), saves in $f14
	
	mov.d	$f18 $f0	# Saves "a" somewhere else ($f18)
	mov.d	$f20 $f14	# Saves f(a) in $f20 (ratio)
	
	mov.d	$f0 $f2		# Set $f0 to b
	
	jal	CALCULATE_FX	# Calculate f(b), saves in $f14
	
	div.d	$f20 $f20 $f14	# Calculate f(a)/f(b), saves in $f20
	
	mov.d	$f0 $f18	# Move "a" back to $f0
	
	# or you can comment out all above SET_RATIO
	# And use this ratio instead
	#l.d	$f20 ratio.d	# get ratio r
	
	
	# "r "is the ratio between the first and the last element
	# c1 is the initial dx
	# c is the amount added to dx after every iteration
	# Their relationship:
	#
	# r = c1 / (c1 + c*(n-1))
	#
	# With "r" known, c and c1 are calculated as:
	# Temporary value T = 2(b-a) / (n*(r+1))
	# c1 = r*T
	# c = T * (1-r) / (n-1)
	
	FIND_T:
	sub.d	$f12 $f2 $f0	# Find b - a
	
	add.d	$f12 $f12 $f12	# 2*(b-a)
	
	add.d	$f22 $f20 $f6	# $f22 = r + 1
	mul.d	$f22 $f22 $f4	# $f22 = n*(r+1) = denominator
	
	div.d	$f22 $f12 $f22	# $f22 = T = current dx = 2*(b-a) / n(r+1)
	
	SET_INITIAL_DX:		
	
	mul.d	$f12 $f22 $f20	# $f12 = initial dx = r*T
	
	SET_DX_STEP:
		
	sub.d	$f18 $f6 $f20	# $f18 = 1-r
	mul.d	$f18 $f18 $f22  # $f18 = (1-r)*T
	sub.d	$f22 $f4 $f6	# $f22 = n-1
	div.d	$f18 $f18 $f22	# $f18 = (1-r)*T/(n-1)	
	
	LINEAR_INTEGRATE:
		
		jal	CALCULATE_FX	# Set $f14 = f(x)
		
		mul.d	$f16 $f14 $f12		# $f16 = f(x)dx
		
		nop				# Wrapping up this iteration
		add.d	$f26 $f26 $f16		# Result += f(x)dx
		add.d	$f0  $f0  $f12		# x += dx (increment)
		add.d	$f12  $f12  $f18	# increment dx
		addi	$s0 $s0 1		# ++counter
		blt	$s0 $a2 LINEAR_INTEGRATE	# Go back if we haven't added all the small trapezoids
		
	
	j	DONE_INTEGRATION
		
		
		
CONSTANT_DX_METHOD:
	# REGISTER LOOKUP TABLE
	# $f12 = dx
	# $f14 = f(x)
	# $f16= f(x)dx
	# $f18, $f20: temporary
	
	sub.d	$f12 $f2 $f0	# set $f12 = dx = (b-a)/n
	div.d	$f12 $f12 $f4	
	
	INTEGRATE:		
		
		jal	CALCULATE_FX		# Set $f14 = f(x)
		
		mul.d	$f16 $f14  $f12		# $f16 = f(x)dx
		add.d	$f26 $f26 $f16		# Result += f(x)dx
		add.d	$f0  $f0  $f12		# x += dx (increment)
		addi	$s0 $s0 1		# ++counter
		blt	$s0 $a2 INTEGRATE	# Go back if we haven't added all the small trapezoids
		
	j	DONE_INTEGRATION

#====== CALCULATE FX ======
# CALCULATE f(x) = 4 / ((x+1)^2 - 2x)
# @param $f0: x
# @param $f6:  1.0 (default)
# @param $f8:  2.0 (default)
# @param $f10: 4.0 (default)
# @return $f14: f(x)
# Registers used inappropriately: $f14 $f22
# (Save them somewhere if you don't want them overwritten!)
CALCULATE_FX:	
		mtc1.d	$zero $f14	# Reset $f14 for new f(x)
		add.d	$f14 $f6 $f0	# $f14 = 1 + x
		mul.d	$f14 $f14 $f14	# $f14 = (1+x)^2
		mul.d	$f22 $f8 $f0	# $f20 = 2x
		sub.d	$f14 $f14 $f22	# $f14 = denominator
		div.d	$f14 $f10 $f14	# $f14 = f(x) = 4 / denominator	
		jr	$ra	
		
		
#=================== SLOPER SMALLER ==================
# Calculate f(x)dx with dx varies based on
# how sloppy f(x) is at x
# In other word, |dx| ~ |f'(x)| (f(x) derivative)
#
# Let dx(x) be a function of x, defines dx(x) to be:
# dx(x) = c1 / f'(x) when f'(x) != 0
#	= c2	when f'(x) = 0 
# Where c1, c2 are some constant
# 
# dx(x) becomes big when the graph is even
# and vice versa, small when the graph is slopy	
#
# There's a problem: the sum of all dx must equals the range b-a
# Which means:
# integration from a->b with variable u of dx(u)du = b-a
# => int_a->b_(c/f'(u)*du) = b-a
#
# That's where c comes into play
#
# For this project only, we're able to find c:
# c/f'(u) = c/(-8x/(x^2+1)^2)
#	= -c*(x^3/8 + x/4 + 1/8x)
#
# Antiderivative of c/f'(u):
# -c*(x^4/4 + x^2 - ln(x))/8 
#
# And since integration from a->b equals b-a:
# c*((a^4-b^4)/4 + a^2-b^2 + ln(a) - ln(b))/8 = b-a
# => c * ((a-b)(a+b)(a^2 + b^2 + 4)/4 + ln(a/b))/8 = b - a
# => c = 32(b-a) / ((a-b)(a+b)(a^2 + b^2 + 4) + 4*ln(a/b))
#
# That's one NASTY formula!
# Simplify further:
# c= 32(b-a) / ((a-b)(a+b)((a+b)^2 - 2ab + 4) + 4*ln(a/b))
# Put S = a+b, D=a-b
# c = -32D / (DS(S^2 - 2ab + 4) + 4*ln(a/b))
	
	
	
#	x approx 0:
#	x^2 + 1
#	Operands ratio: 1/x^2
#	bits shif12ed: B1 = |2log2(x)|
#	B1 >= 54
#	=> x >= 2^27 or x <= 2^(-27)
#	=> x >= 134,217,728 or x <= 7.450580596923828e-09
#
#	
#	
#	(x+1)^2 - 2x	
#	(x+1)^2 > 2x	(always, for x>=0)
#	(x+1)^2/(2x) =  x/2 + 1 + 1/2x
#	bits shif12ed: B2 = log2(x + 2 + 1/x) - 1
#	Cauchy: x + 1/x >= 2
#	=> B2 >= 1 bit
#	
#	B2 >= 54 => x + 2 + 1/x >= 2^54
#		=> x^2 - 2(2^53 - 1)x + 1 >= 0
#		=> x >= 1.8014398509481982e+16 or x <= 5.551115123e-17
