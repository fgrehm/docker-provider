shared_examples "provider/network/forwarded_port" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("network_forwarded_port")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "properly configures forwarded ports" do
    status("Test: TCP forwarded port (default)")
    assert_network("http://localhost:8080/", 8080)
  end
end
