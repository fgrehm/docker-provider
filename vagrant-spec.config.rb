Vagrant::Spec::Acceptance.configure do |c|
  c.component_paths << File.expand_path("../spec/acceptance", __FILE__)

  c.provider "docker",
    # wget http://bit.ly/vagrant-docker-precise -O precise.box
    box: "#{File.expand_path("../", __FILE__)}/precise.box",
    features: ['!suspend']
end
