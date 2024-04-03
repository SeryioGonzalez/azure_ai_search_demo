import math
import os
import subprocess
import sys

import helpers

export_file_name = sys.argv[1]
max_file_size    = int(sys.argv[2])

if export_file_name == '':
    print('ERROR: Please provide the export file name as an argument')
    sys.exit(1)

if max_file_size  == '':
    print('ERROR: Please provide the max file size as an argument')
    sys.exit(1)

# Load the configuration file
config=helpers.parse_config('config.sh')

# Check the size of the file
file_size = os.path.getsize(export_file_name)

# Calculate the number of files to split the dataset
num_files_to_split = math.ceil(file_size / max_file_size) + 1

count_lines_command = ['wc', '-l', export_file_name]
result = subprocess.run(count_lines_command, stdout=subprocess.PIPE, text=True)
number_of_lines_in_file = int(result.stdout.split()[0])

num_lines_per_file = math.ceil(number_of_lines_in_file / num_files_to_split)

print(num_lines_per_file)

