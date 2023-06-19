import subprocess

# *** FUNCTIONS ***
def get_list(location):
    # Create an empty list
    file_list = []

    # Run 'ls' command on location
    proc = subprocess.run(['ls', location], capture_output=True, text=True)

    # Iterate through proc stdout, split elements onto a dictionary and store it on file_list
    for file in proc.stdout.splitlines():
        split_list = file.split('.')
        file_dict = {
            'name': split_list[0],
            'padding': split_list[1],
            'ext': split_list[2]
        }
        file_list.append(file_dict)
    
    return file_list

def renumber(location, file_list, new_padding):
    padding = new_padding
    # Run 'mv' command
    for file in file_list:
        old_file = f"{file['name']}.{file['padding']}.{file['ext']}"
        print(f"Changing {old_file} to {file['name']}.{padding}.{file['ext']}")
        subprocess.run(['mv', old_file, f"{file['name']}.{padding}.{file['ext']}"], cwd=location)
        padding += 1
    return 0


# *** VARIABLES ***
source = input('Where should I be looking at? ')
padding = int(input('What number should it start at with no padding? '))

# *** EXECUTION ***
list_result = get_list(source)
