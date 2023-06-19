import subprocess

# *** FUNCTIONS ***

# Get list of files with 'ls'
def get_list(location):
    # Run 'ls' command 
    proc = subprocess.run(['ls', location], capture_output=True, text=True)

    # Create empty list to store files
    file_list = []

    # Iterate through proc stdout, split elements onto a dictionary and store it in file_list
    for file in proc.stdout.splitlines():
        split_list = file.split('.')
        file_dict = {
            'name': split_list[0],
            'padding': split_list[1],
            'ext': split_list[2]
        }
        file_list.append(file_dict)

    return file_list

# Rename files
def rename(location, file_list, new_file_name):
    for file in file_list:
        # Run 'mv' command
        old_file = f"{file['name']}.{file['padding']}.{file['ext']}"
        new_file = f"{new_file_name}.{file['padding']}.{file['ext']}"
        print(f"Changing {old_file} to {new_file}")
        proc = subprocess.run(['mv', old_file, new_file], cwd=location)
    return 0

# *** VARIABLES ***
source_path = input(f"First, let's define our source path, shall we?")
new_name = input(f"That's f'ing hot! What about the new name? What's it called?")

# *** EXECUTION ***
list_result = get_list(source_path)
rename(source_path, list_result, new_name)
