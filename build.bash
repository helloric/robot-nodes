#!/bin/bash
# Set the name of the builder
BUILDER_NAME="helloricbuilder"

# Check if the builder already exists
if docker buildx inspect "$BUILDER_NAME" > /dev/null 2>&1; then
    echo "Builder '$BUILDER_NAME' already exists."
else
    echo "Builder '$BUILDER_NAME' does not exist. Creating a new one..."
    # Create a new builder with the docker-container driver
    docker buildx create --name "$BUILDER_NAME" --use --driver docker-container
    echo "Builder '$BUILDER_NAME' created."
fi
CURRENT_BUILDER=$(docker buildx ls | grep '*' | awk '{print $1}' | tr -d '*')
echo "Current Docker builder is: '$CURRENT_BUILDER'"

# 2. Change to the target builder.
echo "Switching to builder: '$BUILDER_NAME'"
docker buildx use "$BUILDER_NAME"
echo "Successfully switched to builder: '$BUILDER_NAME', building now:"

# --- the actual build command ---
docker compose build ricbot teleop ui ui_com ds4
# --- ---

echo "Switching back to the previous builder: '$CURRENT_BUILDER'"
docker buildx use "$CURRENT_BUILDER"

FINAL_BUILDER=$(docker buildx ls | grep '*' | awk '{print $1}' | tr -d '*')
echo "Verification: Current active builder is now: '$FINAL_BUILDER'"
if [ "$FINAL_BUILDER" == "$CURRENT_BUILDER" ]; then
    echo "Successfully reverted to the original builder."
else
    echo "Warning: The builder was not reverted to the original one."
fi
