shared_examples "provider/provisioner/chef-solo" do |provider, options|
  box = options[:box_chef] || options[:box]
  if !box
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("provisioner_chef_solo")
    assert_execute("vagrant", "box", "add", "box", box)
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "provisions with chef-solo" do
    status("Test: basic cookbooks and recipes")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-chef-basic")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/basic$/)

    status("Test: works with roles")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-chef-basic-roles")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/basic-roles$/)
  end
end
