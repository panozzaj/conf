#!/bin/bash

# --- Configuration ---
MAPPINGS_FILE="/tmp/git_reword_mappings.txt"
REWORD_COUNTER_FILE="/tmp/git_reword_counter.txt"
ORIGINAL_TODO_CAPTURE_FILE="/tmp/git_rebase_todo_original.txt"

# $1 is the path to the file Git wants us to edit.

if [[ "$(basename "$1")" == "git-rebase-todo" ]]; then
    rm -f "$MAPPINGS_FILE" "$REWORD_COUNTER_FILE" "$ORIGINAL_TODO_CAPTURE_FILE"
    touch "$MAPPINGS_FILE"
    echo "0" > "$REWORD_COUNTER_FILE"
    cp "$1" "$ORIGINAL_TODO_CAPTURE_FILE"

    REAL_EDITOR=${REAL_GIT_EDITOR:-vim}
    $REAL_EDITOR "$1"
    if [ $? -ne 0 ]; then
        echo "Real editor for todo list exited with an error. Aborting." >&2
        exit 1
    fi

    processed_todo_content=""
    current_reword_output_index=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^# || -z "$line" ]]; then
            processed_todo_content+="$line"$'\n'
            continue
        fi

        read -r cmd hash_val rest_of_line <<<"$line"

        # --- MODIFIED CONDITION TO INCLUDE 'r' ---
        if [[ ( "$cmd" == "reword" || "$cmd" == "r" ) && -n "$hash_val" ]]; then
        # --- END MODIFIED CONDITION ---
            printf "%s|%s\n" "$current_reword_output_index" "$rest_of_line" >> "$MAPPINGS_FILE"
            ((current_reword_output_index++))

            original_pick_line=$(grep -E "^pick[[:space:]]+$hash_val" "$ORIGINAL_TODO_CAPTURE_FILE" | head -1)
            original_msg_fragment=""
            if [[ -n "$original_pick_line" ]]; then
                original_msg_fragment="${original_pick_line#pick }"
                original_msg_fragment="${original_msg_fragment#* }"
            fi
            # Write back the command the user actually typed (r or reword) or normalize to 'reword'
            # Git accepts both. Using $cmd ensures we respect the user's choice from the todo.
            processed_todo_content+="$cmd $hash_val $original_msg_fragment"$'\n'
        else
            processed_todo_content+="$line"$'\n'
        fi
    done < "$1"

    echo -n "$processed_todo_content" > "$1"

elif [[ -f "$MAPPINGS_FILE" && -f "$REWORD_COUNTER_FILE" ]]; then
    current_reword_read_index=$(cat "$REWORD_COUNTER_FILE")
    new_message_line=$(grep "^$current_reword_read_index|" "$MAPPINGS_FILE")

    if [[ -n "$new_message_line" ]]; then
        new_message="${new_message_line#*$current_reword_read_index|}"
        printf "%b" "$new_message" > "$1"
        next_reword_index=$((current_reword_read_index + 1))
        echo "$next_reword_index" > "$REWORD_COUNTER_FILE"
    else
        REAL_EDITOR=${REAL_GIT_EDITOR:-vim}
        $REAL_EDITOR "$1"
        if [ $? -ne 0 ]; then
            exit 1
        fi
    fi
else
    REAL_EDITOR=${REAL_GIT_EDITOR:-vim}
    $REAL_EDITOR "$1"
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

exit 0
