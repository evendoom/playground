import subprocess
"""
kinky = (subprocess.run(['ls', '-l'], shell=True, capture_output=True, text=True, check=True))

for line in kinky.stdout.splitlines():
    print("stdout:", line)
"""

"""
proc = subprocess.run(['ls', '', '/workspace/playground/ads/volume_1/projects/project_4/'], capture_output=True, text=True)
for line in proc.stdout.splitlines():
    print(line)
"""
"""
stree = 'test.000.tst'
lee = stree.split('.')
gee = {
    'name': lee[0],
    'frame': lee[1],
    'ext': lee[2]
}
print(gee)
"""

# subprocess.run(['mv','test.000.tst', 'test.001.tst'])
"""
x='hello'
print(f'she is {x}')
"""
location='/workspace/playground/'
subprocess.run(['mv', 'test002.tst', 'test.003.tst'], cwd=location)