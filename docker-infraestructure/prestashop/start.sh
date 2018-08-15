ansible-galaxy install -r requirements.yml
ansible-playbook --extra-vars="@vars/7.1.yml" main.yml
