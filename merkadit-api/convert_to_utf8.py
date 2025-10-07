import os

# Carpeta raíz del proyecto
project_root = os.path.dirname(os.path.abspath(__file__))

def convert_file_to_utf8(file_path):
    try:
        # Intentar abrir como UTF-8
        with open(file_path, 'r', encoding='utf-8') as f:
            f.read()
        # Si no falla, ya está en UTF-8
        return False
    except UnicodeDecodeError:
        # Leer como ANSI/Windows-1252 y reescribir como UTF-8
        with open(file_path, 'r', encoding='cp1252', errors='replace') as f:
            content = f.read()
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True

def main():
    converted_files = []
    for root, dirs, files in os.walk(project_root):
        for file in files:
            if file.endswith('.py'):
                file_path = os.path.join(root, file)
                if convert_file_to_utf8(file_path):
                    converted_files.append(file_path)
    
    if converted_files:
        print("✅ Archivos convertidos a UTF-8:")
        for f in converted_files:
            print(f" - {f}")
    else:
        print("Todos los archivos Python ya estaban en UTF-8")

if __name__ == "__main__":
    main()
