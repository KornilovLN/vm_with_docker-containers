# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-18.04"
    config.vm.boot_timeout = 600 # Увеличиваем время ожидания загрузки до 10 минут
  
    # Первая виртуальная машина ---------------------------------------------
    # config.vm.define "vm1", autostart: true do |vm1|
    config.vm.define "vmdock1" do |vmdock1|
      vmdock1.vm.hostname = "vmdock1"
      vmdock1.vm.network "private_network", ip: "192.168.56.12"
      #vmdock1.vm.synced_folder "/home/leon/work/admin_working/new_razdel_in_vg2/zb_containers_web_server/shared_folder/", "/shared_folder" 
      #vmdock1.vm.synced_folder ".", "/vagrant", disabled: true
      vmdock1.vm.synced_folder "shared_folder", "/shared_folder"
      vmdock1.vm.synced_folder "app", "/app"


      # Копируем файл Dockerfile из синхронизированной директории shared_folder/app в /app на виртуальной машине
      vmdock1.vm.provision "shell", inline: <<-SHELL
        cp /shared_folder/app/Dockerfile /app/Dockerfile
      SHELL
  
      # Копируем файл Dockerfile из корневой директории проекта в /app на виртуальной машине
      #vmdock1.vm.provision "file", source: File.join(File.dirname(__FILE__), "Dockerfile"), destination: "/app/Dockerfile"

  
      # Копирование flask приложения в домашнюю директорию vm1
      # vm1.vm.provision "file", source: "sender.py", destination: "~/sender.py"

      vmdock1.vm.provision "shell", privileged: false, inline: <<-SHELL
        echo 'vagrant:vagrant' | sudo chpasswd
      SHELL

      # Настройка провайдера виртуальной машины (VirtualBox)
      vmdock1.vm.provider :virtualbox do |vb|
            vb.name = "vmdock1"
            vb.memory = 4096
            vb.cpus = 1

            # Проверяем, существует ли диск disk_vm1.vdi
            disk_path = File.join(Dir.pwd, "disk_vmdock1.vdi")
            unless File.exist?(disk_path)
              vb.customize ["createhd", "--filename", disk_path, "--size", 2 * 1024]
            end

            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", disk_path]

      end

      # Устанавливаем часовой пояс Europe/Moscow без интерактивного ввода
      vmdock1.vm.provision "shell", inline: <<-SHELL
        echo "Europe/Moscow" | sudo tee /etc/timezone > /dev/null
        sudo dpkg-reconfigure --frontend noninteractive tzdata
      SHELL

      # Провижнинг (настройка) виртуальной машины через shell скрипт
      vmdock1.vm.provision "shell", inline: <<-SHELL
            apt-get update
            apt install -y curl python3
            apt install -y python3-pip
            bash -c "echo '172.16.0.1 sdn.dc.cns.atom registry.dc.cns.atom' >> /etc/hosts"
            #bash -c "cd /vagrant/;./net-install.sh setup"
            apt-get update
            apt-get install -y docker.io git

            # Добавляем текущего пользователя в группу docker
            # и перезагружаем сессию текущего пользователя
            sudo usermod -aG docker ${USER}            
            #su - ${USER}

            # Устанавливаем права доступа к Docker сокету
            sudo chmod 666 /var/run/docker.sock

            # Перезагружаем службу Docker
            sudo systemctl restart docker

            # Обновляем группы для текущего пользователя
            newgrp docker

          
     SHELL

     



     #vmdock1.vm.provision "shell", path: "build_and_run.sh"
     #vmdock1.vm.provision "shell", path: File.join(File.dirname(__FILE__), "build_and_run.sh")

    end # --------------------------------------------------------------------

  end
