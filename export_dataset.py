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
dataset_raw      = load_dataset(config['dataset_name'], config['config_name'], split=config['split'], trust_remote_code=True)
# Remove unnecessary columns
dataset_modified = dataset_raw.remove_columns(['images'])

# Add unique ID to each row
dataset_modified = dataset_modified.map(add_unique_id)

# Export the dataset to a JSON file
dataset_modified.to_json(export_file_name)
print(f"Exported dataset to {export_file_name}")
