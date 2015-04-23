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
lw $a0, numIncorrectGuesses
beq $a0, $0, g1
head:		print_str("        | ||     O\n") 
addi $t0, $a0, -2
beq $a0, $0, g2
j g2
hiBack:		print_str("    O/o | ||     |   \n")
leftArm:	print_str("    O/o | ||    /|   \n")
rightArm:	print_str("    O/o | ||    /|\\ \n")
j g3
loBack:		print_str("   /|  \\| ||     |  \n")
j g4
leftLeg:	print_str("   _|___| ||___ /    \n")
rightLeg:	print_str("   _|___| ||___ / \\ \n") 

g1:	print_str("        | ||\n")
g2:	print_str("    O/o | ||\n")
g3:	print_str("   /|  \\| ||\n")
g4:	print_str("   _|___| ||___\n")
#################################

#Unchanging strings
g5:
print_str("  // \\  | ||  /|\n")
print_str(" /      |_|/ / /\n")
print_str("/___________/ /\n")
print_str("|___________|/\n")
.end_macro
