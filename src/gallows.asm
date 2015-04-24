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
print_str("         _\n")
print_str("        /_/|\n")
print_str("        | |+-----o\n")
print_str("        | ||     |\n")

#Prints different parts of gallows
##################################
	# 0 incorrect guesses
	
	print_str("        | ||\n")     # O
	print_str("    O/o | ||\n")	#/|\
	print_str("   /|  \\| ||\n")	# |
	print_str("   _|___| ||___\n")	#/ \
	j bottom
	# 1 incorrect guess
	print_str("        | ||     O\n") 
	print_str("    O/o | ||\n")
	print_str("   /|  \\| ||\n")	
	print_str("   _|___| ||___\n")	
	j bottom
	#2 incorrect guesses
	print_str("        | ||     O\n") 
	print_str("    O/o | ||     |   \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___\n")
	j bottom
	#3 incorrect guesses
	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|   \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___\n")
	j bottom
	#4 incorrect guesses
	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|\\ \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___\n")
	#5 incorrect guesses
	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|\\ \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___ /    \n")
	#6 incorrect guesses
	print_str("        | ||     O\n") 
	print_str("    O/o | ||    /|\\ \n")
	print_str("   /|  \\| ||     |  \n")
	print_str("   _|___| ||___ / \\ \n") 
	
#################################

#Unchanging strings
bottom:
print_str("  // \\  | ||  /|\n")
print_str(" /      |_|/ / /\n")
print_str("/___________/ /\n")
print_str("|___________|/\n")
.end_macro
