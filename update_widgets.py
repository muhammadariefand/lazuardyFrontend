import os
import re

base_dir = r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\widgets"

for root, dirs, files in os.walk(base_dir):
    for filename in files:
        if filename.endswith(".dart"):
            path = os.path.join(root, filename)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()

            original = content
            
            content = re.sub(r'const _teal\s*=\s*Color\(0xFF3AAFA9\);\n', '', content)
            content = re.sub(r'const _navy\s*=\s*Color\(0xFF1E2D7D\);\n', '', content)
            
            content = re.sub(r'\b_teal\b', 'AppColors.primary', content)
            content = re.sub(r'\b_navy\b', 'AppColors.secondary', content)
            
            content = content.replace('Color(0xFF3AAFA9)', 'AppColors.primary')
            
            content = re.sub(r'const\s+AppColors\.', 'AppColors.', content)
            
            if content != original:
                if 'import \'package:lazuadry_mobile_fe/core/theme/app_theme.dart\';' not in content:
                    content = re.sub(r"(import 'package:flutter/material\.dart';)", r"\1\nimport 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';", content)
                    
                with open(path, "w", encoding="utf-8") as f:
                    f.write(content)
                print(f"Updated: {path}")

print("Done")
