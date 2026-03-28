#!/bin/bash

# Configuration
MODELS_DIR="/home/cmcraft/.cache/llama.cpp"
OUTPUT_FILE="/var/lib/llama-cpp/models.ini"

# Clear existing file
echo "# Auto-generated models.ini" > "$OUTPUT_FILE"

# 1. Identify all vision projectors (mmproj)
# We store these in an array to match against later
mapfile -t projectors < <(ls "$MODELS_DIR" | grep -i "mmproj")

# 2. Iterate through all GGUF models that AREN'T projectors
for model_file in "$MODELS_DIR"/*.gguf; do
    filename=$(basename "$model_file")
    
    # Skip if it's a projector file
    [[ "$filename" =~ "mmproj" ]] && continue
    
    # Define a clean section name (strip extension)
    section_name="${filename%.*}"
    
    # 3. Match logic: Find a projector with a similar prefix
    # Adjust 'cut' fields or logic if your naming convention differs
    prefix=$(echo "$filename" | cut -d'-' -f1-2) 
    matched_mmproj=""
    
    for p in "${projectors[@]}"; do
        if [[ "$p" == *"$prefix"* ]]; then
            matched_mmproj="$MODELS_DIR/$p"
            break
        fi
    done

    # 4. Write to INI file
    echo "[$section_name]" >> "$OUTPUT_FILE"
    echo "model = $model_file" >> "$OUTPUT_FILE"
    if [ -n "$matched_mmproj" ]; then
        echo "mmproj = $matched_mmproj" >> "$OUTPUT_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
done

echo "Done! Generated $OUTPUT_FILE with $(grep -c '^\[' $OUTPUT_FILE) models."
