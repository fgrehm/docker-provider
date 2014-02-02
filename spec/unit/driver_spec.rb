require 'spec_helper'

require 'docker-provider/driver'

describe VagrantPlugins::DockerProvider::Driver do
  let(:cmd_executed) { @cmd }
  let(:cid)          { 'side-1-song-10' }

  before do
    subject.stub(:execute) { |*args| @cmd = args.join(' ') }
  end

  describe '#create' do
    let(:params) { {
      image:    'jimi/hendrix:eletric-ladyland',
      cmd:      ['play', 'voodoo-chile'],
      ports:    '8080:80',
      volumes:  '/host/path:guest/path',
      name:     cid,
      hostname: 'jimi-hendrix'
    } }

    before { subject.create(params) }

    it 'runs a detached docker image' do
      expect(cmd_executed).to match(/^docker run .+ -d .+ #{Regexp.escape params[:image]}/)
    end

    it 'sets container name' do
      expect(cmd_executed).to match(/-name #{Regexp.escape params[:name]}/)
    end

    it 'forwards ports' do
      expect(cmd_executed).to match(/-p #{params[:ports]} .+ #{Regexp.escape params[:image]}/)
    end

    it 'shares folders' do
      expect(cmd_executed).to match(/-v #{params[:volumes]} .+ #{Regexp.escape params[:image]}/)
    end

    it 'sets the hostname if specified' do
      expect(cmd_executed).to match(/-h #{params[:hostname]} #{Regexp.escape params[:image]}/)
    end

    it 'executes the provided command' do
      expect(cmd_executed).to match(/#{Regexp.escape params[:image]} #{Regexp.escape params[:cmd].join(' ')}/)
    end
  end

  describe '#created?' do
    let(:result) { subject.created?(cid) }

    it 'performs the check on all containers list' do
      subject.created?(cid)
      expect(cmd_executed).to match(/docker ps \-a \-q/)
    end

    context 'when container exists' do
      before { subject.stub(execute: "foo\n#{cid}\nbar") }
      it { expect(result).to be_true }
    end

    context 'when container does not exist' do
      before { subject.stub(execute: "foo\n#{cid}extra\nbar") }
      it { expect(result).to be_false }
    end
  end

  describe '#running?' do
    let(:result) { subject.running?(cid) }

    it 'performs the check on the running containers list' do
      subject.running?(cid)
      expect(cmd_executed).to match(/docker ps \-q/)
      expect(cmd_executed).to_not include('-a')
    end

    context 'when container exists' do
      before { subject.stub(execute: "foo\n#{cid}\nbar") }
      it { expect(result).to be_true }
    end

    context 'when container does not exist' do
      before { subject.stub(execute: "foo\n#{cid}extra\nbar") }
      it { expect(result).to be_false }
    end
  end

  describe '#start' do
    context 'when container is running' do
      before { subject.stub(running?: true) }

      it 'does not start the container' do
        subject.should_not_receive(:execute).with('docker', 'start', cid)
        subject.start(cid)
      end
    end

    context 'when container is not running' do
      before { subject.stub(running?: false) }

      it 'starts the container' do
        subject.should_receive(:execute).with('docker', 'start', cid)
        subject.start(cid)
      end
    end
  end

  describe '#stop' do
    context 'when container is running' do
      before { subject.stub(running?: true) }

      it 'stops the container' do
        subject.should_receive(:execute).with('docker', 'stop', cid)
        subject.stop(cid)
      end
    end

    context 'when container is not running' do
      before { subject.stub(running?: false) }

      it 'does not stop container' do
        subject.should_not_receive(:execute).with('docker', 'stop', cid)
        subject.stop(cid)
      end
    end
  end

  describe '#inspect_container' do
    let(:data) { '[{"json": "value"}]' }

    before { subject.stub(execute: data) }

    it 'inspect_container the container' do
      subject.should_receive(:execute).with('docker', 'inspect', cid)
      subject.inspect_container(cid)
    end

    it 'parses the json output' do
      expect(subject.inspect_container(cid)).to eq('json' => 'value')
    end
  end
end
