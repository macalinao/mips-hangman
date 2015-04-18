.data
manhead:	.asciiz " O"
topspine:	.asciiz " |"
botharms:	.asciiz "/|\\"
bottomspine:	.asciiz " |"
bothlegs:	.asciiz "/ \\"
.text
.macro check_letter (%letter %wordAddress)
###
.end_macro

.macro draw_man (%bodyParts)

.end_macro

	
	lw $a0, botharms
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
