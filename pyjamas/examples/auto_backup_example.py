import shutil
import os

def backup_folder(source_folder, backup_folder):
    try:
        # Check if the source folder exists
        if not os.path.exists(source_folder):
            print(f"Error: Source folder '{source_folder}' does not exist.")
            return

        # Create the backup folder if it doesn't exist
        if not os.path.exists(backup_folder):
            os.makedirs(backup_folder)

        # Copy contents of source folder to backup folder
        shutil.copytree(source_folder, os.path.join(backup_folder, os.path.basename(source_folder)))

        print(f"Backup completed successfully.")
    except Exception as e:
        print(f"Error: {e}")

# Example usage
source_folder = '/path/to/source_folder'
backup_folder = '/path/to/backup_folder'
