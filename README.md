A Batch file for exporting a directory of image sequences into individual shots. When running the batch file, point it to a project directory. For example: ExportAllShots.bat "C:\Users\Name\Desktop\ProjectDir" The directory format is as follows:



Project Dir
----ImageSequences
----------Shot1_sequence
----------------Shot1_0001
----------------Shot1_0002
----------------Shot1_0003
----------Shot2_sequence
----------Shot3_sequence
----FOR-DAVINCI
----------Videos

It will generate an mp4 for each sequence folder before exporting them to the Videos folder.
