#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Analyze LÖVE2D game executable and extract resources
"""

import os
import zipfile
import tempfile
import shutil

EXE_PATH = r"C:\Users\chengtianyi\Downloads\KR ReBBBorn-2-1-0-2-1742571510\Kingdom Rush.exe"
OUTPUT_DIR = r"C:\Users\chengtianyi\Downloads\KR ReBBBorn-2-1-0-2-1742571510\extracted_resources"

def analyze_file():
    """Analyze the file structure"""
    print(f"Analyzing: {EXE_PATH}")
    print(f"File size: {os.path.getsize(EXE_PATH) / (1024*1024):.2f} MB")
    
    with open(EXE_PATH, 'rb') as f:
        # Check file signature
        header = f.read(512)
        print(f"\nFile header (hex): {header[:20].hex()}")
        print(f"File header (ascii): {header[:100]}")
        
        # Look for .love file markers
        # LÖVE games typically have the .love data appended to the exe
        # or as a separate .love file
        f.seek(0)
        content = f.read()
        
        # Search for PK (zip) signature which indicates .love file
        # .love files are essentially zip files
        pk_pos = content.find(b'PK\x03\x04')
        if pk_pos != -1:
            print(f"\n[OK] Found ZIP/PK signature at position: {pk_pos}")
            print(f"This suggests the .love data starts at byte {pk_pos}")
            return pk_pos
        
        # Search for .love extension marker
        love_marker = content.find(b'.love')
        if love_marker != -1:
            print(f"\n[OK] Found .love marker at position: {love_marker}")
        
        return None

def extract_love_data(start_position):
    """Extract the .love data from the executable"""
    print(f"\nExtracting from position {start_position}...")
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    with open(EXE_PATH, 'rb') as f:
        f.seek(start_position)
        love_data = f.read()
    
    # Save as .love file (which is just a zip)
    love_file_path = os.path.join(OUTPUT_DIR, 'game.love')
    with open(love_file_path, 'wb') as f:
        f.write(love_data)
    
    print(f"[OK] Saved .love file to: {love_file_path}")
    print(f"  Size: {len(love_data) / (1024*1024):.2f} MB")
    
    # Try to extract as zip
    try:
        with zipfile.ZipFile(love_file_path, 'r') as zip_ref:
            print(f"\n[OK] Successfully opened as ZIP!")
            print(f"Files in archive: {len(zip_ref.namelist())}")
            
            # List all files
            print("\nContents:")
            for name in zip_ref.namelist()[:50]:  # First 50 files
                info = zip_ref.getinfo(name)
                print(f"  {name} ({info.file_size} bytes)")
            
            if len(zip_ref.namelist()) > 50:
                print(f"  ... and {len(zip_ref.namelist()) - 50} more files")
            
            # Extract all
            zip_ref.extractall(OUTPUT_DIR)
            print(f"\n[OK] Extracted all files to: {OUTPUT_DIR}")
            
    except zipfile.BadZipFile:
        print("[ERROR] Not a valid ZIP file, trying different approach...")
        return False
    
    return True

def main():
    pk_pos = analyze_file()
    
    if pk_pos:
        # Try to find the actual start of the .love data
        # Sometimes there's a small offset
        for offset in range(pk_pos, min(pk_pos + 1000, os.path.getsize(EXE_PATH)), 2):
            with open(EXE_PATH, 'rb') as f:
                f.seek(offset)
                if f.read(4) == b'PK\x03\x04':
                    pk_pos = offset
                    break
        
        print(f"\nRefined ZIP position: {pk_pos}")
        extract_love_data(pk_pos)
    else:
        print("\n[ERROR] Could not find .love data in executable")
        print("The game might be using a different packaging method")

if __name__ == '__main__':
    main()
