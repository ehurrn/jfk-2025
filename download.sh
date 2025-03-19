#!/bin/bash

# Check if the original urls.txt file exists
if [ ! -f "urls.txt" ]; then
  echo "Error: The file 'urls.txt' does not exist in the current directory."
  exit 1
fi

# Check if the new-urls.txt file exists
if [ ! -f "new-urls.txt" ]; then
  echo "Error: The file 'new-urls.txt' does not exist in the current directory."
  exit 1
fi

echo "Comparing new-urls.txt with urls.txt to find new URLs..."

# Use diff to find lines present in new-urls.txt but not in urls.txt
diff urls.txt new-urls.txt | grep '^>' | cut -c 3- > new_urls_to_download.txt

# Check if there are any new URLs to download
if [ -s "new_urls_to_download.txt" ]; then
  echo "Found new URLs. Starting download process..."

  # Read each new URL from the new_urls_to_download.txt file
  while IFS= read -r url; do
    # Extract the filename from the URL
    filename=$(basename "$url")

    # Check if the file already exists in the current directory
    if [ -e "$filename" ]; then
      echo "File '$filename' already exists. Skipping download."
    else
      echo "File '$filename' does not exist. Downloading from '$url'..."
      # Download the file using wget in quiet mode (-q)
      wget -q "$url"
      if [ $? -eq 0 ]; then
        echo "Successfully downloaded '$filename'."
      else
        echo "Error downloading '$filename' from '$url'."
      fi
    fi
  done < "new_urls_to_download.txt"

  # Clean up the temporary file
  rm "new_urls_to_download.txt"
else
  echo "No new URLs found in new-urls.txt compared to urls.txt."
fi

echo "Finished processing."
