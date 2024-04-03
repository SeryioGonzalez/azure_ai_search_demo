import math
from datasets import load_dataset
import json
import os
import sys

import helpers

export_file_name = sys.argv[1]

if export_file_name == '':
    print('ERROR: Please provide the export file name as an argument')
    sys.exit(1)

id = 0
def add_unique_id(dataset_row):
    # Here, we're generating a unique ID using the index. You could also use uuid4() or other methods.
    global id
    dataset_row['id'] = id
    id += 1
    return dataset_row

# Load the configuration file
config=helpers.parse_config('config.sh')

# Load the dataset
if 'dataset_config_name' in config:
    if 'dataset_split' in config:
        dataset_raw = load_dataset(config['dataset_name'], config['dataset_config_name'], split=config['dataset_split'], trust_remote_code=True)
    else:
        dataset_raw = load_dataset(config['dataset_name'], config['dataset_config_name'], trust_remote_code=True)
else:
    dataset_raw = load_dataset(config['dataset_name'], trust_remote_code=True)

# Remove unnecessary columns
undesired_columns = [key for key in config.keys() if key.startswith('dataset_undesired_column_')]
if len(undesired_columns) == 0:
    print("No undesired columns found")
    dataset_modified = dataset_raw
else:
    for undesired_column in undesired_columns:
        print(f"Removing column {config[undesired_column]}")
        dataset_modified = dataset_raw.remove_columns(config[undesired_column])

# Add unique ID to each row
dataset_modified = dataset_modified.map(add_unique_id)

# Export the dataset to a JSON file
dataset_modified.to_json(export_file_name)
print(f"Exported dataset to {export_file_name}")
