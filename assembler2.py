import sys
import os


def word_to_bin(word):
    case = {
        # List of existing parameters and opcodes:
        'WAIT': '00000000',
        'ADD': '00000101',
        'ADDI': '01010xxxx',
        'ADDU': '00000110',
        'ADDUI': '0110xxxx',
        'SUB': '00001001',
        'SUBI': '1001xxxx',
        'CMP': '00001011',
        'CMPI': '1011xxxx',
        'CMPU': '00001111',
        'CMPUI': '1111xxxx',
        'AND': '00000001',
        'OR': '00000010',
        'XOR': '00000011',
        'NOT': '01001111',
        'LSH': '10000100',
        'LSHI': '10000000',
        'RSH': '10000101',
        'RSHI': '10000001',
        'ALSH': '10000110',
        'ARSH': '10000111',
        'ALSHI': '10000010',
        'ARSHI': '10000011',
        'LOAD': '01000000',
        'STORE': '01000100',
        'STRUD':  '00000100',
        'STRLR':  '00001000',

        # List of the pseudo commands to be used in other method
        'BEQ': 'pseudo',
        'BNE': 'pseudo',
        'BGE': 'pseudo',
        'BHI': 'pseudo',
        'BLS': 'pseudo',
        'BLO': 'pseudo',
        'BHS': 'pseudo',
        'BGT': 'pseudo',
        'BLE': 'pseudo',
        'BLT': 'pseudo',
        'BCS': 'pseudo',
        'BCC': 'pseudo',
        'BFS': 'pseudo',
        'BFC': 'pseudo',
        'BUC': 'pseudo',
        'BNJ': 'pseudo',
        'JEQ': 'pseudo',
        'JNE': 'pseudo',
        'JGE': 'pseudo',
        'JHI': 'pseudo',
        'JLS': 'pseudo',
        'JLO': 'pseudo',
        'JHS': 'pseudo',
        'JGT': 'pseudo',
        'JLE': 'pseudo',
        'JLT': 'pseudo',
        'JCS': 'pseudo',
        'JCC': 'pseudo',
        'JFS': 'pseudo',
        'JFC': 'pseudo',
        'JUC': 'pseudo',
        'JNJ': 'pseudo',

        # List of all of the registers
        'r0': '0000',
        'r1': '0001',
        'r2': '0010',
        'r3': '0011',
        'r4': '0100',
        'r5': '0101',
        'r6': '0110',
        'r7': '0111',
        'r8': '1000',
        'r9': '1001',
        'r10': '1010',
        'r11': '1011',
        'r12': '1100',
        'r13': '1101',
        'r14': '1110',
        'r15': '1111',
        
    }

    if word.isdigit():
        return '{0:08b}'.format(int(word))
    bin = case.get(word, "ERROR")
    return bin

# TODO


def pseudo_to_bin(word):
    # Make a dictionary of all of the pseudo commands
    # Return array of opcodes
    case = {
        'BEQ': ['00001011', '11000000'],
        'BNE': ['00001011', '11000001'],
        'BGE': ['00001011', '11001101'],
        'BHI': ['00001011', '11000100'],
        'BLS': ['00001011', '11000101'],
        'BLO': ['00001011', '11001010'],
        'BHS': ['00001011', '11001011'],
        'BGT': ['00001011', '11000110'],
        'BLE': ['00001011', '11000111'],
        'BLT': ['00001011', '11001100'],
        'BCS': ['11000010'],
        'BCC': ['11000011'],
        'BFS': ['11001000'],
        'BFC': ['11001001'],
        'BUC': ['11001110'],
        'BNJ': ['11001111'],
        'JEQ': ['00001011', '010000001100'],
        'JNE': ['00001011', '010000011100'],
        'JGE': ['00001011', '010011011100'],
        'JHI': ['00001011', '010001001100'],
        'JLS': ['00001011', '010001011100'],
        'JLO': ['00001011', '010010101100'],
        'JHS': ['00001011', '010010111100'],
        'JGT': ['00001011', '010001101100'],
        'JLE': ['00001011', '010001111100'],
        'JLT': ['00001011', '010011001100'],
        'JCS': ['010000101100'],
        'JCC': ['010000111100'],
        'JFS': ['010010001100'],
        'JFC': ['010010011100'],
        'JUC': ['010011101100'],
        'JNJ': ['010011111100'],
    }
    bin = case.get(word, "ERROR")
    return bin


def form_opcode(bin_arr):
    opcode = ''

    if len(bin_arr[0]) == 12:
        op = bin_arr[0]
        rtarget = bin_arr[1]
        tmp = [op, rtarget]
        opcode = ''.join(tmp)
    elif bin_arr[0].find('x') == -1:
        op1 = bin_arr[0][0:4]
        op2 = bin_arr[0][4:8]
        rsrc = bin_arr[2]
        rdst = bin_arr[1]
        tmp = [op1, rdst, op2, rsrc]
        opcode = ''.join(tmp)
    else:
        op = bin_arr[0][0:4]
        rdst = bin_arr[1]
        imm = bin_arr[2]
        tmp = [op, rdst, imm]
        opcode = ''.join(tmp)

    return opcode

def form_pseudo(bin_arr):
    opcode = []

    if(len(bin_arr) == 6 and len(bin_arr[1]) == len(bin_arr[2])):
        op1 = bin_arr[1]
        op2 = bin_arr[2]
        rdest = bin_arr[3]
        rsrc = bin_arr[4]
        imm = bin_arr[5]
        op1a = op1[0:4]
        op1b = op1[4:8]
        tmp1 = [op1a, rdest, op1b, rsrc]
        opcode1 = ''.join(tmp1)
        opcode.append(opcode1)
        tmp2 = [op2, imm]
        opcode2 = ''.join(tmp2)
        opcode.append(opcode2)
    elif(len(bin_arr) == 3 and len(bin_arr[1]) == 8):
        op = bin_arr[1]
        imm = bin_arr[2]
        tmp = [op, imm]
        opcode1 = ''.join(tmp)
        opcode.append(opcode1)
    elif(len(bin_arr) == 6 and len(bin_arr[1]) != len(bin_arr[2])):
        op1 = bin_arr[1]
        op2 = bin_arr[2]
        rdest = bin_arr[3]
        rsrc = bin_arr[4]
        rtarget = bin_arr[5]
        op1a = op1[0:4]
        op1b = op1[4:8]
        tmp1 = [op1a, rdest, op1b, rsrc]
        opcode1 = ''.join(tmp1)
        opcode.append(opcode1)
        tmp2 = [op2, rtarget]
        opcode2 = ''.join(tmp2)
        opcode.append(opcode2)        
    else:
        op = bin_arr[1]
        rtarget = bin_arr[2]
        tmp = [op, rtarget]
        opcode1 = ''.join(tmp)
        opcode.append(opcode1)

    return opcode

def text_to_bin(text):
    op_arr = []
    for line in text:
        split = line.split(' ')
        tmp_arr = []
        for word in split:
            bin = word_to_bin(word)
            if bin == 'pseudo':
                tmp_arr.append('p')
                bin_arr = pseudo_to_bin(word)
                for code in bin_arr:
                    tmp_arr.append(code)
            else:
                tmp_arr.append(bin)
        if(tmp_arr[0] == 'p'):
            opcode = form_pseudo(tmp_arr)
            for code in opcode:
                op_arr.append(code)
        else:    
            opcode = form_opcode(tmp_arr)
            op_arr.append(opcode)
        tmp_arr = []
    return op_arr


'''
current_work_directory = os.getcwd()    # Return a string representing the current working directory.
print('Current work directory: {}'.format(current_work_directory))
# Make sure it's an absolute path.
abs_work_directory = os.path.abspath(current_work_directory)
print('Current work directory (full path): {}'.format(abs_work_directory))
print()
filename = '/ECE3710-Lab/instructions.txt'
# Check whether file exists.
if not os.path.isfile(filename):
    # Stop with leaving a note to the user.
    print('It seems file "{}" not exists in directory: "{}"'.format(filename, current_work_directory))
    sys.exit(1)
    STRUD r14 r0 prints e40
    STRLR r15 r0 prints f80
'''


file = open("instructions.txt", "r+")
raw_content = file.readlines()
file.close()

content = []

for line in raw_content:
    newLine = line.replace('\n', '')
    content.append(newLine)
opcodes = text_to_bin(content)

print(opcodes)

hex_opcodes = []
for op in opcodes:
    instr = hex(int(op, 2)) + '\n'
    hex_opcodes.append(instr.split('x')[1])

print(hex_opcodes)

hexFile = open("opcodes.hex", "w")
hexFile.writelines(hex_opcodes)
hexFile.close()
