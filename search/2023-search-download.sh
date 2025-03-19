#!/bin/bash

        # Base URL
        base_url="https://www.archives.gov/files/research/jfk/releases/2023/"

        # Naming scheme regex (updated to reflect the change)
        filename_regex="1--.pdf"

        # Loop through possible file numbers (starting with 1 followed by two digits)
        for i in $(seq 00 99); do # Iterate from 00 to 99 to append to '1'
          first_part="1$i"
          for j in $(seq 00000 99999); do
            # Format the filename
            filename=$(printf "%s-%05d-%05d.pdf" "$first_part" $j $((RANDOM % 100000))) # Use the constructed first part

            # Construct the full URL
            url="$base_url$filename"

            # Generate random batch size (25-100)
            batch_size=$((RANDOM % 76 + 25))

            # Generate random delay (10-59 seconds)
            delay=$((RANDOM % 50 + 10))

            # Download in batches
            for ((k=0; k<$batch_size; k++)); do
              # Check if the URL exists using wget --spider (quiet mode, no output file)
              if wget --spider --quiet "$url"; then
                echo "Downloading: $url"
                wget -q "$url" # Download quietly
              else
                echo "Skipping 404: $url"
              fi
            done

            echo "Waiting for $delay seconds..."
            sleep "$delay"
          done
        done

        echo "Finished checking URLs."
        ```

**Changes Made:**

1.  **Modified First Loop:**
    * The outer `for` loop now iterates from `00` to `99` using `seq 00 99`.
    * Inside this loop, we create a variable `first_part` by prepending `1` to the current value of `i`. This ensures the first three digits of the filename start with `1` followed by two other digits (from 00 to 99, resulting in 100 to 199).

2.  **Updated Filename Formatting:**
    * The `printf` command now uses the `$first_part` variable to construct the filename, ensuring it starts with `100` to `199`.

The rest of the script remains the same, maintaining the random batch sizes, delays, and 404 error handling.

**How to Use:**

1.  Save the updated script as a `.sh` file (e.g., `download_files_v2.sh`).
2.  Make it executable: `chmod +x download_files_v2.sh`
3.  Run it: `./download_files_v2.sh`

Now, the script will only look for filenames starting with `100` to `199` followed by the rest of the naming scheme.
