# Excel Process Validator

The purpose of the Excel Process Validator (EPV) software is to 
automatically check calibration and process control data stored in an 
Excel spreadsheet.

The software is generalized so that it can potentially read many 
different types of spreadsheets.

Planned stages of automated processing:

1. Invoke with a URL and an email address
2. Retrieve spreadsheet from URL
3. Pull data from spreadseet, checking against template
4. Check results
5. Email results

Currently, however, it can be invoked only be hand.


## Installation

- Dependencies:

  - If you are using Octave, EPV depends on the `io` package (recommended version 2.4.10)
  
     - This can typically be installed with `octave --no-gui --quiet --eval "pkg install -forge io"`

- Installation on Apple OSX or GNU/Linux using the shell:

    ```bash
    git clone https://github.com/TASBE/Excel_Process_Validator.git
    cd Excel_Process_Validator
    make install
    ```
    This will add the Excel_Process_Validator directory to the Matlab and/or GNU Octave searchpath. If both Matlab and GNU Octave are available on your machine, it will install Excel_Process_Validator for both.

- Installation on Windows (or manual installation on Mac/Linux):
  - Download the package from [GitHub](https://github.com/TASBE/Excel_Process_Validator)
  - Start Matlab or Octave
  - Go to the ``Excel_Process_Validator`` directory
  - Run the installation command by hand:
  
      ```
    epv_set_path(); savepath();
    ```
