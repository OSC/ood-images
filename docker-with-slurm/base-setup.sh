#!/bin/bash
set -e

groupadd --gid 1001 ood
useradd --no-create-home --gid ood --uid 1001 ood
echo -n "ood" | passwd --stdin ood
