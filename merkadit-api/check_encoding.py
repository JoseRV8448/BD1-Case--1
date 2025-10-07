import os

# Carpeta raíz del proyecto
project_root = os.path.dirname(os.path.abspath(__file__))

def check_utf8(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            f.read()
        return True
    except UnicodeDecodeError:
        return False

def main():
    non_utf8_files = []
    for root, dirs, files in os.walk(project_root):
        for file in files:
            if file.endswith('.py'):
                file_path = os.path.join(root, file)
                if not check_utf8(file_path):
                    non_utf8_files.append(file_path)
    
    if non_utf8_files:
        print("⚠️ Archivos que NO están en UTF-8:")
        for f in non_utf8_files:
            print(f" - {f}")
    else:
        print("✅ Todos los archivos Python están en UTF-8")

if __name__ == "__main__":
    main()
