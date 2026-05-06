#!/usr/bin/env python3
import os

content_dir = '/home/luis/projects/guisho.com/content'
old_url = 'https://guisho-media.s3.amazonaws.com/uploads/'
new_url = '/uploads/'

total_replacements = 0
files_modified = 0

for root, dirs, files in os.walk(content_dir):
    for filename in files:
        if filename.endswith('.md'):
            filepath = os.path.join(root, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()

            count = content.count(old_url)
            if count > 0:
                new_content = content.replace(old_url, new_url)
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                total_replacements += count
                files_modified += 1

print(f'Total replacements made: {total_replacements}')
print(f'Files modified: {files_modified}')
