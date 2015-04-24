.text
	.macro 	print_str (%str)  #prints the string of a given label
	.data	
string:	.asciiz %str
	.text
	li $v0, 4
	la $a0, string
	syscall
	.end_macro
	
.macro print_img
#Unchanging strings
print_str("\n          _\n")
print_str("        /_/|\n")
print_str("        | |+-----o\n")
print_str("        | ||     |\n")

#Prints different parts of gallows
##################################
	lw $a0, numIncorrectGuesses
	# 0 incorrect guesses
	beq $a0, 1, g1
	beq $a0, 2, g2
	beq $a0, 3, g3
	beq $a0, 4, g4
	beq $a0, 5, g5
	beq $a0, 6, g6
	print_str("        | ||\n")     # O
	print_str("    O/o | ||\n")	#/|\
	print_str("   /|  \\| ||\n")	# |
	print_str("   _|___| ||___\n")	#/ \
	j bottom
	# 1 incorrect guess
g1:	print_str("        | ||     O\n") 
	print_str("    O/o | ||\n")
	print_str("   /|  \\| ||\n")	
	print_str("   _|___| ||___\n")	
	j bottom
	#2 incorrect guesses
g2:	print_str("        | ||     O\n") 
	print_str("    O/o | ||     |   \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___\n")
	j bottom
	#3 incorrect guesses
g3:	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|   \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___\n")
	j bottom
	#4 incorrect guesses
g4:	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|\\ \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___\n")
	j bottom
	#5 incorrect guesses
g5:	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|\\ \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___ /    \n")
	j bottom
	#6 incorrect guesses
g6:	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|\\ \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___ / \\ \n") 
	j bottom
	
#################################

#Unchanging strings
bottom:
print_str("  // \\  | ||  /|\n")
print_str(" /      |_|/ / /\n")
print_str("/___________/ /\n")
print_str("|___________|/\n")
.end_macro
