


def parse_config(file_path):
    """
    Parses a bash-like configuration file and returns a dictionary of configurations.

    :param file_path: Path to the config file.
    :return: A dictionary with the configuration variables.
    """
    config = {}
    with open(file_path, 'r') as file:
        for line in file:
            # Strip whitespace and ignore empty lines and comments
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            # Split on the first equals sign
            if '=' in line:
                key, value = line.split('=', 1)
                key = key.strip()
                
                # Attempt to resolve variables within the value
                value = value.strip().replace('"', '')  # Remove any double quotes
                for var in config:
                    value = value.replace(f"${{{var}}}", config[var]).replace(f"${var}", config[var])
                
                # Special handling for concatenation with variables, assuming simple cases
                if '+' in value:
                    parts = value.split('+')
                    value = ''.join(parts).strip()

                config[key] = value

    return config
