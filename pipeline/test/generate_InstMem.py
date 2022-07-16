import os

file_name = "bf"
file_path = os.path.join(os.path.join(os.getcwd(), "inst_hex"), file_name + ".hex")
gen_file_path = os.path.join(os.path.join(os.getcwd(), "inst_mem"), file_name + ".txt")

content = []

with open(file_path, "r") as file:
    content = file.readlines()

with open(gen_file_path, "w") as file:
    for i in range(len(content)):
        file.write(f"8'd{i}: Instruction <= 32'h" + content[i].replace("\n", ";\n"))