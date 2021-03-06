	.data
numIncorrectGuesses:	.word 0
wordLength:	.word 0
numLettersGuessed:	.word 0
wordToGuess: 	.asciiz "                                    "
prevGuessed:	.asciiz "                                    "
guessedLetters: .asciiz "                          "
numCorrectGuesses:	.word 0
.include "gallows.asm"
.include "dictionary.asm"

	.text
main:

	addi $s3, $zero, 1 #set $s3 to 1 for use later
	add $s4, $sp, $zero	#sets array up on stack
	addi $s5, $sp, 4	#sets array pointer
	la $t0, wordToGuess
	lb $s2, numIncorrectGuesses #sets $s2 to null bit
	addi $s1, $zero, -1	#set string length to -2 (to get correct value later)
	sw $s1, wordLength

	#list of registers: $s0 = 2, $s1 = nothing, $s2 = null, $s3 = 1, $s4 = $sp, $s5 = $sp (used to move up and down array), $s6 used in generateWord can be used in other things, $s7 = used to store imported char
	#		    $t0 = address of wordToGuess, $t1 = used in printChar, $t2 = used in checkForMatch
	#stack is used for the array - should that be changed?

#	li $v0, 4
#	la $a0, stringInput
#	syscall		#prompt user for input
#	li $v0, 8
#	la $a0, wordToGuess
#	li $a1, 256
#	syscall #loads a string into memory at string's address (max 256 chars)

	la $t0, wordToGuess
	li $t7, ' '

stackSetup:
	lb $a0, ($t0)
	jal addToStack		#adds onto stack
	addi $t0, $t0, 1
	bne $a0, $t7, stackSetup	#loops until a space is encountered


	addi $s0, $s0, 2
	sw $s0, ($sp)
	add $sp, $sp, -4	#takes 2 1's off the stack becasue there are 2 too many
	addi $sp, $sp, 24

	#Word inputed and store in memory; stack set up as array


loop:
	print_str("\n=====================================\n")

	la $t6, prevGuessed
	lw $t5, numLettersGuessed
	add $t4, $zero, $zero

	# Print letters already guessed
	print_str("Guessed letters: ")
	li $v0, 4
	la $a0, guessedLetters
	syscall
	print_str("\n")

	add $s5, $s4, $zero	#set $s5 to beginning of array

	addi $s3, $zero, 1
	jal generateWord

	print_img #sets $a1 to numIncorrectGuesses
	print_str("\n")

	lw $t3, numIncorrectGuesses
	beq $t3, 6, failure

	# Print number of incorrect guesses
	print_str("Incorrect guesses: ")
	li $v0, 1
	lw $a0, numIncorrectGuesses
	syscall
	print_str("\n")

	# Add guessed letter
	print_str("Guess a letter: ")
	li $v0, 12
	syscall	#inputs a character
	add $s7, $v0, $zero

	# Add guess
	add $a0, $v0, $zero
	jal addGuess
	beq $v0, 1, loop2 # Continue if the add was valid

	# Otherwise, error
	print_str("Letter already guessed.\n")
	j loop

loop2:
	add $s5, $s4, $zero
	jal checkForMatch
	add $t2, $zero, $zero

	lw $t3, wordLength
	lw $t4, numLettersGuessed
	beq $t3, $t4, success

	j loop

checkForMatch:
	la $t3, wordToGuess
	sub $t1, $s5, $s4
	div  $t1, $t1, 4
	add $a1, $t3, $t1
	lb $a0, ($a1)
	addi $s5, $s5, 4
	beq $a0, $s7, checkIfAlreadyGuessed	#checks to see if character guessed is the same as current character in word; if yes, see if it has been guessed before
	beq $s2, $a0, matchCompleted	#when a null byte is encountered - word is over
	j checkForMatch

checkIfAlreadyGuessed:
	la $t6, prevGuessed
	lw $t5, numLettersGuessed
	add $t4, $zero, $zero

checkIfAlreadyGuessedLoop:
	add $s6, $t4, $t6
	lb $t0, ($s6)
	beq $t4, $t5, storeSetup	#if all previously guessed chars have been examined and none are the same, continue
	beq $t0, $a0, checkForMatch	#if a char has already been guessed, go back to checkForMatch
	addi $t4, $t4, 1
	j checkIfAlreadyGuessedLoop

storeSetup:
addi $a3, $zero, 2
j matchFound

storeInPrev:
	add $t4, $t5, $t6
	sb $a0, ($t4)
	j soundGood

matchFound:
	sw $s2, ($s5)
	add $t2, $zero, 2	#used in finished to see if a char matched
	lw $t7, numLettersGuessed
	addi $t7, $t7, 1
	sw $t7, numLettersGuessed	#increments the number of letters guessed - used for
	j checkForMatch

matchCompleted:
	bne $t2, 2, incrementGuessesNum	#if the letter guessed was not in the word, then incorrectguessess++
	beq $a3, 2, storeInPrev
	j soundGood
	#jr $ra	#otherwise go back to loop

incrementGuessesNum:	#if the letter guessed was not in the word, then incorrectguessess++
	lw $t3, numIncorrectGuesses
	add $t3, $t3, 1
	sw $t3, numIncorrectGuesses
	j soundBad	#play sound for incorrect guess
	#jr $ra

generateWord:	#make a word with _ and letters
	lb $s6, 4($s5)
	beq $s6, $s3, print_
	beq $s6, $s2, printChar
	jr $ra

print_:		#if value in array is 1, then an underscore is printed
	print_str("_ ")
	addi $s5, $s5, 4
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
	print_str(" ")
	j generateWord

addToStack:
	lw $s1, wordLength
	addi $s1, $s1, 1
	sw $s1, wordLength
	add $sp, $sp, 4	#add 1 onto the stack
	sw $s3, ($sp)
	jr $ra

failure:	#reached from end of main loop
	print_str("\nYou have made too many incorrect guesses. Game Over")
	#insert sound for losing the game
	j end

success:	#reached from end of main loop
	print_str("\nYou have guessed all of the letters in the word. You Win\n")
	#insert sounds for winning the game
	j end

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

	jr $ra

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
	addi $sp, $sp, 20

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
	sb $a0, ($t3)
	li $v0, 1
	j endAddGuess

cantAddGuess:
	li $v0, 0
	j endAddGuess

endAddGuess:
	subi $sp, $sp, 20
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
	li $v0, 10
	syscall
