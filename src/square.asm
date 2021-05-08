#--------------------SQUARE----------------
# Maintainer: Tran Lam
#
# Integrate f(x) = 4/((x+1)^2 - 2x)
# @param $a0: (int) begin bound
# @param $a1: (int) end bound
# @param $a2: (int) number of sample points
# @return $f26: (double) integration result
#------------------------------------------
# Implementation-specific details:
# @param $a3: (label) f(x)dx approximate function
# 		(I'm talking about Simpson's rule)

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

# REGISTERS LOOKUP TABLE
	# $s0 = integration counter (from 0 to n-1)
	# $f0 = a = x
	# $f2 = b
	# $f4 = n
	# $f6 = dx
	# $f8 = f(x)
	# $f10= f(x)dx
	# $f12= 1.0
	# $f14= 2.0
	# $f16= 4.0
	
.text
SQUARE:
	li	$a0 2
	li	$a1 0
	li	$a2 100000
	
	l.d	$f12 one.d($zero)
	l.d	$f14 two.d($zero)
	l.d	$f16 four.d($zero)
	
	addi	$sp $sp -4
	#sw	$ra 0($sp)	
	#jal QUICK_SAVE
 
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
	
	j SQ_CALCULATE_DX	# set $f6 = dx
		
	AFTERMATH: 
	
	mtc1	$zero $f26	# Reset output $f26 to zero
	mtc1	$zero $f27 
	
	li	$s0 0	# Reset counter
	
	INTEGRATE:
		j SQ_CALCULATE_FX		# set $f8 = f(x)
		SQ_CALCULATE_FX_DONE:
		mul.d	$f10 $f8  $f6		# $f10 = f(x)dx
		add.d	$f26 $f26 $f10		# Result += f(x)dx
		add.d	$f0  $f0  $f6		# x += dx (increment)
		addi	$s0 $s0 1		# ++counter
		blt	$s0 $a2 INTEGRATE	# Go back if we haven't added all the small trapezoids
		
	#jal QUICK_LOAD 
	#lw	$ra 0($sp)
	addi	$sp $sp 4
	j	EXPERIMENT
	#jr	$ra	


SQ_CALCULATE_DX:	# In the future, this will be replaced
			# with calculation based on derivative amplitude
		
	sub.d	$f6 $f2 $f0	# find total length: b-a
	
	div.d	$f6 $f6 $f4	# dx = length / n
	
	j	AFTERMATH
	
# Set $f8 = f(x)
SQ_CALCULATE_FX:	# f(x) = 4 / ((x+1)^2 - 2x)
# I may use Hybrid method in the future
# But for now, this is enough
	add.d	$f18 $f12 $f0	# $f18 = 1 + x
	mul.d	$f18 $f18 $f18	# $f18 = (1+x)^2
	mul.d	$f20 $f14 $f0	# $f20 = 2x
	sub.d	$f18 $f18 $f20	# $f18 = denominator
	div.d	$f8  $f16 $f18	# $f8 = f(x) = 4 / denominator
	
	j SQ_CALCULATE_FX_DONE
	
EXPERIMENT:
	
#	x approx 0:
#	x^2 + 1
#	Operands ratio: 1/x^2
#	bits shifted: B1 = |2log2(x)|
#	B1 >= 54
#	=> x >= 2^27 or x <= 2^(-27)
#	=> x >= 134,217,728 or x <= 7.450580596923828e-09
#
#	
#	
#	(x+1)^2 - 2x	
#	(x+1)^2 > 2x	(always, for x>=0)
#	(x+1)^2/(2x) =  x/2 + 1 + 1/2x
#	bits shifted: B2 = log2(x + 2 + 1/x) - 1
#	Cauchy: x + 1/x >= 2
#	=> B2 >= 1 bit
#	
#	B2 >= 54 => x + 2 + 1/x >= 2^54
#		=> x^2 - 2(2^53 - 1)x + 1 >= 0
#		=> x >= 1.8014398509481982e+16 or x <= 5.551115123e-17
