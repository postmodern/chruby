# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = 'ubuntu-12.04-amd64'
  end

  config.vm.define :freebsd do |freebsd|
    freebsd.vm.box = 'freebsd-9.1-amd64'
  end

  config.vm.define :openbsd do |openbsd|
    openbsd.vm.box = 'openbsd-5.0-amd64'
  end
end
