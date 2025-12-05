# Split ChatGPT Account Export Chats to Individual Chats

This PowerShell script helps you split large ChatGPT conversation export files into individual chat files. It is designed to manage and organize JSON-based conversation data exported from your ChatGPT account, especially when dealing with large exports containing multiple conversations.

## Features:
- **File Selection**: Use a Windows file picker dialog to choose your ChatGPT conversation export file for processing.
- **Automatic Directory Creation**: Automatically creates a "split" directory to store individual chat files.
- **Installation of `jq`**: Checks if the `jq` tool is installed on your system and prompts you to install it if it's missing. The script does not force installation and allows you to install `jq` manually if you prefer.
- **Split Functionality**: Supports splitting large JSON files into smaller, more manageable individual chat files based on the content.
- **Multiverse Viewer Integration**: After splitting the chats, you can use the **[Multiverse Viewer](https://github.com/akivacp/chatgpt-json-tree-viewer)** to navigate and explore the conversation data visually.

## Prerequisites:
- **Windows Operating System** (or Windows Subsystem for Linux - WSL if you're using Linux)
- **PowerShell** (pre-installed on Windows)

### Dependencies:
- **`jq`**: A command-line tool used for processing JSON files. The script checks if it's installed, and if not, it provides the option to install it via `winget`.

## Installation:
1. **Clone this repository**:
    ```bash
    git clone https://github.com/yourusername/ChatGPT-Conversations-Split-Merge.git
    ```

2. **Install `jq` manually**:
   - If you do not have `jq` installed on your system, you can install it manually by following these instructions:
     - Visit the [official jq website](https://stedolan.github.io/jq/download/) for installation instructions.
     - Alternatively, on Windows, you can install `jq` using `winget` (Windows Package Manager):
       ```bash
       winget install jqlang.jq
       ```

   **Note**: The script will check for `jq` installation and prompt you to install it automatically, but it will not force the installation.

## Usage:

1. **Run the script**: 
   After cloning the repository and ensuring that `jq` is installed, you can run the PowerShell script:
   ```bash
   .\unified_splitAndMergeChatGPT-Conversations-Public.ps1
   ````

2. **Select the ChatGPT conversation export JSON file**:
   - The script will open a file picker dialog where you can select the exported ChatGPT conversation JSON file containing multiple chats.
3. **Split the conversation**:
   - The script will automatically create a "split" directory and save smaller, individual chat files, making it easier to handle large conversation exports with multiple chats.

## How It Works:

- **Step 1**: The script prompts you to select a JSON file containing your ChatGPT conversation export with multiple chats.
- **Step 2**: It checks whether `jq` is installed. If not, it provides an option to install it manually using `winget`.
- **Step 3**: The script creates a directory for the split files (if it doesn’t already exist) and processes the input JSON file to generate individual chat files.

## Visualizing Your Chats:

Once you’ve split your JSON file into individual conversation files, you can use the **[Multiverse Viewer](https://github.com/akivacp/chatgpt-json-tree-viewer)** to navigate the data visually. This viewer allows you to:

- **Visualize the JSON data**: Explore your conversation data in an interactive, tree-based format.
- **Navigate easily**: The viewer is designed to be user-friendly, helping both developers and non-technical users understand the structure of their ChatGPT conversation data.

## License:

This script is licensed under the MIT License. Feel free to use, modify, and distribute it as needed.

## Disclaimer:

- The script installs external software (`jq`) to ensure proper functionality. The installation is optional and will not proceed without your consent.
- Use this script responsibly and avoid running it on files that contain sensitive or private information without proper precautions.
