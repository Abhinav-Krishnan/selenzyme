# Updated Selenzyme Installation Files

## Usage

All setup files needed for the recommended installation process of the updated version of Selenzyme are included in this repository. Clone this and run `start_server.sh` in the cloned directory to handle the entire process.

This script will:
1. Build a docker container with all the required dependencies for the software installed
2. Clone the main Selenzyme repository to get the program files to be run
3. Setup the directory structure for the tool
4. Download the required datafiles
5. Finally, run the docker container also starting the Selenzyme web application within it
