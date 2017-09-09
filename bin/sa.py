#!/usr/bin/env python

import logging
import subprocess
from concurrent.futures import ThreadPoolExecutor as Pool


dirs_to_sync = [ "~", 
                 "~/projects/docs-DIR/documentation",
                 "~/projects/docs-DIR/pers-docs",
                 "~/lisp/urban-farmer",
                 "~/lisp/common-socialisp" ]

dirs_to_sync = [ "~" ]



def sync_dir(dir):
    call(["git", "status"])
    # var = raw_input(

info = logging.getLogger(__name__).info

def callback(future):
    if future.exception() is not None:
        info("got exception: %s" % future.exception())
    else:
        info("process returned %d" % future.result())

def main():
    global dirs_to_sync
    print dirs_to_sync
    for curr_dir in dirs_to_sync:
        print curr_dir
        #sync_dir curr_dir

def parallel():
    logging.basicConfig(level=logging.INFO, format=("%(relativeCreated)04d " "%(levelname)-5s %(msg)s"))
    # wait for the process completion asynchronously
    info("begin waiting")
    pool = Pool(max_workers=5)
    f = pool.submit(subprocess.call, "sleep 2; echo done", shell=True)
    f.add_done_callback(callback)
    pool.shutdown(wait=False) # no .submit() calls after that point
    info("continue waiting asynchronously")

if __name__=="__main__":
    main()
