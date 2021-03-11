#https://gist.github.com/danielepolencic/ef4ddb763fd9a18bf2f1eaaa2e337544
Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.cpus = 2
  end
  config.vm.provision "shell", path: "kubeadm_crio_all.sh"
  config.vm.synced_folder './', '/vagrant'


  config.vm.define :controlplane do |controlplane|
    controlplane.vm.box = "generic/ubuntu2004"
    controlplane.vm.hostname = "controlplane"
    controlplane.vm.network :private_network, ip: "10.0.0.10"
    controlplane.vm.provision :shell, privileged: true, path: "controlplane.sh"
  end

  %w{node01 node02}.each_with_index do |name, i|
    config.vm.define name do |node|
      node.vm.box = "generic/ubuntu2004"
      node.vm.hostname = name
      node.vm.network :private_network, ip: "10.0.0.#{i + 11}"
      node.vm.provision :shell, privileged: true, inline: <<-SHELL
      cat /vagrant/kubeadm.log | sed -n  -e '/kubeadm join /p' -e '/discovery-token-ca-cert-hash/p' | source /dev/stdin
      #echo 'Environment="KUBELET_EXTRA_ARGS=--node-ip=10.0.0.#{i + 11}"' | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
      #sudo systemctl daemon-reload
      #sudo systemctl restart kubelet
      SHELL
    end
  end
end