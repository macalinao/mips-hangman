	.data
<<<<<<< HEAD
space: .asciiz " "
underscore:	.asciiz "_"
newLine: .asciiz "\n"
numIncorrectGuesses: .word 0
stringIncorrectGuesses:	.asciiz "\nThe number of incorrect guesses is: "
stringInput: .asciiz "Please input a word: "
stringInput2: .asciiz "\nGuess a letter: "
winMsg:	.asciiz "\nCongratulations you Won!"
loseMsg:.asciiz "\nGame Over"
.include "gallows.asm"
.data
wordToGuess: .asciiz " "	#intentionally last - put other data structures before this
=======
endOfWord:	.asciiz "\r"
stringFailure:	.asciiz "\nYou have made too many incorrect guesses. Game Over"
stringSuccess:	.asciiz "\n You have guessed all of the letters in the word. You Win"
space:		.asciiz " "
underscore:	.asciiz "_"
newLine:		.asciiz "\n"
numIncorrectGuesses:	.word 0
stringIncorrectGuesses:	.asciiz "\nThe number of incorrect Guesses is: "
stringInput: 	.asciiz "Please input a word: "
stringInput2:	.asciiz "\nGuess a Letter "
wordLength:	.word 0
numLettersGuessed:	.word 0
wordToGuess: 	.asciiz "                                    "
guessedLetters: .asciiz "                          "
.include "gallows.asm"
.include "dictionary.asm"
>>>>>>> a49a0c35e82c2338a79d05649a3ffa1e480fe214

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
<<<<<<< HEAD
	
	print_str("\n")
=======

	addi $s3, $zero, 1
	jal generateWord

>>>>>>> a49a0c35e82c2338a79d05649a3ffa1e480fe214
	print_img #sets $a1 to numIncorrectGuesses
	print_str("\n")

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

	# Add guess
	#jal addGuess
	#beq $v0, 1, loop2 # Continue if the add was valid

	# Otherwise, error
	#print_str("Letter already guessed.\n")
	#j loop

loop2:
	jal checkForMatch
	add $t2, $zero, $zero

	lw $t3, numIncorrectGuesses
	beq $t3, 3, end

	j loop

checkForMatch:
	la $t3, wordToGuess
	sub $t1, $s5, $s4
	srl $t1, $t1, 2
	add $a1, $t3, $t1
	lb $a0, ($a1)
	sll $s5, $s5, 2
	beq $a0, $s7, matchFound
	beq $s2, $a0, matchCompleted
	j checkForMatch

matchFound:
	sw $s2, ($s5)
	add $t2, $zero, 2	#used in finished to see if a char matched
<<<<<<< HEAD
	j soundGood
	#j checkForMatch

matchCompleted:
	bne $t2, 2, incrementGuessesNum
	jr $ra
=======
	lw $t7, numLettersGuessed
	addi $t7, $t7, 1
	sw $t7, numLettersGuessed	#increments the number of letters guessed - used for
	j checkForMatch

matchCompleted:
	bne $t2, 2, incrementGuessesNum	#if the letter guessed was not in the word, then incorrectguessess++
	j soundGood
	#jr $ra	#otherwise go back to loop
>>>>>>> a49a0c35e82c2338a79d05649a3ffa1e480fe214

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

#####
# addGuess(char)
#
# Adds a guess.
# Arg: $a0 - the character guessed
# Ret: $v0 - contained ? 1 : 0
#####
addGuess:
	# Load our constants
	li $t0, ' '
	li $t1, 0
	la $t2, guessedLetters

addGuessLoop:
	subi $sp, $sp, 20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)

	# Find character
	add $t3, $t1, $t2
	lbu $t4, ($t3)
	beq $t0, $t4, doAddGuess

	# Return false if exists
	beq $a0, $t4, cantAddGuess

	# Increment by 1
	addi $t1, $t1, 1
	j addGuessLoop

doAddGuess:
	lbu $t3, ($a0)
	li $v0, 1
	j endAddGuess

cantAddGuess:
	li $v0, 0
	j endAddGuess

endAddGuess:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	addi $sp, $sp, 20

	jr $ra
#####
# END addGuess
#####

end:
	li $v0 10
	syscall
