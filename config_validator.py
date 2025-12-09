import sys
import os

def read_env_file(filepath):
    """Read .env file and return dict of variables"""

    if not os.path.exists(filepath):
        print("Error: Path does not exist.")
        sys.exit(1)

    env_vars = {}

    with open(filepath, 'r') as file:
        for line in file:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            if '=' not in line:
                continue

            key, value = line.split('=', 1)

            key = key.replace('export ', '').strip()
            value= value.strip().strip("'\"")
            env_vars[key]=value

    return env_vars

def validate_env(env_dict, required_vars):
    missing_list = []
    for var in required_vars:
        if var not in env_dict:
            missing_list.append(f'{var} (missing)')
        elif not env_dict[var]:
            missing_list.append(f'{var} (empty)')
        elif 'your_' in env_dict[var].lower():
            missing_list.append(f'{var} (placeholder)')

    is_valid = not missing_list
    return (is_valid, missing_list)

def main():
    required_variables = ['APP_NAME', 'DATABASE_URL', 'API_KEY']

    if len(sys.argv) < 2:
        print("Usage: python3 env_validator.py <env-file>")
        sys.exit(1)
    env_dict = read_env_file(sys.argv[1])
    is_valid, missing = validate_env(env_dict, required_variables)
    if is_valid:
        print(f"{sys.argv[1]} is valid")
    else:
        print(f"{sys.argv[1]} is invalid")
        print(f"Missing: {', '.join(missing)}")
        sys.exit(1)

if __name__ == "__main__":
    main()


