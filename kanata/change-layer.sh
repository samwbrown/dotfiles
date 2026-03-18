#!/bin/bash

echo -n "{\"ChangeLayer\": {\"new\": \"$1\"}}" | nc -c localhost 8877
