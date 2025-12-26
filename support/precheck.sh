#!/bin/zsh

echo 'Checking dependencies...'
echo 

if [ ! -f "$HOME/.custom_aliases" ]
then
    touch "$HOME/.custom_aliases"
fi

# Check for SSH keys (RSA, ED25519, or ECDSA)
has_ssh_key=false

if [ -f "$HOME/.ssh/id_rsa" ] && [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    has_ssh_key=true
elif [ -f "$HOME/.ssh/id_ed25519" ] && [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    has_ssh_key=true
elif [ -f "$HOME/.ssh/id_ecdsa" ] && [ -f "$HOME/.ssh/id_ecdsa.pub" ]; then
    has_ssh_key=true
fi

if [ "$has_ssh_key" = false ]; then
    echo "No SSH keys found."
    echo ""
    
    if read -q "choice?Would you like to generate a new ED25519 SSH key? (y/n) "; then
        echo ""
        echo ""
        
        # Ensure .ssh directory exists
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        
        # Ask for email for the key comment
        echo -n "Enter your email address for the SSH key: "
        read email
        
        # Generate ED25519 key
        ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
        
        # Set proper permissions
        chmod 600 "$HOME/.ssh/id_ed25519"
        chmod 644 "$HOME/.ssh/id_ed25519.pub"
        
        echo ""
        echo "SSH key generated successfully!"
        echo "Public key location: $HOME/.ssh/id_ed25519.pub"
        echo "Remember to add this key to GitHub, GitLab, or your servers."
        echo ""
    else
        echo ""
        echo "Please generate SSH keys manually or copy them from a previous computer."
        exit
    fi
fi

confirm_or_exit "Do you have SSH keys linked that have access to everything important?"
confirm_or_exit "Have you signed into the Mac App Store manually?"
echo ''

echo 'XX -- Precheck done.'
