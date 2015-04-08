find -type f -printf '%b@ %p\0'| sort -z -k1n | xargs -0 -n1 | tail
