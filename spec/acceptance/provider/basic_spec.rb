# This tests the basic functionality of a provider: that it can run
# a machine, provide SSH access, and destroy that machine.
shared_examples "provider/basic" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "init", "box")
  end

  after do
    # Just always do this just in case
    execute("vagrant", "destroy", "--force", log: false)
  end

  def assert_running
    result = execute("vagrant", "ssh", "-c", "echo foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/foo\n$/)
  end

  def assert_not_running
    result = execute("vagrant", "ssh", "-c", "echo foo")
    expect(result).to exit_with(1)
  end

=begin
TODO(mitchellh): These all exit with exit code 0. Unsure if bug.

  it "can't halt before an up" do
    expect(execute("vagrant", "halt")).to exit_with(1)
  end

  it "can't resume before an up" do
    expect(execute("vagrant", "resume")).to exit_with(1)
  end

  it "can't suspend before an up" do
    expect(execute("vagrant", "suspend")).to exit_with(1)
  end
=end

  context "after an up" do
    before do
      assert_execute("vagrant", "up", "--provider=#{provider}")
    end

    after do
      assert_execute("vagrant", "destroy", "--force")
    end

    it "can manage machine lifecycle" do
      status("Test: machine is running after up")
      assert_running

      if !options[:features].include?("!suspend")
        status("Test: suspend")
        assert_execute("vagrant", "suspend")

        status("Test: ssh doesn't work during suspended state")
        assert_not_running

        status("Test: resume after suspend")
        assert_execute("vagrant", "resume")
        assert_running
      else
        status("Not testing 'suspend', provider doesn't support it")
      end

      if !options[:features].include?("!halt")
        status("Test: halt")
        assert_execute("vagrant", "halt")

        status("Test: ssh doesn't work during halted state")
        assert_not_running

        status("Test: up after halt")
        assert_execute("vagrant", "up")
        assert_running
      else
        status("Not testing 'halt', provider doesn't support it")
      end
    end
  end
end
