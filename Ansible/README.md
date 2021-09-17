YAML Scripts Created
--------------------------
```yaml
---
- name: Config ELK VM with Docker
  hosts: elk
  remote_user: azdmin
  become: true
  tasks:

    - name: Install Docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: latest

    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: latest

    - name: Install Docker module
      pip:
        name: docker
        state: latest

    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: "262144"
        state: present
        reload: yes

    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
          - 5601:5601
          - 9200:9200
          - 5044:5044

    - name: Enable service docker on boot
      systemd:
        name: docker
        enabled: true
---
- name: Config WebVM with Docker
  hosts: webservers
  become: true
  tasks:
  - name: docker.io
    apt:
      force_apt_get: yes
      update_cache: yes
      name: docker.io
      state: present

  - name: install pip3
    apt:
      force_apt_get: yes
      name: python3-pip
      state: present

  - name: install docker python mod
    pip:
      name: docker
      state: present

  - name: download and launch docker wc
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      published_ports: 80:80

  - name: enable docker service
    systemd:
      name: docker
      enabled: yes
---
- name: installing and launching filebeat
  hosts: 10.1.0.4
  become: yes
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start

  - name: enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes
---
- name: installing and launching metribeat
  hosts: 10.1.0.4
  become: yes
  tasks:

  - name: download metricbeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb

  - name: install metricbeat deb
    command: dpkg -i metricbeat-7.6.1-amd64.deb

  - name: drop in metricbeat.yml
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

  - name: enable and configure docker module
    command: metricbeat modules enable docker

  - name: setup metricbeat
    command: metricbeat setup

  - name: start metricbeat service
    command: service metricbeat start

  - name: metricbeat option
    command: metricbeat -e

  - name: enable service metricbeat on boot
    systemd:
      name: metricbeat
      enabled: yes
```