import subprocess

# *** FUNCTIONS ***
def get_list(location):
    # Create an empty list
    file_list = []

    # Run 'ls' command on location
    proc = subprocess.run(['ls', '-v', location], capture_output=True, text=True)

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
    new_pad = new_padding
    # Get file extension
    file_ext = file_list[0]['ext']
    # Renumber files and change extention to 'tmp', other mv may overwrite
    for file in file_list:
        pad_fill = str(new_pad).zfill(8)
        old_file = f"{file['name']}.{file['padding']}.{file['ext']}"
        new_file = f"{file['name']}.{pad_fill}.tmp"
        print(f"Changing {old_file} to {file['name']}.{pad_fill}.{file['ext']}")
        subprocess.run(['mv', old_file, new_file], cwd=location)
        new_pad += 1

    # Change from 'tmp' back to original extention
    new_list = get_list(location)
    for file in new_list:
        old_file = f"{file['name']}.{file['padding']}.{file['ext']}"
        new_file = f"{file['name']}.{file['padding']}.{file_ext}"
        subprocess.run(['mv', old_file, new_file], cwd=location)

    return 0

# *** VARIABLES ***
source = input('Where should I be looking at? ')
padding = int(input('What number should it start at with no padding? '))

# *** EXECUTION ***
list_result = get_list(source)
renumber(source, list_result, padding)
