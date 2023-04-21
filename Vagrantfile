# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :debian do |debian|
    debian.vm.box = 'debian-wheezy-amd64'
    debian.vm.box_url = 'https://dl.dropboxusercontent.com/u/67225617/lxc-vagrant/lxc-wheezy64-puppet3-2013-07-27.box'
  end

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box_url = 'http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box'
    ubuntu.vm.box = 'ubuntu-12.04-amd64'
  end

  config.vm.define :redhat do |redhat|
    redhat.vm.box = 'rhel-6-amd64'
    redhat.vm.box_url = 'http://puppetlabs.s3.amazonaws.com/pub/rhel60_64.box'
  end

  config.vm.define :centos do |centos|
    centos.vm.box = 'centos-6-amd64'
    centos.vm.box_url = 'http://puppetlabs.s3.amazonaws.com/pub/centos4_64.box'
  end

  config.vm.define :freebsd do |freebsd|
    freebsd.vm.box = 'freebsd-9.1-amd64'
    freebsd.vm.box_url = 'https://github.com/downloads/xironix/freebsd-vagrant/freebsd_amd64_ufs.box'
  end

  config.vm.define :openbsd do |openbsd|
    openbsd.vm.box = 'openbsd-5.2-amd64'
    openbsd.vm.box_url = 'https://dl.dropbox.com/s/5ietqc3thdholuh/openbsd-52-64.box'
  end
end
