### ./src

* The `./objective` script watches this directory for changes.
* When a file is changed it is compiled into `./lib` or `./app` (depending which is present)
* After compile the corresponding test file is run.
* When a new file is created a corresponding test file is created in the `./spec` directory.
