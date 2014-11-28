#!/bin/bash

rsync -av --delete --exclude='src/out/' --exclude='*.git/' --exclude='*.hg/' --exclude='*.svn/' ~/src/chromium/ ~/chromium
