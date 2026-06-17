import os
import re

base_dir = r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\pages"

for root, dirs, files in os.walk(base_dir):
    for filename in files:
        if filename.endswith(".dart"):
            path = os.path.join(root, filename)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()

            original = content
            
            # remove constants
            content = re.sub(r'const _teal\s*=\s*Color\(0xFF3AAFA9\);\n', '', content)
            content = re.sub(r'const _navy\s*=\s*Color\(0xFF1E2D7D\);\n', '', content)
            content = re.sub(r'const _navy\s*=\s*Color\(0xFF24326B\);\n', '', content) # alternative navy
            content = re.sub(r'const _starYellow\s*=\s*Color\(0xFFFFB800\);\n', '', content)
            content = re.sub(r'const _green\s*=\s*Color\(0xFF4CAF50\);\n', '', content)
            content = re.sub(r'const _orange\s*=\s*Color\(0xFFF59E0B\);\n', '', content)
            content = re.sub(r'const _red\s*=\s*Color\(0xFFE53E3E\);\n', '', content)
            
            # replace variables
            content = re.sub(r'\b_teal\b', 'AppColors.primary', content)
            content = re.sub(r'\b_navy\b', 'AppColors.secondary', content)
            content = re.sub(r'\b_starYellow\b', 'AppColors.warningYellow', content)
            content = re.sub(r'\b_green\b', 'AppColors.successGreen', content)
            content = re.sub(r'\b_orange\b', 'AppColors.warningYellow', content)
            content = re.sub(r'\b_red\b', 'AppColors.errorRed', content)
            
            # replace inline hardcoded colors if they exactly match apptheme
            content = content.replace('Color(0xFF3AAFA9)', 'AppColors.primary')
            content = content.replace('Color(0xFFE53E3E)', 'AppColors.errorRed')
            content = content.replace('Color(0xFF4CAF50)', 'AppColors.successGreen')
            content = content.replace('Color(0xFF1E2D7D)', 'AppColors.secondary')
            content = content.replace('Color(0xFF24326B)', 'AppColors.secondary')
            content = content.replace('Color(0xFFFFB800)', 'AppColors.warningYellow')
            content = content.replace('Color(0xFFF59E0B)', 'AppColors.warningYellow')
            content = content.replace('Color(0xFF25D366)', 'AppColors.successGreen')
            
            # Fix illegal `const AppColors.` usages which happens when we replaced a `const _teal` 
            content = re.sub(r'const\s+AppColors\.', 'AppColors.', content)
            
            if content != original:
                # Add import if missing
                if 'import \'package:lazuadry_mobile_fe/core/theme/app_theme.dart\';' not in content:
                    # insert after first import
                    content = re.sub(r"(import 'package:flutter/material\.dart';)", r"\1\nimport 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';", content)
                    
                with open(path, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Updated: {path}")

print("Done")
