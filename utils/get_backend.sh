#!/bin/bash

get_better_backend() {
    if ! command -v glxinfo &> /dev/null; then
        echo "xrender"
        return
    fi

    if glxinfo >&1 | grep -q "direct rendering: Yes"; then
        echo "glx"
        return
    fi

    renderer_info=$(glxinfo -B | grep "OpenGL renderer string" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$renderer_info" == *"llvmpipe"* ]] || \
       [[ "$renderer_info" == *"softpipe"* ]] || \
       [[ "$renderer_info" == *"vmware"* ]]; then
        echo "xrender"
    else
        echo "glx"
    fi
}
