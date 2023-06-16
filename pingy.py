import subprocess

def ping_servers(servers):

    # Command to Execute
    cmd = 'ping'

    # List containing output results
    output_list = []

    # Iterate through server list
    for server in servers:
        temp = subprocess.Popen([cmd, '-c 1', server], stdout=subprocess.PIPE)
        # Get the output as a string
        output = str(temp.communicate())
        # Store the output in the list
        output_list.append(output)
    
    return output_list

if __name__ == '__main__':
    servers = list(open('test.txt'))

    # Iterate through list on text file to avoid any blank spaces
    for i in range(len(servers)):
        servers[i] = servers[i].strip('\n')
    
    # Get result by running function
    result = ping_servers(servers)
    for info in result:
        print(info)