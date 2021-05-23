#----------Thach Thao----------#
#---------------------------------------------------------------
# NAIVE technique
# param[in] $a0 bound a
# param[in] $a1 bound b
# param[in] $a2 n
# return $f26: Double-precision calculation result.
#---------------------------------------------------------------
.data
	a: .word 0
	bound: .word 1000000000
	n: .word 1000000
	message1: .asciiz "Even division - left to right: "
	message2: .asciiz "Even division - right to left: "
	message3: .asciiz "Sloppily small - right to left: "
	enter: .asciiz "\n"
.text
lw $a1, bound
lw $a2, n
mtc1 $zero, $f0
main:
	j elr
reset:
	lw $a0, a
	addi $a3,$a2,0
	mtc1 $a0,$f2
	cvt.s.w $f2,$f2 #a
	mtc1 $a1,$f4
	cvt.s.w $f4,$f4 #b
	mtc1 $a2,$f6
	cvt.s.w $f6,$f6 #n
	add.d $f26,$f0,$f0
	jr $ra
even_division:
	sub.s $f4,$f4,$f2
	div.s $f6,$f4,$f6 #dx
	jr $ra
#---------------------------------------------------------------
# Even division - left to right
#---------------------------------------------------------------
	elr:
		jal reset
		jal even_division
		loop1:
			beq $a3,$a2,first_loop1
			beq $a3,1,last_loop1
			add.s $f2,$f4,$f0
			add.s $f4,$f2,$f6
			jal area	
			add.d $f26,$f26,$f20
			j done_loop1
		first_loop1:
			add.s $f4,$f2,$f6
			jal area
			add.d $f26,$f26,$f20
			j done_loop1
		last_loop1:
			add.s $f2,$f4,$f0
			mtc1 $a1,$f4
			cvt.s.w $f4,$f4
			jal area
			add.d $f26,$f26,$f20
			j end_loop1
		done_loop1:
			sub $a3,$a3,1
			j loop1
		end_loop1:
			cvt.d.s $f0,$f0
			add.d $f12,$f26,$f0
			li $v0,4
			la $a0,message1
			syscall
			li $v0,3
			syscall
			li $v0,4
			la $a0,enter
			syscall
#---------------------------------------------------------------
# Even division - right to left
#---------------------------------------------------------------
	erl:
		jal reset
		jal even_division
		loop2:
			beq $a3,$a2,first_loop2
			beq $a3,1,last_loop2
			add.s $f4,$f2,$f0
			sub.s $f2,$f4,$f6
			jal area
			add.d $f26,$f26,$f20
			j done_loop2
		first_loop2:
			sub.s $f2,$f4,$f6
			jal area
			add.d $f26,$f26,$f20
			j done_loop2
		last_loop2:
			add.s $f4,$f2,$f0
			mtc1 $a0,$f2
			cvt.s.w $f2,$f2
			jal area
			add.d $f26,$f26,$f20
			j end_loop2
		done_loop2:
			sub $a3,$a3,1
			j loop2
		end_loop2:
			cvt.d.s $f0,$f0
			add.d $f12,$f26,$f0
			li $v0,4
			la $a0,message2
			syscall
			li $v0,3
			syscall
			li $v0,4
			la $a0,enter
			syscall
#---------------------------------------------------------------
# Slopily small - right to left
#---------------------------------------------------------------
sm: 
	jal reset
	calculate_dx:
		cal: 	
			li $t0,2
			mtc1 $t0,$f1
			cvt.s.w $f1,$f1
			li $t0,2
			mtc1 $t0,$f3
			cvt.s.w $f3,$f3
		cal_loop:
			mul.s $f3,$f3,$f1
			beq $t0,$a2,cal_loop_done
			addi $t0,$t0,1
			j cal_loop
		cal_loop_done:
			add.s $f5,$f3,$f0 #2^n
			li $t0,1
			mtc1 $t0,$f1
			cvt.s.w $f1,$f1
			sub.s $f3,$f3,$f1 #2^n-1
			div.s $f3,$f4,$f3 #dx(1)
	calculate_dx_n:
		li $t0,2
		mtc1 $t0,$f1
		cvt.s.w $f1,$f1
		div.s $f5,$f5,$f1 #2^(n-1)
		mul.s $f6,$f5,$f3 #dx(n) = 2^(n-1)dx(1)
	loop3:
		beq $a3,$a2,first_loop3
		beq $a3,1,last_loop3
		li $t0,2
		mtc1 $t0,$f1
		cvt.s.w $f1,$f1
		div.s $f5,$f5,$f1 #2^(i-1)
		mul.s $f6,$f5,$f3 #dx(i)
		add.s $f4,$f2,$f0
		sub.s $f2,$f4,$f6
		jal area
		add.d $f26,$f26,$f20
		j done_loop3
	first_loop3:
		sub.s $f2,$f4,$f6
		jal area
		add.d $f26,$f26,$f20
		j done_loop3
	last_loop3:
		add.s $f4,$f2,$f0
		mtc1 $a0,$f2
		cvt.s.w $f2,$f2
		jal area
		add.d $f26,$f26,$f20
		j end_loop3
	done_loop3:
		sub $a3,$a3,1
		j loop3
	end_loop3:
		cvt.d.s $f0,$f0
		add.d $f12,$f26,$f0
		li $v0,4
		la $a0,message3		
		syscall
		li $v0,3
		syscall
		li $v0,4
		la $a0,enter
		syscall
end_main:
	li $v0,10
	syscall
#---------------------------------------------------------------
# Procedure calculate_f: calculate f(x) = 4 / (x^2 + 1)
# param[in] $f2 x
# return $f20: f(x)
#---------------------------------------------------------------
calculate_f:
	mul.s $f2,$f2,$f2
	li $t0,1
	mtc1 $t0,$f1
	cvt.s.w $f1,$f1
	add.s $f2,$f2,$f1
	li $t0,4
	mtc1 $t0,$f1
	cvt.s.w $f1,$f1
	div.s $f20,$f1,$f2
	jr $ra
#---------------------------------------------------------------
# Procedure area: calculate area of trapezoid a, b, h
# param[in] $f2 x1
# param[in] $f4 x2
# return $f20: result of area
#---------------------------------------------------------------
area:
	add $sp,$sp,-20 #adjust stack
	sw $ra,4($sp) #save return address
	s.s $f2,8($sp) #save x1
	s.s $f4,12($sp) #save x2
	s.s $f6,16($sp) #save dx
	jal calculate_f
	nop
	add.s $f8,$f20,$f0 #f(x1)
	add.s $f2,$f4,$f0
	jal calculate_f
	nop
	add.s $f10,$f20,$f0 #f(s2)
	l.s $f2,8($sp) #reload x1
	l.s $f4,12($sp) #reload x2
	sub.s $f6,$f4,$f2 #h = x2-x1
	add.s $f20,$f10,$f8 #$f20 = f(x1) + f(x2)
	li $t0,2
	mtc1 $t0,$f1
	cvt.s.w $f1,$f1
	div.s $f20,$f20,$f1 #$f20 = (f(x1)+f(x2))/2
	cvt.d.s $f6,$f6
	cvt.d.s $f20,$f20
	mul.d $f20,$f20,$f6 #area
	lw $ra,4($sp) #reload return address
	l.s $f6,16($sp) #reload dx
	add $sp,$sp,20 #resize stack
	jr $ra
