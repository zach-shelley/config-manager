#!/bin/bash

create_env() {
    env_type="$1"

    if [ -z "$env_type" ]; then 
        echo "Error: Need input" 
        return 1
    fi

    if [ -f ".env.$env_type" ]; then
        echo "File exists."
        return 1
    fi
    new_env=".env.$env_type"
    touch "$new_env"
    chmod 600 $new_env

    echo "Please provide a value for APP_NAME?"
    read APP_NAME

    if [ -z "$APP_NAME" ]; then
        echo "Error: Value needed for APP_NAME"
        return 1
    else
        echo "export APP_NAME='$APP_NAME'" >> $new_env
    fi


    echo "Please provide a value for DATABASE_URL"
    read DATABASE_URL

    if [ -z "$DATABASE_URL" ]; then
        echo "Error: Value needed for DATABASE_URL"
        return 1
    else 
        echo "export DATABASE_URL='$DATABASE_URL'" >> $new_env
    fi

    echo "Please provide a value for API_KEY"
    read API_KEY

    if [ -z "$API_KEY" ]; then
        echo "Error: Value needed for API_KEY"
        return 1
    else
        echo "export API_KEY='$API_KEY'" >> $new_env
    fi
}
load_env() {
    env_name="$1"

    if [ -z $env_name ]; then 
        echo "Error: Please provide environment name"
        return 1
    fi

    env_file=".env.$env_name"
    # ! here means reverse (if the file does not exist)
    if [ ! -f "$env_file" ]; then
        echo "Error: $env_file not found"
        echo "Available environments:"
        ls .env.* 2>/dev/null
        return 1
    fi

    source $env_file

    if [ -z "$APP_NAME" ]; then
        echo "Error: Variable not loaded"
        return 1
    fi
    echo "$APP_NAME"
    echo "$DATABASE_URL"
    echo "API Key: ${API_KEY:0:8}***"
}
list_envs() {
    setopt localoptions nullglob
    
    echo "Available environments:"
    
    local found=false
    
    for env_file in .env.*; do
        found=true
        env_name=${env_file#.env.}
        count=$(wc -l < "$env_file" | xargs)
        echo "  - $env_name ($count variables)"
    done
    
    if [ "$found" = false ]; then
        echo "No environment files found. Create one with: create_env <name>"
    fi
}