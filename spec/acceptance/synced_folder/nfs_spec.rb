shared_examples "provider/synced_folder/nfs" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("synced_folder_nfs")

    vagrantfile = environment.workdir.join('Vagrantfile')
    new_vagrantfile = "Vagrant.require_plugin('docker-provider')\n#{vagrantfile.read}"
    new_vagrantfile.gsub!(/(config\.vm\.box = "box")/, "\\1\nconfig.vm.provider :docker do |docker|\ndocker.privileged = true\nend\n")
    new_vagrantfile.gsub!(/(, type: "nfs")/, '\1, mount_options: ["rw", "vers=3", "tcp", "nolock"]')
    vagrantfile.open('w') { |f| f.puts(new_vagrantfile) }

    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "properly configures NFS" do
    status("Test: mounts the NFS folder")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-nfs/foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: doesn't mount a disabled folder")
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result.exit_code).to eql(1)
  end
end
