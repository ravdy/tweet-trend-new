#!/bin/bash

# Print the current working directory
echo "Current directory: $(pwd)"

# Print Maven version to ensure it's installed
mvn -v

# Run Maven deploy command
mvn clean deploy
