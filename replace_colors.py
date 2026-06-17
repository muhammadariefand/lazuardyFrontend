import os
import re

files = [
    r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\pages\siswa\booking\pilih_tutor_page.dart",
    r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\pages\siswa\booking\pilih_kategori_page.dart",
    r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\pages\siswa\booking\pilih_jadwal_page.dart",
    r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\pages\siswa\booking\konfirmasi_booking_page.dart",
    r"d:\Coding\PAD2\lazuadry_mobile_fe\lib\presentation\pages\siswa\booking\booking_berhasil_page.dart"
]

for path in files:
    if not os.path.exists(path): continue
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # remove constants
    content = re.sub(r'const _teal\s*=\s*Color\(0xFF3AAFA9\);\n', '', content)
    content = re.sub(r'const _navy\s*=\s*Color\(0xFF1E2D7D\);\n', '', content)
    content = re.sub(r'const _starYellow\s*=\s*Color\(0xFFFFB800\);\n', '', content)
    content = re.sub(r'const _green\s*=\s*Color\(0xFF4CAF50\);\n', '', content)
    content = re.sub(r'const _orange\s*=\s*Color\(0xFFF59E0B\);\n', '', content)
    
    # replace variables
    content = re.sub(r'\b_teal\b', 'AppColors.primary', content)
    content = re.sub(r'\b_navy\b', 'AppColors.secondary', content)
    content = re.sub(r'\b_starYellow\b', 'AppColors.warningYellow', content)
    content = re.sub(r'\b_green\b', 'AppColors.successGreen', content)
    content = re.sub(r'\b_orange\b', 'AppColors.warningYellow', content)
    
    # replace inline hardcoded colors if they exactly match apptheme
    content = content.replace('Color(0xFF3AAFA9)', 'AppColors.primary')
    content = content.replace('Color(0xFFE53E3E)', 'AppColors.errorRed')
    content = content.replace('Color(0xFF4CAF50)', 'AppColors.successGreen')
    content = content.replace('Color(0xFF1E2D7D)', 'AppColors.secondary')
    
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
