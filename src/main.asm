	.data
space: .asciiz " "
underscore:	.asciiz "_"
newLine: .asciiz "\n"
numIncorrectGuesses: .word 0
stringIncorrectGuesses:	.asciiz "\nThe number of incorrect guesses is: "
stringInput: .asciiz "Please input a word: "
stringInput2: .asciiz "\nGuess a letter: "
wordToGuess: .asciiz " "	#intentionally last - put other data structures before this
.include "gallows.asm"
	.text

main:
	addi $s3, $s3, 1 #set $s3 to 1 for use later
	add $s4, $sp, $zero
	addi $s5, $sp, 4
	la $t0, wordToGuess
	lb $s2, 1000($t0) #sets $s2 to null bit

	#list of registers: $s0 = 2, $s1 = nothing, $s2 = null, $s3 = 1, $s4 = $sp, $s5 = $sp (used to move up and down array), $s6 used in generateWord, $s7 = used to store imported char
	#		    $t0 = address of wordToGuess, $t1 = used in printChar
	#stack is used for the array - should that be changed?

	li $v0, 4
	la $a0, stringInput
	syscall		#prompt user for input
	li $v0, 8
	la $a0, wordToGuess
	li $a1, 256
	syscall #loads a string into memory at string's address (max 256 chars)

	la $t0, wordToGuess

stackSetup:
	lb $a0, ($t0)
	jal addToStack		#adds onto stack
	addi $t0, $t0, 1
	bne $a0, $s2, stackSetup	#loops until a null character is encountered

	sw $s2, ($sp)
	add $sp, $sp, -4	#takes 2 1's off the stack becasue there are 2 too many

	addi $s0, $s0, 2
	sw $s0, ($sp)
	add $sp, $sp, -4	#takes 2 1's off the stack becasue there are 2 too many

	#Word inputed and store in memory; stack set up as array

loop:
	li $v0, 4
	la $a0, newLine
	syscall
	add $s5, $s4, $zero	#set $s5 to beginning of array

	jal generateWord

	la $a0, stringIncorrectGuesses
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, numIncorrectGuesses
	syscall	#prints number of Incorrect Guesses

	la $a0, stringInput2
	li $v0, 4
	syscall
	li $v0, 12
	syscall	# inputs a character
	add $s7, $v0, $zero

	add $s5, $s4, $zero
	jal checkForMatch
	add $t2, $zero, $zero

	lw $t3, numIncorrectGuesses
	beq $t3, 3, end

	j loop

checkForMatch:
	la $t3, wordToGuess
	sub $t1, $s5, $s4
	div  $t1, $t1, 4
	add $a1, $t3, $t1
	lb $a0, ($a1)
	addi $s5, $s5, 4
	beq $a0, $s7, matchFound
	beq $s2, $a0, matchCompleted
	j checkForMatch

matchFound:
	sw $s2, ($s5)
	add $t2, $zero, 2	#used in finished to see if a char matched
	j soundGood
	#j checkForMatch

matchCompleted:
	bne $t2, 2, incrementGuessesNum
	jr $ra

incrementGuessesNum:
	lw $t3, numIncorrectGuesses
	add $t3, $t3, 1
	sw $t3, numIncorrectGuesses
	
	j soundBad
	#jr $ra

generateWord:	#make a word with _ and letters
	lb $s6, 4($s5)
	beq $s6, $s3, print_
	beq $s6, $s2, printChar
	jr $ra

print_:		#if value in array is 1, then an underscore is printed
	la $a0, underscore
	li $v0, 4
	syscall

	addi $s5, $s5, 4
	lb $a0, space
	li $v0, 11
	syscall	#prints a space so underscores can be told apart
	j generateWord

printChar:	#if value in array is 0, then the character from that spot is printed
	la $t3, wordToGuess
	sub $t1, $s5, $s4
	div  $t1, $t1, 4
	add $a1, $t3, $t1
	lb $a0, ($a1)
	li $v0, 11
	syscall

	addi $s5, $s5, 4
	lb $a0, space
	li $v0, 11
	syscall	#prints a space so underscores can be told apart
	j generateWord

addToStack:
	add $sp, $sp, 4	#add 1 onto the stack
	sw $s3, ($sp)
	jr $ra

soundBad:

	li $v0, 33	#Number for syscall
	li $a0, 40	#Pitch
	li $a1, 1000	#Duration
	li $a2, 56	#Instrument
	li $a3, 127	#Volume
	syscall
	
	jr $ra
	
soundGood:
	
	li $v0, 33	#Number for syscall
	li $a0, 62	#Pitch
	li $a1, 250	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall
	
	li $v0, 33	#Number for syscall
	li $a0, 67	#Pitch
	li $a1, 1000	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

	j checkForMatch

end:
