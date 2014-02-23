Vagrant::Spec::Acceptance.configure do |c|
  c.component_paths << File.expand_path("../spec/acceptance", __FILE__)

  c.provider "docker",
    # TODO: CHANGE TO A BOX URL
    box: "/home/projects/oss/docker-provider/boxes/precise/precise.box",
    features: ['!suspend']
end
